################################################################################
#
# python-thingsboard-gateway
#
################################################################################

PYTHON_THINGSBOARD_GATEWAY_VERSION = 3.0.1.post0
PYTHON_THINGSBOARD_GATEWAY_SOURCE = thingsboard-gateway-$(PYTHON_THINGSBOARD_GATEWAY_VERSION).tar.gz
PYTHON_THINGSBOARD_GATEWAY_SITE = https://files.pythonhosted.org/packages/fd/e5/26fe94013c63f59a14bf326f93e11f5459bf53ebc4fedb2cf703bf1029e0
PYTHON_THINGSBOARD_GATEWAY_SETUP_TYPE = setuptools
PYTHON_THINGSBOARD_GATEWAY_LICENSE = Apache-2.0
PYTHON_THINGSBOARD_GATEWAY_LICENSE_FILES = LICENSE

define PYTHON_THINGSBOARD_GATEWAY_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(PYTHON_THINGSBOARD_GATEWAY_PKGDIR)S90thingsboard-gateway $(TARGET_DIR)/etc/init.d/S90thingsboard-gateway
	$(INSTALL) -m 755 -D $(PYTHON_THINGSBOARD_GATEWAY_PKGDIR)daemon.sh $(TARGET_DIR)/usr/sbin/daemon-app.sh
	$(INSTALL) -m 755 -D $(PYTHON_THINGSBOARD_GATEWAY_PKGDIR)S99daemon-thingsboard-gateway $(TARGET_DIR)/etc/init.d/S99daemon-thingsboard-gateway
endef

define PYTHON_THINGSBOARD_GATEWAY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(PYTHON_THINGSBOARD_GATEWAY_PKGDIR)thingsboard-gateway.service $(TARGET_DIR)/usr/lib/systemd/system/thingsboard-gateway.service
endef

$(eval $(python-package))
