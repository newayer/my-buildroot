################################################################################
#
# rkbin
#
################################################################################

RKBIN_VERSION = be8dfda922e26048857775630e9b6d7af40879d9
RKBIN_SITE = https://github.com/newayer/rkbin.git
RKBIN_SITE_METHOD = git

define HOST_RKBIN_INSTALL_CMDS
	mkdir -p $(BUILD_DIR)/rkbin
	cp -a $(@D)/* $(BUILD_DIR)/rkbin
endef

$(eval $(host-generic-package))
