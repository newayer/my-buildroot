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
WORKSITE_D_CONF_OPTS += -DWORK_MODE_PAVER=ON

else ifeq ($(BR2_PACKAGE_WORKSITE_D_RTK),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/rtk
WORKSITE_D_CONF_OPTS += -DWORK_MODE_RTK=ON

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

else ifeq ($(BR2_PACKAGE_WORKSITE_D_ACU),y)

WORKSITE_D_DEPENDENCIES = c-periphery
WORKSITE_D_SUBDIR=gateway/acu

else ifeq ($(BR2_PACKAGE_WORKSITE_D_IOT_FORWARD),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/iot_forward

else ifeq ($(BR2_PACKAGE_WORKSITE_D_SAT),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/sat

else ifeq ($(BR2_PACKAGE_WORKSITE_D_TRACKER),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/tracker

else ifeq ($(BR2_PACKAGE_WORKSITE_D_ANTL4),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/antl4

else ifeq ($(BR2_PACKAGE_WORKSITE_D_KU768),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/ku768

else ifeq ($(BR2_PACKAGE_WORKSITE_D_RADAR),y)

WORKSITE_D_DEPENDENCIES = python3
WORKSITE_D_SUBDIR=gateway/python/radar

endif

$(eval $(cmake-package))
