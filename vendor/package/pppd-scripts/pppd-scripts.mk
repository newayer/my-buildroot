################################################################################
#
# pppd-scripts
#
################################################################################

PPPD_SCRIPTS_VERSION = 1.0.0
PPPD_SCRIPTS_SITE = $(PPPD_SCRIPTS_PKGDIR)files
PPPD_SCRIPTS_SITE_METHOD = local

define PPPD_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/S45pppd $(TARGET_DIR)/etc/init.d/S45pppd
endef

define PPPD_SCRIPTS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(PPPD_SCRIPTS_PKGDIR)files/pppd.service $(TARGET_DIR)/usr/lib/systemd/system/pppd.service
endef

define PPPD_SCRIPTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/sysctl.conf $(TARGET_DIR)/etc/sysctl.conf
	cp -r $(PPPD_SCRIPTS_PKGDIR)files/ppp $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))
