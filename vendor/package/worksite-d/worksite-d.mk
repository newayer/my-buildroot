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
WORKSITE_D_SUBDIR=legcy/paver/legcy

define WORKSITE_D_BUILD_CMDS
       $(MAKE) -C $(WORKSITE_D_SRCDIR)/libs/snapshot $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
       $(MAKE) -C $(WORKSITE_D_SRCDIR) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
endef

define WORKSITE_D_INSTALL_TARGET_CMDS
       $(MAKE) -C $(WORKSITE_D_SRCDIR)/libs/snapshot $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) install
       $(MAKE) -C $(WORKSITE_D_SRCDIR) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) install
       echo -n $(WORKSITE_D_VERSION) > $(TARGET_DIR)/etc/version
endef

else ifeq ($(BR2_PACKAGE_WORKSITE_D_UAV),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/uav

else ifeq ($(BR2_PACKAGE_WORKSITE_D_TIANTONG),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/tiantong

else ifeq ($(BR2_PACKAGE_WORKSITE_D_STORAGE),y)

WORKSITE_D_DEPENDENCIES = c-periphery
WORKSITE_D_SUBDIR=gateway/storage
ifeq ($(BR2_STORAGE_RS422),y)
WORKSITE_D_CONF_OPTS += -DENABLE_RS422=ON
endif

endif

ifeq ($(BR2_PACKAGE_WORKSITE_D_PAVER),y)
$(eval $(generic-package))
else
$(eval $(cmake-package))
endif
