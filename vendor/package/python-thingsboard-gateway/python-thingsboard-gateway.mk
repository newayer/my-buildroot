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

$(eval $(python-package))
