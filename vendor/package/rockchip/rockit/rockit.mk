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

define ROCKIT_INSTALL_FIRMWARE
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware
	$(INSTALL) -D -m 0644 $(@D)/hpmcu_wrap.bin $(TARGET_DIR)/lib/firmware/hpmcu_wrap.bin
endef

ROCKIT_POST_INSTALL_TARGET_HOOKS += ROCKIT_INSTALL_FIRMWARE

$(eval $(kernel-module))
$(eval $(generic-package))
