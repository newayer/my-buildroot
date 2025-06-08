################################################################################
#
# python-pynmeagps
#
################################################################################

PYTHON_PYNMEAGPS_VERSION = 1.0.50
PYTHON_PYNMEAGPS_SOURCE = pynmeagps-$(PYTHON_PYNMEAGPS_VERSION).tar.gz
PYTHON_PYNMEAGPS_SITE = https://files.pythonhosted.org/packages/8d/d3/dc24ed8a0e429105b20bfbf5d8155659d4f1439bad203ad46a9cdd1fc9d0
PYTHON_PYNMEAGPS_SETUP_TYPE = setuptools
PYTHON_PYNMEAGPS_LICENSE = MIT
PYTHON_PYNMEAGPS_LICENSE_FILES = LICENSE

$(eval $(python-package))
