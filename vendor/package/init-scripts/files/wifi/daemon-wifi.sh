#!/bin/sh
# daemon-wifi.sh : 按 /tmp/wifi_mode 分模式轻量看护
#   STA: wpa_supplicant 不在 或 wlan0 无 IP -> 重启 wpa_supplicant + udhcpc
#   AP : hostapd 不在 -> 重启 hostapd；dnsmasq 不在 -> 重启 dnsmasq
#        br-lan 上若没有 192.168.1.1 则补回

MODE_FILE="/tmp/wifi_mode"
WIFI_IF="wlan0"
BR="br-lan"

get_mode() {
    [ -f "$MODE_FILE" ] && cat "$MODE_FILE" || echo "ap"
}

sta_watch() {
    if ! pidof wpa_supplicant >/dev/null 2>&1; then
        echo "[daemon-wifi] wpa_supplicant gone, restart"
        wpa_supplicant -B -i "$WIFI_IF" -c /etc/wpa_supplicant.conf 2>/dev/null
        sleep 3
    fi
    if ! ip -4 addr show "$WIFI_IF" 2>/dev/null | grep -q "inet "; then
        echo "[daemon-wifi] $WIFI_IF no ip, re-dhcp"
        killall udhcpc 2>/dev/null
        udhcpc -i "$WIFI_IF" -b -q -t 5 -T 3 2>/dev/null
    fi
}

ap_watch() {
    if ! pidof hostapd >/dev/null 2>&1; then
        echo "[daemon-wifi] hostapd gone, restart"
        hostapd -B /etc/hostapd.conf 2>/dev/null
    fi
    if ! pidof dnsmasq >/dev/null 2>&1; then
        echo "[daemon-wifi] dnsmasq gone, restart"
        dnsmasq -C /etc/dnsmasq.conf 2>/dev/null
    fi
    if ! ip -4 addr show "$BR" 2>/dev/null | grep -q "192.168.1.1"; then
        echo "[daemon-wifi] $BR lost 192.168.1.1, restore"
        ip addr add 192.168.1.1/24 dev "$BR" 2>/dev/null
    fi
}

while :; do
    sleep 30
    case "$(get_mode)" in
        sta) sta_watch ;;
        ap) ap_watch ;;
    esac
done
