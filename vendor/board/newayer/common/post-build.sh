#!/bin/sh

BOARD_DIR="$(dirname $0)"

#default ssh keys

chmod 0600 $TARGET_DIR/etc/ssh/*_key
chmod 0644 $TARGET_DIR/etc/ssh/*_key.pub

sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' $TARGET_DIR/etc/ssh/sshd_config
sed -i 's/\#ClientAliveInterval.*/ClientAliveInterval 60/' $TARGET_DIR/etc/ssh/sshd_config

#root user ssh key
chmod 0700 $TARGET_DIR/root/.ssh
chmod 0600 $TARGET_DIR/root/.ssh/id_rsa
chmod 0644 $TARGET_DIR/root/.ssh/id_rsa.pub
chmod 0644 $TARGET_DIR/root/.ssh/authorized_keys
chmod 0644 $TARGET_DIR/root/.ssh/config
