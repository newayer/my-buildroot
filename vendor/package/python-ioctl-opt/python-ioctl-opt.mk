################################################################################
#
# python ioctl-opt
#
################################################################################

PYTHON_IOCTL_OPT_VERSION = 1.3
PYTHON_IOCTL_OPT_SOURCE = ioctl-opt-$(PYTHON_IOCTL_OPT_VERSION).tar.gz
PYTHON_IOCTL_OPT_SITE = https://files.pythonhosted.org/packages/33/58/4e7c0921c0e92dd18928043ce167952d6201206703ff31c44e3477523362
PYTHON_IOCTL_OPT_SETUP_TYPE = setuptools
PYTHON_IOCTL_OPT_LICENSE = Apache-2.0
PYTHON_IOCTL_OPT_LICENSE_FILES = LICENSE

$(eval $(python-package))
