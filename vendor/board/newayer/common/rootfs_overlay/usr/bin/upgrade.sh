#!/bin/sh

echo "`date "+%Y-%m-%d %H:%M:%S"`: upgrade begin..."

rm -fr /opt/upgrade
mkdir -p /opt/upgrade
cd /opt/upgrade

echo "`date "+%Y-%m-%d %H:%M:%S"`: new version:$1, download file:$2 and it's md5sum:$3."

old_version=`cat /opt/.release`

if [ "${old_version}" == "$1" ] ; then
    echo "`date "+%Y-%m-%d %H:%M:%S"`: the firmware's version is same as target upgrade package."
    exit 1
fi

echo "`date "+%Y-%m-%d %H:%M:%S"`: upgrade firmware from ${old_version} to $1."

wget -O upgrade.zip $2 >> /opt/logs/main_error.log 2>&1
returnValue=$?
if [ $returnValue = 0 ] ; then
    echo "`date "+%Y-%m-%d %H:%M:%S"`: download file successful."
else
    echo "`date "+%Y-%m-%d %H:%M:%S"`: download file failed."
    exit 2
fi

echo "$3  upgrade.zip" | md5sum -cs
returnValue2=$?
if [ $returnValue2 = 0 ] ; then
    echo "`date "+%Y-%m-%d %H:%M:%S"`: md5 verify successful."
else
    echo "`date "+%Y-%m-%d %H:%M:%S"`: md5 verify failed."
    exit 3
fi

unzip ./upgrade.zip

if [ -f "./upgrade.sh" ]
then
    chmod 755 ./upgrade.sh
    ./upgrade.sh
else
    echo "`date "+%Y-%m-%d %H:%M:%S"`: upgrade package is invalid."
    exit 4
fi

echo -n $1 > /opt/.release

echo "`date "+%Y-%m-%d %H:%M:%S"`: upgrade end."

exit 0

