################################################################################
#
# kernel-module-rockit
#
################################################################################

ROCKIT_VERSION = 1.0.0
ROCKIT_SITE = $(ROCKIT_PKGDIR)src
ROCKIT_SITE_METHOD = local

ROCKIT_MODULE_MAKE_OPTS = KERNEL_DIR=$(LINUX_DIR) \
			  CONFIG_ROCKCHIP_RV1106_ROCKIT=m \
			  KBUILD_EXTRA_SYMBOLS=$(KMPP_DIR)/Module.symvers

$(eval $(kernel-module))
$(eval $(generic-package))
