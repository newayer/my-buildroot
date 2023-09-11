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

if [ -e $TARGET_DIR/etc/network/interfaces ]; then
  echo "" >> $TARGET_DIR/etc/network/interfaces
  echo "auto eth0" >> $TARGET_DIR/etc/network/interfaces
  echo "iface eth0 inet static" >> $TARGET_DIR/etc/network/interfaces
  echo "	address 192.168.117.136/24" >> $TARGET_DIR/etc/network/interfaces
  echo "	gateway 192.168.117.1" >> $TARGET_DIR/etc/network/interfaces

  echo "" >> $TARGET_DIR/etc/network/interfaces
  echo "auto eth1" >> $TARGET_DIR/etc/network/interfaces
  echo "iface eth1 inet static" >> $TARGET_DIR/etc/network/interfaces
  echo "	address 192.168.117.136/24" >> $TARGET_DIR/etc/network/interfaces
  echo "	gateway 192.168.117.1" >> $TARGET_DIR/etc/network/interfaces

fi
