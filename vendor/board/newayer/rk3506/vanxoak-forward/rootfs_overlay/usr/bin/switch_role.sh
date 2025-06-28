#!/bin/bash

# 检查参数数量
if [ $# -ne 1 ]; then
    echo "Usage: $0 <mode>"
    echo "Modes: che, chuan"
    exit 1
fi

MODE="$1"

case "$MODE" in
    chuan)
        FILE="/etc/init.d/S99routing"
        if [ -f "$FILE" ]; then
            sed -i \
                -e 's|REMOTE_ETH1=192.168.1.0|REMOTE_ETH1=192.168.2.0|g' \
                -e 's|REMOTE_ETH0=192.168.91.23|REMOTE_ETH0=192.168.91.25|g' \
                "$FILE"
            echo "替换完成: $FILE"
        else
            echo "文件不存在: $FILE"
        fi

        FILE1="/etc/network/interfaces"
        if [ -f "$FILE1" ]; then
            sed -i \
                -e 's|address 192.168.91.25|address 192.168.91.23|g' \
                -e 's|address 192.168.2.1|address 192.168.1.1|g' \
                "$FILE1"
            echo "替换完成: $FILE1"
        else
            echo "文件不存在: $FILE1"
        fi

        FILE2="/usr/local/lib/main.py"
        if [ -f "$FILE2" ]; then
            sed -i "s|default='client'|default='server'|g" "$FILE2"
            echo "替换完成: $FILE2"
        else
            echo "文件不存在: $FILE2"
        fi

        echo -n iot-chuan > /etc/hostname
        ;;


    che)
        FILE="/etc/init.d/S99routing"
        if [ -f "$FILE" ]; then
            sed -i \
                -e 's|REMOTE_ETH1=192.168.2.0|REMOTE_ETH1=192.168.1.0|g' \
                -e 's|REMOTE_ETH0=192.168.91.25|REMOTE_ETH0=192.168.91.23|g' \
                "$FILE"
            echo "替换完成: $FILE"
        else
            echo "文件不存在: $FILE"
        fi

        FILE1="/etc/network/interfaces"
        if [ -f "$FILE1" ]; then
            sed -i \
                -e 's|address 192.168.91.23|address 192.168.91.25|g' \
                -e 's|address 192.168.1.1|address 192.168.2.1|g' \
                "$FILE1"
            echo "替换完成: $FILE1"
        else
            echo "文件不存在: $FILE1"
        fi

        FILE2="/usr/local/lib/main.py"
        if [ -f "$FILE2" ]; then
            sed -i "s|default='server'|default='client'|g" "$FILE2"
            echo "替换完成: $FILE2"
        else
            echo "文件不存在: $FILE2"
        fi

        echo -n iot-che > /etc/hostname
        ;;

    *)
        echo "错误: 未知模式 '$MODE'"
        echo "可用模式: che, chuan"
        exit 1
        ;;
esac

echo "操作执行模式: $MODE"
exit 0
