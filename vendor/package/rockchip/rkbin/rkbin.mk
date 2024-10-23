################################################################################
#
# rkbin
#
################################################################################

RKBIN_VERSION = a2a0b89b6c8c612dca5ed9ed8a68db8a07f68bc0
RKBIN_SITE = https://github.com/rockchip-linux/rkbin.git
RKBIN_SITE_METHOD = git

define HOST_RKBIN_INSTALL_CMDS
	mkdir -p $(BUILD_DIR)/rkbin
	cp -a $(@D)/* $(BUILD_DIR)/rkbin
endef

$(eval $(host-generic-package))
