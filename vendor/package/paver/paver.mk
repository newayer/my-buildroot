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
endef

$(eval $(generic-package))
