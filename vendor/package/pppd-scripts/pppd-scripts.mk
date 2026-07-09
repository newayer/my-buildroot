################################################################################
#
# pppd-scripts
#
################################################################################

PPPD_SCRIPTS_VERSION = 1.0.0
PPPD_SCRIPTS_SITE = $(PPPD_SCRIPTS_PKGDIR)files
PPPD_SCRIPTS_SITE_METHOD = local

define PPPD_SCRIPTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/chat-5g-connect $(TARGET_DIR)/etc/ppp/peers/chat-5g-connect
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/chat-5g-disconnect $(TARGET_DIR)/etc/ppp/peers/chat-5g-disconnect
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/ppp_options $(TARGET_DIR)/etc/ppp/peers/ppp_options
endef

define PPPD_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/S45pppd $(TARGET_DIR)/etc/init.d/S45pppd
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/S99daemon-pppd $(TARGET_DIR)/etc/init.d/S99daemon-pppd
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/daemon-pppd.sh $(TARGET_DIR)/usr/sbin/daemon-pppd.sh
endef

$(eval $(generic-package))
