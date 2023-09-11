################################################################################
#
# paver
#
################################################################################

PAVER_VERSION = $(call qstrip,$(BR2_PACKAGE_PAVER_REPO_VERSION))
PAVER_SITE = $(call qstrip,$(BR2_PACKAGE_PAVER_REPO_URL))
PAVER_SITE_METHOD = git
PAVER_DEPENDENCIES = c-periphery wpa_supplicant luv lua-cjson lualogging luamqtt luaossl lua-periphery luasec openresty

define PAVER_BUILD_CMDS
	$(MAKE) -C $(@D)/paver/legcy/libs/snapshot $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
	$(MAKE) -C $(@D)/paver/legcy $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
endef

define PAVER_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/paver/legcy/libs/snapshot $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) install
	$(MAKE) -C $(@D)/paver/legcy $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) install
	echo -n $(PAVER_VERSION) > $(TARGET_DIR)/etc/version
	$(INSTALL) -m 755 -D $(PAVER_PKGDIR)daemon.sh $(TARGET_DIR)/usr/bin/daemon-app.sh
endef

define PAVER_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(PAVER_PKGDIR)S90paver $(TARGET_DIR)/etc/init.d/S90paver
endef

define PAVER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(PAVER_PKGDIR)paver.service $(TARGET_DIR)/usr/lib/systemd/system/paver.service
endef

$(eval $(generic-package))
