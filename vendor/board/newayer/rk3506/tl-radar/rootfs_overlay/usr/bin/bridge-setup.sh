#!/bin/sh

set -x

# 配置参数
BRIDGE_IFACE="br0"
LAN_IFACE="eth1"      # 连接本地交换机
WAN_IFACE="eth0"      # 连接卫星Modem

SATELLITE_MTU="1500"
LOCAL_MTU="1500"

echo "正在设置透明桥接..."

# 1. 创建桥接
brctl addbr $BRIDGE_IFACE
brctl stp $BRIDGE_IFACE off
brctl setfd $BRIDGE_IFACE 0

# 2. 设置MTU
ip link set $WAN_IFACE mtu $SATELLITE_MTU
ip link set $LAN_IFACE mtu $LOCAL_MTU

# 3. 启用接口并加入桥接
ip link set $LAN_IFACE up
ip link set $WAN_IFACE up
brctl addif $BRIDGE_IFACE $LAN_IFACE
brctl addif $BRIDGE_IFACE $WAN_IFACE

# 4. 启用桥接
ip link set $BRIDGE_IFACE up

# 5. 禁用桥接的IPv6（避免干扰）
echo 1 > /proc/sys/net/ipv6/conf/$BRIDGE_IFACE/disable_ipv6

# 6. 禁用接口的IP（确保透明）
ip addr flush dev $LAN_IFACE
ip addr flush dev $WAN_IFACE

echo "透明桥接设置完成"
echo "桥接接口: $BRIDGE_IFACE"
echo "成员接口: $LAN_IFACE, $WAN_IFACE"
