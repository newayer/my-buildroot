#!/bin/sh

set -e

MODE="$1"
INTERFACE="wlan0"

if [ "$MODE" != "ap" ] && [ "$MODE" != "sta" ]; then
    echo "Usage: $0 [ap|sta]"
    exit 1
fi

stop_services() {
    /etc/init.d/S99daemon-wifi stop || true
    killall hostapd 2>/dev/null || true
    killall dnsmasq 2>/dev/null || true
    killall wpa_supplicant 2>/dev/null || true
    killall udhcpc 2>/dev/null || true
    ifdown "$INTERFACE" 2>/dev/null || true
}

reset_interface() {
    ip link set "$INTERFACE" down
    ip addr flush dev "$INTERFACE"
}

start_ap() {
    echo "Starting AP mode..."

    ip addr add 192.168.1.1/24 dev "$INTERFACE"
    ip link set "$INTERFACE" up

    if [ -f /etc/hostapd.conf ]; then
        hostapd -B /etc/hostapd.conf
    else
        echo "Error: /etc/hostapd.conf not found"
        exit 1
    fi

    if [ -f /etc/dnsmasq.conf ]; then
        dnsmasq -C /etc/dnsmasq.conf
    else
        echo "Error: /etc/dnsmasq.conf not found"
        exit 1
    fi

    echo "AP mode started. SSID: MyPaver (adjust in hostapd.conf), IP: 192.168.1.1"
}

start_sta() {
    echo "Starting STA mode..."

    ifdown "$INTERFACE" 2>/dev/null || true
    ifup "$INTERFACE"

    # wpa_supplicant -B -i "$INTERFACE" -c /etc/wpa_supplicant.conf
    # udhcpc -i "$INTERFACE" -b

    /etc/init.d/S99daemon-wifi restart || true

    echo "STA mode started. Connecting to configured WiFi network..."
}

stop_services
reset_interface

case "$MODE" in
    ap)
        start_ap
        ;;
    sta)
        start_sta
        ;;
esac
