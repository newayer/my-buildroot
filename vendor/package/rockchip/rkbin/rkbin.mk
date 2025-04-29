################################################################################
#
# rkbin
#
################################################################################

RKBIN_VERSION = $(call qstrip,$(BR2_PACKAGE_RKBIN_VERSION))
RKBIN_SITE = git@github.com:newayer/rkbin.git
RKBIN_SITE_METHOD = git

define HOST_RKBIN_INSTALL_CMDS
	mkdir -p $(BUILD_DIR)/rkbin
	cp -a $(@D)/* $(BUILD_DIR)/rkbin
endef

$(eval $(host-generic-package))
