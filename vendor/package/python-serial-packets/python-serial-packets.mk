################################################################################
#
# python-serial-packets
#
################################################################################

PYTHON_SERIAL_PACKETS_VERSION = 0.2.3
PYTHON_SERIAL_PACKETS_SOURCE = serial_packets-$(PYTHON_SERIAL_PACKETS_VERSION).tar.gz
PYTHON_SERIAL_PACKETS_SITE = https://files.pythonhosted.org/packages/ef/1c/3e7620b920745eff5c3e0c47f108db26c216ba95f12b3671352b6d7dced4
PYTHON_SERIAL_PACKETS_SETUP_TYPE = setuptools

$(eval $(python-package))
