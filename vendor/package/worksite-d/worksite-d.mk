################################################################################
#
# worksite-d
#
################################################################################

WORKSITE_D_VERSION = $(call qstrip,$(BR2_PACKAGE_WORKSITE_D_VERSION))
WORKSITE_D_SITE = $(call qstrip,$(BR2_PACKAGE_WORKSITE_D_URL))
WORKSITE_D_SITE_METHOD = git

ifeq ($(BR2_PACKAGE_WORKSITE_D_PAVER),y)
WORKSITE_D_DEPENDENCIES = c-periphery wpa_supplicant luv lua-cjson lualogging luamqtt luaossl lua-periphery luasec openresty
else ifeq ($(BR2_PACKAGE_WORKSITE_D_UAV),y)
WORKSITE_D_DEPENDENCIES = python3
endif

ifeq ($(BR2_PACKAGE_WORKSITE_D_PAVER),y)
define WORKSITE_D_BUILD_CMDS
	$(MAKE) -C $(@D)/legcy/paver/legcy/libs/snapshot $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
	$(MAKE) -C $(@D)/legcy/paver/legcy $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
endef
endif

ifeq ($(BR2_PACKAGE_WORKSITE_D_PAVER),y)
define WORKSITE_D_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/legcy/paver/legcy/libs/snapshot $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) install
	$(MAKE) -C $(@D)/legcy/paver/legcy $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) install
	echo -n $(WORKSITE_D_VERSION) > $(TARGET_DIR)/etc/version
endef
else ifeq ($(BR2_PACKAGE_WORKSITE_D_UAV),y)
define WORKSITE_D_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/local/lib/
	$(INSTALL) -m 644 -D $(@D)/gateway/python/uav/main.py $(TARGET_DIR)/usr/local/lib/uav-convertor.py
	$(INSTALL) -m 644 -D $(@D)/gateway/python/uav/pppd_daemon.py $(TARGET_DIR)/usr/local/lib/pppd_daemon.py
	$(INSTALL) -m 644 -D $(@D)/gateway/python/my_asyncio.py $(TARGET_DIR)/usr/local/lib/my_asyncio.py
endef
else ifeq ($(BR2_PACKAGE_WORKSITE_D_STORAGE),y)
define WORKSITE_D_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 755 -D $(@D)/gateway/storage/build/storage $(TARGET_DIR)/usr/bin/storage
	$(INSTALL) -m 755 -D $(@D)/gateway/storage/build/storage_rs422 $(TARGET_DIR)/usr/bin/storage_rs422
	$(INSTALL) -m 644 -D $(@D)/gateway/storage/etc/FPGA_firmware.bin $(TARGET_DIR)/etc/FPGA_firmware.bin
endef
else ifeq ($(BR2_PACKAGE_WORKSITE_D_TIANTONG),y)
define WORKSITE_D_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/local/lib/
	$(INSTALL) -m 644 -D $(@D)/gateway/python/tiantong/main.py $(TARGET_DIR)/usr/local/lib/main.py
	$(INSTALL) -m 644 -D $(@D)/gateway/python/tiantong/pppd_daemon.py $(TARGET_DIR)/usr/local/lib/pppd_daemon.py
	$(INSTALL) -m 644 -D $(@D)/gateway/python/my_asyncio.py $(TARGET_DIR)/usr/local/lib/my_asyncio.py
endef
endif

ifeq ($(BR2_PACKAGE_WORKSITE_D_PAVER),y)
define WORKSITE_D_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S90worksite-d-paver $(TARGET_DIR)/etc/init.d/S90worksite-d
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)daemon-paver.sh $(TARGET_DIR)/usr/sbin/daemon-app.sh
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S99daemon-worksite-d $(TARGET_DIR)/etc/init.d/S99daemon-worksite-d
endef
else ifeq ($(BR2_PACKAGE_WORKSITE_D_UAV),y)
define WORKSITE_D_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S90worksite-d-uav $(TARGET_DIR)/etc/init.d/S90worksite-d
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)daemon-uav.sh $(TARGET_DIR)/usr/sbin/daemon-app.sh
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S99daemon-worksite-d $(TARGET_DIR)/etc/init.d/S99daemon-worksite-d
endef
else ifeq ($(BR2_PACKAGE_WORKSITE_D_STORAGE),y)
define WORKSITE_D_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S90worksite-d-storage $(TARGET_DIR)/etc/init.d/S90worksite-d
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)daemon-storage.sh $(TARGET_DIR)/usr/sbin/daemon-app.sh
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S99daemon-worksite-d $(TARGET_DIR)/etc/init.d/S99daemon-worksite-d
endef
else ifeq ($(BR2_PACKAGE_WORKSITE_D_TIANTONG),y)
define WORKSITE_D_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S90worksite-d-tiantong $(TARGET_DIR)/etc/init.d/S90worksite-d
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)daemon-tiantong.sh $(TARGET_DIR)/usr/sbin/daemon-app.sh
	$(INSTALL) -m 755 -D $(WORKSITE_D_PKGDIR)S99daemon-worksite-d $(TARGET_DIR)/etc/init.d/S99daemon-worksite-d
endef
endif

ifeq ($(BR2_PACKAGE_WORKSITE_D_PAVER),y)
define WORKSITE_D_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(WORKSITE_D_PKGDIR)worksite-d-paver.service $(TARGET_DIR)/usr/lib/systemd/system/worksite-d.service
endef
else ifeq ($(BR2_PACKAGE_WORKSITE_D_UAV),y)
define WORKSITE_D_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(WORKSITE_D_PKGDIR)worksite-d-uav.service $(TARGET_DIR)/usr/lib/systemd/system/worksite-d.service
endef
endif

$(eval $(generic-package))
