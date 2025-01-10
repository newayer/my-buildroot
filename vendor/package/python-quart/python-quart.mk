################################################################################
#
# python-quart
#
################################################################################

PYTHON_QUART_VERSION = 0.20.0
PYTHON_QUART_SOURCE = quart-$(PYTHON_QUART_VERSION).tar.gz
PYTHON_QUART_SITE = https://files.pythonhosted.org/packages/1d/9d/12e1143a5bd2ccc05c293a6f5ae1df8fd94a8fc1440ecc6c344b2b30ce13
PYTHON_QUART_SETUP_TYPE = setuptools
PYTHON_QUART_LICENSE = FIXME: license id couldn't be detected
PYTHON_QUART_LICENSE_FILES = LICENSE

$(eval $(python-package))
