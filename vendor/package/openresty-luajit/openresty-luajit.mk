################################################################################
#
# openresty-luajit
#
################################################################################

OPENRESTY_LUAJIT_VERSION = 1.21.4.1
OPENRESTY_LUAJIT_SOURCE = openresty-$(OPENRESTY_LUAJIT_VERSION).tar.gz
OPENRESTY_LUAJIT_SITE = https://openresty.org/download
OPENRESTY_LUAJIT_CPE_ID_VENDOR = luajit

OPENRESTY_LUAJIT_INSTALL_STAGING = YES

OPENRESTY_LUAJIT_PROVIDES = luainterpreter

ifeq ($(BR2_PACKAGE_OPENRESTY_LUAJIT_COMPAT52),y)
OPENRESTY_LUAJIT_XCFLAGS += -DLUAJIT_ENABLE_LUA52COMPAT
endif

# The luajit build procedure requires the host compiler to have the
# same bitness as the target compiler. Therefore, on a x86 build
# machine, we can't build luajit for x86_64, which is checked in
# Config.in. When the target is a 32 bits target, we pass -m32 to
# ensure that even on 64 bits build machines, a compiler of the same
# bitness is used. Of course, this assumes that the 32 bits multilib
# libraries are installed.
ifeq ($(BR2_ARCH_IS_64),y)
OPENRESTY_LUAJIT_HOST_CC = $(HOSTCC)
# There is no LUAJIT_ENABLE_GC64 option.
else
OPENRESTY_LUAJIT_HOST_CC = $(HOSTCC) -m32
OPENRESTY_LUAJIT_XCFLAGS += -DLUAJIT_DISABLE_GC64
endif

# We unfortunately can't use TARGET_CONFIGURE_OPTS, because the luajit
# build system uses non conventional variable names.
define OPENRESTY_LUAJIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX="/usr" \
		STATIC_CC="$(TARGET_CC)" \
		DYNAMIC_CC="$(TARGET_CC) -fPIC" \
		TARGET_LD="$(TARGET_CC)" \
		TARGET_AR="$(TARGET_AR) rcus" \
		TARGET_STRIP=true \
		TARGET_CFLAGS="$(TARGET_CFLAGS)" \
		TARGET_LDFLAGS="$(TARGET_LDFLAGS)" \
		HOST_CC="$(OPENRESTY_LUAJIT_HOST_CC)" \
		HOST_CFLAGS="$(HOST_CFLAGS)" \
		HOST_LDFLAGS="$(HOST_LDFLAGS)" \
		BUILDMODE=dynamic \
		XCFLAGS="$(OPENRESTY_LUAJIT_XCFLAGS)" \
		-C $(@D)/bundle/LuaJIT-2.1-20220411 amalg
endef

define OPENRESTY_LUAJIT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX="/usr" DESTDIR="$(STAGING_DIR)" LDCONFIG=true -C $(@D)/bundle/LuaJIT-2.1-20220411 install
endef

define OPENRESTY_LUAJIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX="/usr" DESTDIR="$(TARGET_DIR)" LDCONFIG=true -C $(@D)/bundle/LuaJIT-2.1-20220411 install
endef

define OPENRESTY_LUAJIT_INSTALL_SYMLINK
	ln -fs luajit $(TARGET_DIR)/usr/bin/lua
endef
OPENRESTY_LUAJIT_POST_INSTALL_TARGET_HOOKS += OPENRESTY_LUAJIT_INSTALL_SYMLINK

# host-efl package needs host-luajit to be linked dynamically.
define HOST_OPENRESTY_LUAJIT_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) PREFIX="$(HOST_DIR)" BUILDMODE=dynamic \
		TARGET_LDFLAGS="$(HOST_LDFLAGS)" \
		XCFLAGS="$(OPENRESTY_LUAJIT_XCFLAGS)" \
		-C $(@D)/bundle/LuaJIT-2.1-20220411 amalg
endef

define HOST_OPENRESTY_LUAJIT_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) PREFIX="$(HOST_DIR)" LDCONFIG=true -C $(@D)/bundle/LuaJIT-2.1-20220411 install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
