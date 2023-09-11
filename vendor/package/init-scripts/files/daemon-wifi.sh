#!/bin/sh

while :
do
	sleep 9

    wpaIsRun=$(ps -ef |grep "wpa_supplicant " |grep -v "grep")
    if [ "$wpaIsRun" ] ; then
        IP=$(ifconfig wlan0 | grep "inet addr:" | tr -d A-z: | awk {'print $1'})
        if [ "$IP" ] ; then
            curl --connect-timeout 5 -I www.baidu.com > /dev/null 2>&1
            if [ $? = 0 ] ; then
                continue
            fi
        fi
	else
		/etc/init.d/S30wpa_supplicant restart
		sleep 3
    fi

    /etc/init.d/S40network stop
	sleep 3
	/etc/init.d/S40network start

    for((i=1;i<=10;i++));
	do
		IP=$(ifconfig wlan0 | grep "inet addr:" | tr -d A-z: | awk {'print $1'})
		if [ "$IP" ] ; then
			break
		fi
		sleep 6
	done
done
