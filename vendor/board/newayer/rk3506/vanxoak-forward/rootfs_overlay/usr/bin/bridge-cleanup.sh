#!/bin/sh
# 桥接清理脚本

BRIDGE_IFACE="br0"
LAN_IFACE="eth1"
WAN_IFACE="eth0"

echo "清理桥接配置..."

# 1. 关闭并删除桥接
ip link set $BRIDGE_IFACE down 2>/dev/null
brctl delbr $BRIDGE_IFACE 2>/dev/null || true

# 2. 恢复接口状态
ip link set $LAN_IFACE up 2>/dev/null
ip link set $WAN_IFACE up 2>/dev/null

echo "桥接清理完成"
