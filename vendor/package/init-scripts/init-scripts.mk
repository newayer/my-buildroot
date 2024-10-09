################################################################################
#
# INIT_SCRIPTS
#
################################################################################

INIT_SCRIPTS_VERSION = 1.0.0
INIT_SCRIPTS_SITE = $(INIT_SCRIPTS_PKGDIR)files
INIT_SCRIPTS_SITE_METHOD = local

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_CAN),y)
define INSTALL_CAN_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/S41can $(TARGET_DIR)/etc/init.d/S41can
endef

define INSTALL_CAN_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(INIT_SCRIPTS_PKGDIR)files/can.service $(TARGET_DIR)/usr/lib/systemd/system/can.service
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_TIME),y)
define INSTALL_TIME_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/S50time $(TARGET_DIR)/etc/init.d/S50time
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_MOUNT),y)
define INSTALL_MOUNT_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/S10mount $(TARGET_DIR)/etc/init.d/S10mount
	$(INSTALL) -m 644 -D $(INIT_SCRIPTS_PKGDIR)files/mount_config $(TARGET_DIR)/etc/mount_config
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_DAEMON_WIFI),y)
define INSTALL_DAEMON_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/S99daemon-wifi $(TARGET_DIR)/etc/init.d/S99daemon-wifi
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/daemon-wifi.sh $(TARGET_DIR)/usr/sbin/daemon-wifi.sh
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_ADB),y)
define INSTALL_ADB_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/S50usbdevice $(TARGET_DIR)/etc/init.d/S50usbdevice
	$(INSTALL) -m 644 -D $(INIT_SCRIPTS_PKGDIR)files/usb_gadget_config $(TARGET_DIR)/etc/usb_gadget_config
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/S90usb0config $(TARGET_DIR)/etc/init.d/S90usb0config
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/usb_change.sh $(TARGET_DIR)/usr/bin/usb_change.sh
	$(INSTALL) -m 644 -D $(INIT_SCRIPTS_PKGDIR)files/50-usb.rules $(TARGET_DIR)/etc/udev/rules.d/50-usb.rules
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_NAT),y)
define INSTALL_NAT_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/S42nat $(TARGET_DIR)/etc/init.d/S42nat
endef
endif

define INIT_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL_CAN_INIT_SYSV)
	$(INSTALL_TIME_INIT_SYSV)
	$(INSTALL_MOUNT_INIT_SYSV)
	$(INSTALL_DAEMON_INIT_SYSV)
	$(INSTALL_ADB_INIT_SYSV)
	$(INSTALL_NAT_INIT_SYSV)
endef

define INIT_SCRIPTS_INSTALL_INIT_SYSTEMD
	$(INSTALL_CAN_INIT_SYSTEMD)
endef

$(eval $(generic-package))
