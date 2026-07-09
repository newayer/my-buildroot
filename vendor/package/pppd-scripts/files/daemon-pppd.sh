#!/bin/sh

ping_status() {
	ping -c 1 -I ppp0 47.108.173.96 > /dev/null 2>&1
	if [ $? = 0 ] ; then
		return 0
	fi
	ping -c 1 -I ppp0 www.baidu.com > /dev/null 2>&1
	if [ $? = 0 ] ; then
		return 0
	fi
	return 1
}

restart_pppd() {
	echo "restart pppd service" >> /opt/logs/main_error.log
	/etc/init.d/S45pppd restart
}

while true
do
	sleep 30
	IP=$(ifconfig ppp0 | grep "inet addr:" | tr -d A-z: | awk {'print $1'})
	if [ "$IP" ] ; then
		ping_status
		if [ $? = 0 ] ; then
			# normal
			continue
		fi
	fi
	restart_pppd
done
