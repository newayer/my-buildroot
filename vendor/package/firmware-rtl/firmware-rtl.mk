################################################################################
#
# firmware-rtl
#
################################################################################

FIRMWARE_RTL_VERSION = 1.0.0
FIRMWARE_RTL_SITE = $(FIRMWARE_RTL_PKGDIR)files
FIRMWARE_RTL_SITE_METHOD = local

define FIRMWARE_RTL_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware
	$(INSTALL) -D -m 0644 $(@D)/rtl8723* $(TARGET_DIR)/lib/firmware
endef

$(eval $(generic-package))

