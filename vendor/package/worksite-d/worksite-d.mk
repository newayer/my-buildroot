################################################################################
#
# worksite-d
#
################################################################################

WORKSITE_D_VERSION = $(call qstrip,$(BR2_PACKAGE_WORKSITE_D_VERSION))
WORKSITE_D_SITE = $(call qstrip,$(BR2_PACKAGE_WORKSITE_D_URL))
WORKSITE_D_SITE_METHOD = git

ifeq ($(BR2_PACKAGE_WORKSITE_D_PAVER),y)

WORKSITE_D_DEPENDENCIES = python3 c-periphery
WORKSITE_D_SUBDIR=gateway/python/paver

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
ifeq ($(BR2_STORAGE_K300),y)
WORKSITE_D_CONF_OPTS += -DENABLE_K300=ON
endif

else ifeq ($(BR2_PACKAGE_WORKSITE_D_ACU),y)

WORKSITE_D_DEPENDENCIES = c-periphery
WORKSITE_D_SUBDIR=gateway/acu

endif

$(eval $(cmake-package))
