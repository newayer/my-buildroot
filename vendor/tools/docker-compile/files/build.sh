#!/bin/bash

set -ex

# 使用华为云 Ubuntu 22.04 (jammy) 源
cat <<EOF >/etc/apt/sources.list
deb http://repo.huaweicloud.com/ubuntu/ jammy main restricted universe multiverse
deb http://repo.huaweicloud.com/ubuntu/ jammy-security main restricted universe multiverse
deb http://repo.huaweicloud.com/ubuntu/ jammy-updates main restricted universe multiverse
EOF

apt update
apt -y upgrade

# Buildroot 2023.02 / 2024.02 在 Ubuntu 22.04 上所需的基础依赖
apt -y install sed make binutils build-essential diffutils gcc g++ bash \
    patch gzip bzip2 perl tar cpio unzip rsync file bc findutils wget \
    ncurses-dev python3

# 可选但建议安装的辅助工具（git、flex、bison 等有时会被个别包用到）
apt -y install git flex bison libssl-dev vim

# 设置 locale
apt -y install locales apt-utils sudo
locale-gen en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# 清理
apt clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 替换 dash 为 bash（保留你原有的习惯）
rm /bin/sh
ln -s /bin/bash /bin/sh

# 用户管理（保留你原有的逻辑）
if [ "${HOST_USER}" != "root" ]; then
    echo "* enable custom user: ${HOST_USER}"
    groupadd -r -g ${HOST_GID} ${HOST_USER} || true
    useradd -u ${HOST_UID} -g ${HOST_GID} --create-home --shell /bin/bash ${HOST_USER} || true
    usermod -aG sudo ${HOST_USER}
    echo "${HOST_USER}:$PASSWORD" | chpasswd
fi

# 清理临时脚本
exec rm -f /build.sh

