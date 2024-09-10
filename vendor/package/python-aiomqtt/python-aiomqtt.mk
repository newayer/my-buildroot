################################################################################
#
# python-aiomqtt
#
################################################################################

PYTHON_AIOMQTT_VERSION = 2.3.0
PYTHON_AIOMQTT_SOURCE = aiomqtt-$(PYTHON_AIOMQTT_VERSION).tar.gz
PYTHON_AIOMQTT_SITE = https://files.pythonhosted.org/packages/db/c9/168e78bd35b21d9bdbb26178db33a8f265e4a69bb4193e72434e7cb3d1cd
PYTHON_AIOMQTT_SETUP_TYPE = setuptools
PYTHON_AIOMQTT_LICENSE = Apache-2.0
PYTHON_AIOMQTT_LICENSE_FILES = LICENSE

$(eval $(python-package))
