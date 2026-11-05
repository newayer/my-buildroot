#!/bin/sh
# 用法: wifi_mode_switch.sh [ap|sta]
#
# AP 模式:
#   - br-lan = eth1 + wlan0，br-lan 持有 192.168.1.1/24
#   - hostapd 绑定 br-lan，dnsmasq 服务 br-lan
#   - wlan0 上不允许有 IP（桥成员口不持 L3）
#
# STA 模式:
#   - wlan0 从 br-lan 移出，br-lan 保留（仅 eth1），IP 与 dnsmasq 继续服务 LAN
#   - wlan0 切 __sta，wpa_supplicant 连接外部 AP，udhcpc 获取 IP

set -e

MODE="$1"
WIFI_IF="wlan0"
BR="br-lan"
LAN_IP="192.168.1.1/24"
MODE_FILE="/tmp/wifi_mode"

if [ "$MODE" != "ap" ] && [ "$MODE" != "sta" ]; then
    echo "Usage: $0 [ap|sta]"
    exit 1
fi

log() { echo "[wifi-switch] $*"; }

# ---------------- 停止会干扰切换的服务 ----------------
stop_all_services() {
    log "stop services"
    /etc/init.d/S99daemon-wifi stop 2>/dev/null || true
    killall hostapd 2>/dev/null || true
    killall wpa_supplicant 2>/dev/null || true
    killall udhcpc 2>/dev/null || true
    # dnsmasq 不在此处杀，由 AP/STA 各自按需处理
}

# ---------------- 把 wlan0 从 br-lan 移出（幂等） ----------------
detach_wlan_from_bridge() {
    if brctl show "$BR" 2>/dev/null | grep -qw "$WIFI_IF"; then
        log "detach $WIFI_IF from $BR"
        ip link set "$WIFI_IF" down 2>/dev/null || true
        brctl delif "$BR" "$WIFI_IF" 2>/dev/null || true
    fi
}

# ---------------- 把 wlan0 加入 br-lan（幂等，且先清残留） ----------------
attach_wlan_to_bridge() {
    # 清理 STA 残留：udhcpc、wlan0 上的 IP、wlan0 相关的路由
    killall udhcpc 2>/dev/null || true
    ip addr flush dev "$WIFI_IF" 2>/dev/null || true
    ip route flush dev "$WIFI_IF" 2>/dev/null || true

    if ! brctl show "$BR" 2>/dev/null | grep -qw "$WIFI_IF"; then
        log "attach $WIFI_IF to $BR"
        brctl addif "$BR" "$WIFI_IF" 2>/dev/null || true
    fi
    ip link set "$WIFI_IF" up
}

# ---------------- 确保 br-lan 存在、eth1 在桥里、IP 在 ----------------
ensure_bridge_up() {
    if ! ip link show "$BR" >/dev/null 2>&1; then
        log "create $BR"
        brctl addbr "$BR"
    fi
    if ! brctl show "$BR" 2>/dev/null | grep -qw "eth1"; then
        ip link set eth1 up 2>/dev/null || true
        brctl addif "$BR" eth1 2>/dev/null || true
    fi
    ip link set eth1 up 2>/dev/null || true
    ip link set "$BR" up

    if ! ip -4 addr show "$BR" | grep -q "192.168.1.1"; then
        log "assign $LAN_IP to $BR"
        ip addr add "$LAN_IP" dev "$BR"
    fi
}

# ---------------- 无线模式切换（先 down 再 iw set type） ----------------
set_wifi_mode() {
    # $1 = __ap | __sta
    ip link set "$WIFI_IF" down 2>/dev/null || true
    if iw dev "$WIFI_IF" set type "$1" 2>/dev/null; then
        log "iw set type $1 ok"
    else
        case "$1" in
            __ap) iwconfig "$WIFI_IF" mode Master 2>/dev/null || true ;;
            __sta) iwconfig "$WIFI_IF" mode Managed 2>/dev/null || true ;;
        esac
        log "iwconfig fallback for $1"
    fi
}

# ---------------- 启动 AP ----------------
start_ap() {
    log "start AP mode"
    echo "ap" >"$MODE_FILE"

    killall udhcpc 2>/dev/null || true # 防止 STA 的 dhcp 客户端残留
    ensure_bridge_up
    set_wifi_mode __ap
    attach_wlan_to_bridge # 内部会 flush wlan0 的 IP

    if [ ! -f /etc/hostapd.conf ]; then
        log "ERROR: /etc/hostapd.conf not found"
        exit 1
    fi
    hostapd -B /etc/hostapd.conf

    if [ -f /etc/dnsmasq.conf ]; then
        if ! pidof dnsmasq >/dev/null 2>&1; then
            dnsmasq -C /etc/dnsmasq.conf
        fi
    else
        log "ERROR: /etc/dnsmasq.conf not found"
        exit 1
    fi

    log "AP started. br-lan=$LAN_IP, members: $(brctl show $BR | awk 'NR>1{print $NF}' | tr '\n' ' ')"
    /etc/init.d/S99daemon-wifi restart 2>/dev/null || true
}

# ---------------- 启动 STA ----------------
start_sta() {
    log "start STA mode"
    echo "sta" >"$MODE_FILE"

    # 1) wlan0 从桥里移出，br-lan 保留（只剩 eth1）
    detach_wlan_from_bridge
    # 2) 保证 br-lan 仍存在、eth1 在、IP 在 → eth1 侧 LAN 继续工作
    ensure_bridge_up
    # 3) wlan0 切 STA 并 up
    set_wifi_mode __sta
    ip link set "$WIFI_IF" up

    # 4) 起 wpa_supplicant
    if [ ! -f /etc/wpa_supplicant.conf ]; then
        log "ERROR: /etc/wpa_supplicant.conf not found"
        exit 1
    fi
    wpa_supplicant -B -i "$WIFI_IF" -c /etc/wpa_supplicant.conf

    # 5) 等链路 Connected 再 udhcpc（最多 15s）
    i=0
    while [ $i -lt 15 ]; do
        if iw dev "$WIFI_IF" link 2>/dev/null | grep -q "Connected"; then
            break
        fi
        sleep 1
        i=$((i + 1))
    done
    udhcpc -i "$WIFI_IF" -b -q -t 5 -T 3 || log "udhcpc failed, check uplink"

    log "STA started. br-lan members: $(brctl show $BR | awk 'NR>1{print $NF}' | tr '\n' ' ')"
    /etc/init.d/S99daemon-wifi restart 2>/dev/null || true
}

# ---------------- 主流程 ----------------
stop_all_services

case "$MODE" in
    ap) start_ap ;;
    sta) start_sta ;;
esac

exit 0
