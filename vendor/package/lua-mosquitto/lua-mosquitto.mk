################################################################################
#
# lua-mosquitto
#
################################################################################

LUA_MOSQUITTO_VERSION = 0.4.1-1
LUA_MOSQUITTO_NAME_UPSTREAM = lua-mosquitto
LUA_MOSQUITTO_SUBDIR = lua-mosquitto
LUA_MOSQUITTO_LICENSE = MIT
LUA_MOSQUITTO_LICENSE_FILES = $(LUA_MOSQUITTO_SUBDIR)/LICENSE
LUA_MOSQUITTO_DEPENDENCIES = mosquitto

$(eval $(luarocks-package))
