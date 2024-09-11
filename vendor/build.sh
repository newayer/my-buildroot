#!/bin/bash

if [ "$0" == "-bash" ]; then
    SOURCE_ACTION="yes"
fi

while getopts ':i' OPT; do
    case $OPT in
        i)
        INIT_DL="yes";;
        ?)
            echo "\nUsage: `basename $0` [-i] [xxxx_defconfig]"
        exit -1
        ;;
    esac
done

shift $(($OPTIND - 1))

config=$1
if [ -z $config ]; then
    config=luckfox_pico_defconfig
else
    config=$(basename $1)
fi

output_dir=../${config/%_defconfig/-output}

if [ "${INIT_DL}" == "yes" ]; then
    echo "init download dir for $config"
    make BR2_EXTERNAL=vendor O=${output_dir} ${config}
    make O=${output_dir} source
    exit 0
fi

echo "make O=${output_dir} $config"

export `env | grep PATH | sed 's/\mnt\/.*://g'`
export BR2_EXTERNAL=vendor

make O=${output_dir} $config

if [ "${SOURCE_ACTION}" != "yes" ]; then
    START_TIME=`date`
    make O=${output_dir}
    echo "build start time:${START_TIME}"
    echo " build  end time:`date`"
fi
