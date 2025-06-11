################################################################################
#
# python-statemachine
#
################################################################################

PYTHON_STATEMACHINE_VERSION = 2.5.0
PYTHON_STATEMACHINE_SOURCE = python_statemachine-$(PYTHON_STATEMACHINE_VERSION).tar.gz
PYTHON_STATEMACHINE_SITE = https://files.pythonhosted.org/packages/45/91/4f05f3931d1e9b1df71b17dc08c43feddf2bed7dbf13f95323df2cc8e340
PYTHON_STATEMACHINE_SETUP_TYPE = setuptools
PYTHON_STATEMACHINE_LICENSE = MIT
PYTHON_STATEMACHINE_LICENSE_FILES = LICENSE

$(eval $(python-package))
