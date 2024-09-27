#!/bin/sh

function app_restart()
{
    echo "`date "+%Y-%m-%d %H:%M:%S"`: main app restart..." >> /opt/logs/main_error.log
    /etc/init.d/S90worksite-d restart >> /opt/logs/main_error.log
}

function app_exist()
{
    for i in `pidof python3`;
    do
        app=`grep main.py /proc/$i/cmdline`
        if [ "$app" ] ; then
            return 1
        fi
    done
    return 0
}

mkdir -p /opt/logs

while :
do
    sleep 3

	app_exist
    if [ $? -eq 0 ]; then
        app_restart
        sleep 3
    fi
done
