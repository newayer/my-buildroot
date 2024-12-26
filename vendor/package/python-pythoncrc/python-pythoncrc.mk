################################################################################
#
# python-pythoncrc
#
################################################################################

PYTHON_PYTHONCRC_VERSION = 1.21
PYTHON_PYTHONCRC_SOURCE = pythoncrc-$(PYTHON_PYTHONCRC_VERSION).tar.gz
PYTHON_PYTHONCRC_SITE = https://files.pythonhosted.org/packages/de/3c/80805fb3ac84d121be9948d8d3c1d014ab636f230e400655538e77383372
PYTHON_PYTHONCRC_SETUP_TYPE = setuptools

$(eval $(python-package))
