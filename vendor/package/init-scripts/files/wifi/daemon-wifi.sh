#!/bin/sh

function ping_test() {
    for n in {1 2 3 4 5};
    do
        ping -c 3 -W 3 www.baidu.com > /dev/null 2>&1
        if [ $? = 0 ] ; then
            return 0
        fi
        sleep 3
    done

    return -1
}

while :
do
    sleep 30

    wpaIsRun=$(ps -ef |grep "wpa_supplicant " |grep -v "grep")
    if [ "$wpaIsRun" ] ; then
        IP=$(ifconfig wlan0 | grep "inet addr:" | tr -d A-z: | awk {'print $1'})
        if [ "$IP" ] ; then
            ping_test
            if [ $? = 0 ] ; then
                continue
            fi
        fi
    fi

    /etc/init.d/S40network restart

done

