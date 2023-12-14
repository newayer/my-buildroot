################################################################################
#
# rkbin
#
################################################################################

RKBIN_VERSION = 7c7b513f13fc6ff43b0eac0bd259001fd75185d7
RKBIN_SITE = https://github.com/rockchip-linux/rkbin.git
RKBIN_SITE_METHOD = git

define HOST_RKBIN_INSTALL_CMDS
	mkdir -p $(BUILD_DIR)/rkbin
	cp -a $(@D)/* $(BUILD_DIR)/rkbin
endef

$(eval $(host-generic-package))
