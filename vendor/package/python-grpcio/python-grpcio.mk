################################################################################
#
# python-grpcio
#
################################################################################

PYTHON_GRPCIO_VERSION = 1.44.0
PYTHON_GRPCIO_SOURCE = grpcio-$(PYTHON_GRPCIO_VERSION).tar.gz
PYTHON_GRPCIO_SITE = https://files.pythonhosted.org/packages/65/75/8b706e1170e2c7b6242b1675259e47986bb4fc490f29387989a965972e6e
PYTHON_GRPCIO_SETUP_TYPE = setuptools
PYTHON_GRPCIO_LICENSE = Apache-2.0
PYTHON_GRPCIO_LICENSE_FILES = LICENSE

$(eval $(python-package))
