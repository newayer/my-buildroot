################################################################################
#
# luamqtt
#
################################################################################

LUAMQTT_VERSION = 3.4.3-1
LUAMQTT_SUBDIR = luamqtt
LUAMQTT_LICENSE = MIT
LUAMQTT_LICENSE_FILES = $(LUAMQTT_SUBDIR)/LICENSE

LUAMQTT_DEPENDENCIES = luasocket

# 因为服务器上没有上传src.rock,现在是通过离线方式生成,
# 如果需要通过.rockspec来实现编译，那么需要把下面注释的行放开
#
#define LUAMQTT_EXTRACT_CMDS
#	true
#endef

#define LUAMQTT_INSTALL_TARGET_CMDS
#	cd $(@D) && \
#		LUAROCKS_CONFIG=$(LUAROCKS_CONFIG_FILE) \
#		$(LUAROCKS_RUN_CMD) build --keep --no-doc --deps-mode none \
#			--tree "$(TARGET_DIR)/usr" \
#			LUA_INCDIR="$(STAGING_DIR)/usr/include" \
#			LUA_LIBDIR="$(STAGING_DIR)/usr/lib" \
#			CC=$(TARGET_CC) \
#			LD=$(TARGET_CC) \
#			CFLAGS="$(LUAROCKS_CFLAGS)" \
#			LIBFLAG="-shared $(TARGET_LDFLAGS)" \
#			$(LUAMQTT_BUILD_OPTS) $(LUAMQTT_DL_DIR)/$(LUAMQTT_ROCKSPEC)
#endef

$(eval $(luarocks-package))
