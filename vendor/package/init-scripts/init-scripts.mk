################################################################################
#
# INIT_SCRIPTS
#
################################################################################

INIT_SCRIPTS_VERSION = 1.0.0
INIT_SCRIPTS_SITE = $(INIT_SCRIPTS_PKGDIR)files
INIT_SCRIPTS_SITE_METHOD = local

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_MOUNT_EMMC), y)
MOUNT_TYPE = emmc
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_MOUNT_NAND), y)
MOUNT_TYPE = spi_nand
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_MOUNT_NOR), y)
MOUNT_TYPE = spi_nor
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_LINK_RV1106), y)
LINK_TYPE = rv1106
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_LINK_RK3506), y)
LINK_TYPE = rk3506
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_ADB), y)
INIT_SCRIPT_USB_ADB=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_UMS), y)
INIT_SCRIPT_USB_UMS=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_MTP), y)
INIT_SCRIPT_USB_MTP=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_NTB), y)
INIT_SCRIPT_USB_NTB=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_ACM), y)
INIT_SCRIPT_USB_ACM=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_UAC1), y)
INIT_SCRIPT_USB_UAC1=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_UAC2), y)
INIT_SCRIPT_USB_UAC2=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_UVC), y)
INIT_SCRIPT_USB_UVC=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_RNDIS), y)
INIT_SCRIPT_USB_RNDIS=y
endif
ifeq ($(BR2_PACKAGE_INIT_SCRIPT_USB_HID), y)
INIT_SCRIPT_USB_HID=y
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_MOUNT),y)
define INSTALL_MOUNT_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/mount/S10mount $(TARGET_DIR)/etc/init.d/S10mount
	sed -i 's/@bootmedium@/$(MOUNT_TYPE)/g' $(TARGET_DIR)/etc/init.d/S10mount
	sed -i 's/@device_type@/$(LINK_TYPE)/g' $(TARGET_DIR)/etc/init.d/S10mount
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_TIME),y)
define INSTALL_TIME_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/time/S50time $(TARGET_DIR)/etc/init.d/S50time
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_ADB),y)
define INSTALL_ADB_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/usb/S50usbdevice $(TARGET_DIR)/etc/init.d/S50usbdevice
	echo -n > $(TARGET_DIR)/etc/usb_gadget_config
	if [ "${INIT_SCRIPT_USB_ADB}" = "y" ]; then \
		echo usb_adb_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_UMS}" = "y" ]; then \
		echo usb_ums_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_MTP}" = "y" ]; then \
		echo usb_mtp_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_NTB}" = "y" ]; then \
		echo usb_ntb_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_ACM}" = "y" ]; then \
		echo usb_acm_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_UAC1}" = "y" ]; then \
		echo usb_uac1_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_UAC2}" = "y" ]; then \
		echo usb_uac2_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_UVC}" = "y" ]; then \
		echo usb_uvc_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_RNDIS}" = "y" ]; then \
		echo usb_rndis_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
	if [ "${INIT_SCRIPT_USB_HID}" = "y" ]; then \
		echo usb_hid_en >> $(TARGET_DIR)/etc/usb_gadget_config; \
	fi
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_DAEMON_WIFI),y)
define INSTALL_DAEMON_INIT_SYSV
	sed -i '/wpa_conf/d' $(TARGET_DIR)/etc/network/interfaces
	sed -i 's%iface wlan0.*%&\n  wpa_conf /etc/wpa_supplicant.conf%g' $(TARGET_DIR)/etc/network/interfaces
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/wifi/S99daemon-wifi $(TARGET_DIR)/etc/init.d/S99daemon-wifi
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/wifi/daemon-wifi.sh $(TARGET_DIR)/usr/sbin/daemon-wifi.sh
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_NAT),y)
define INSTALL_NAT_INIT_SYSV
	$(INSTALL) -m 755 -D $(INIT_SCRIPTS_PKGDIR)files/nat/S42nat $(TARGET_DIR)/etc/init.d/S42nat
	$(INSTALL) -m 644 -D $(INIT_SCRIPTS_PKGDIR)files/nat/sysctl.conf $(TARGET_DIR)/etc/sysctl.conf
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_ETH),y)
SCRIPTS_STATIC_IFACE = $(call qstrip,$(BR2_PACKAGE_INIT_SCRIPT_ETH_NAME))
SCRIPTS_STATIC_IP = $(call qstrip,$(BR2_PACKAGE_INIT_SCRIPT_ETH_IP))
define INSTALL_ETH_INIT_SYSV
	sed -i "{:begin;/dns-nameservers/! {$!{N;b begin};};s/auto $(SCRIPTS_STATIC_IFACE).*dns-nameservers 8\.8\.8\.8//;};" $(TARGET_DIR)/etc/network/interfaces
	sed -i '/^$$/{N;/\n$$/D};' $(TARGET_DIR)/etc/network/interfaces
	( \
		SCRIPTS_STATIC_IP=$(SCRIPTS_STATIC_IP); \
		echo ; \
		echo "auto $(SCRIPTS_STATIC_IFACE)"; \
		echo "iface $(SCRIPTS_STATIC_IFACE) inet static"; \
		echo "  address $(SCRIPTS_STATIC_IP)"; \
		echo "  netmask 255.255.255.0"; \
		echo "  dns-nameservers 8.8.8.8"; \
	) >> $(TARGET_DIR)/etc/network/interfaces
endef
endif

ifeq ($(BR2_PACKAGE_INIT_SCRIPT_ETH2),y)
SCRIPTS_STATIC_IFACE2 = $(call qstrip,$(BR2_PACKAGE_INIT_SCRIPT_ETH2_NAME))
SCRIPTS_STATIC_IP2 = $(call qstrip,$(BR2_PACKAGE_INIT_SCRIPT_ETH2_IP))
define INSTALL_ETH2_INIT_SYSV
	sed -i "{:begin;/dns-nameservers/! {$!{N;b begin};};s/auto $(SCRIPTS_STATIC_IFACE2).*dns-nameservers 8\.8\.8\.8//;};" $(TARGET_DIR)/etc/network/interfaces
	sed -i '/^$$/{N;/\n$$/D};' $(TARGET_DIR)/etc/network/interfaces
	( \
		SCRIPTS_STATIC_IP2=$(SCRIPTS_STATIC_IP2); \
		echo ; \
		echo "auto $(SCRIPTS_STATIC_IFACE2)"; \
		echo "iface $(SCRIPTS_STATIC_IFACE2) inet static"; \
		echo "  address $(SCRIPTS_STATIC_IP2)"; \
		echo "  netmask 255.255.255.0"; \
		echo "  dns-nameservers 8.8.8.8"; \
	) >> $(TARGET_DIR)/etc/network/interfaces
endef
endif

define INIT_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL_MOUNT_INIT_SYSV)
	$(INSTALL_TIME_INIT_SYSV)
	$(INSTALL_ADB_INIT_SYSV)
	$(INSTALL_DAEMON_INIT_SYSV)
	$(INSTALL_NAT_INIT_SYSV)
	$(INSTALL_ETH_INIT_SYSV)
	$(INSTALL_ETH2_INIT_SYSV)
endef

$(eval $(generic-package))
