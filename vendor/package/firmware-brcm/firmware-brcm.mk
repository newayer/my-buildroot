################################################################################
#
# firmware-brcm
#
################################################################################

FIRMWARE_BRCM_VERSION = 1.0.0
FIRMWARE_BRCM_SITE = $(FIRMWARE_BRCM_PKGDIR)files
FIRMWARE_BRCM_SITE_METHOD = local

define FIRMWARE_BRCM_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/brcm
	$(INSTALL) -D -m 0644 $(@D)/brcm/brcmfmac43362-sdio.* $(TARGET_DIR)/lib/firmware/brcm
endef

$(eval $(generic-package))

