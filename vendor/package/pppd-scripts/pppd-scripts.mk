################################################################################
#
# pppd-scripts
#
################################################################################

PPPD_SCRIPTS_VERSION = 1.0.0
PPPD_SCRIPTS_SITE = $(PPPD_SCRIPTS_PKGDIR)files
PPPD_SCRIPTS_SITE_METHOD = local

ifeq ($(BR2_PACKAGE_PPPD_SCRIPTS_EC20),y)
define PPPD_SCRIPTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/sysctl.conf $(TARGET_DIR)/etc/sysctl.conf
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/chat-wcdma-connect $(TARGET_DIR)/etc/ppp/peers/chat-wcdma-connect
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/chat-wcdma-disconnect $(TARGET_DIR)/etc/ppp/peers/chat-wcdma-disconnect
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/ppp-wcdma $(TARGET_DIR)/etc/ppp/peers/ppp_options
endef
else ifeq ($(BR2_PACKAGE_PPPD_SCRIPTS_IRIDIUM),y)
define PPPD_SCRIPTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/chat-iridium-connect $(TARGET_DIR)/etc/ppp/peers/chat-iridium-connect
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/chat-iridium-disconnect $(TARGET_DIR)/etc/ppp/peers/chat-iridium-disconnect
	$(INSTALL) -m 644 -D $(PPPD_SCRIPTS_PKGDIR)files/ppp/peers/ppp-stream $(TARGET_DIR)/etc/ppp/peers/ppp_options
endef
endif

ifeq ($(BR2_PACKAGE_PPPD_SCRIPTS_EC20),y)
define PPPD_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/S45pppd $(TARGET_DIR)/etc/init.d/S45pppd
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/S99daemon-pppd $(TARGET_DIR)/etc/init.d/S99daemon-pppd
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/daemon-pppd.sh $(TARGET_DIR)/usr/sbin/daemon-pppd.sh
endef
else ifeq ($(BR2_PACKAGE_PPPD_SCRIPTS_IRIDIUM),y)
define PPPD_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/S45pppd-stream $(TARGET_DIR)/etc/init.d/S45pppd
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/S99daemon-pppd $(TARGET_DIR)/etc/init.d/S99daemon-pppd
	$(INSTALL) -m 755 -D $(PPPD_SCRIPTS_PKGDIR)files/daemon-pppd-stream.sh $(TARGET_DIR)/usr/sbin/daemon-pppd.sh
endef
endif

define PPPD_SCRIPTS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(PPPD_SCRIPTS_PKGDIR)files/pppd.service $(TARGET_DIR)/usr/lib/systemd/system/pppd.service
endef

$(eval $(generic-package))
