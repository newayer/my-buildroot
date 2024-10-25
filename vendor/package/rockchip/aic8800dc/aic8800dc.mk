################################################################################
#
# kernel-module-aic8800dc
#
################################################################################

AIC8800DC_VERSION = 1.0.0
AIC8800DC_SITE = $(AIC8800DC_PKGDIR)src
AIC8800DC_SITE_METHOD = local

AIC8800DC_MODULE_MAKE_OPTS = KERNEL_DIR=$(LINUX_DIR) \
			  CONFIG_AIC_WLAN_SUPPORT=m \
			  CONFIG_AIC8800_BTLPM_SUPPORT=m \
			  CONFIG_AIC8800_WLAN_SUPPORT=m

define AIC8800DC_INSTALL_FIRMWARE
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/aic8800
	$(INSTALL) -D -m 0644 $(@D)/aic8800dc_fw/* $(TARGET_DIR)/lib/firmware/aic8800
endef

AIC8800DC_POST_INSTALL_TARGET_HOOKS += AIC8800DC_INSTALL_FIRMWARE

$(eval $(kernel-module))
$(eval $(generic-package))
