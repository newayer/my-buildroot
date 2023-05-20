################################################################################
#
# openresty
#
################################################################################

OPENRESTY_VERSION = 1.21.4.1
OPENRESTY_SITE = https://openresty.org/download
OPENRESTY_DEPENDENCIES = \
	host-pkgconf openresty-luajit \
	$(if $(BR2_PACKAGE_LIBXCRYPT),libxcrypt)

OPENRESTY_CONF_OPTS = \
	--crossbuild=Linux::$(BR2_ARCH) \
	--with-cc="$(TARGET_CC)" \
	--with-cpp="$(TARGET_CC)" \
	--with-ld-opt="$(TARGET_LDFLAGS)"

# www-data user and group are used for nginx. Because these user and group
# are already set by buildroot, it is not necessary to redefine them.
# See system/skeleton/etc/passwd
#   username: www-data    uid: 33
#   groupname: www-data   gid: 33
#
# So, we just need to create the directories used by nginx with the right
# ownership.
define OPENRESTY_PERMISSIONS
	/var/lib/nginx d 755 33 33 - - - - -
endef

# disable external libatomic_ops because its detection fails.
OPENRESTY_CONF_ENV += \
	ngx_force_c_compiler=yes \
	ngx_force_c99_have_variadic_macros=yes \
	ngx_force_gcc_have_variadic_macros=yes \
	ngx_force_gcc_have_atomic=yes \
	ngx_force_have_epoll=yes \
	ngx_force_have_sendfile=yes \
	ngx_force_have_sendfile64=yes \
	ngx_force_have_pr_set_dumpable=yes \
	ngx_force_have_timer_event=yes \
	ngx_force_have_map_anon=yes \
	ngx_force_have_map_devzero=yes \
	ngx_force_have_sysvshm=yes \
	ngx_force_have_posix_sem=yes

# prefix: nginx root configuration location
OPENRESTY_CONF_OPTS += \
	--force-endianness=$(call qstrip,$(call LOWERCASE,$(BR2_ENDIAN))) \
	--prefix=/usr \
	--conf-path=/etc/nginx/nginx.conf \
	--sbin-path=/usr/sbin/nginx \
	--pid-path=/run/nginx.pid \
	--lock-path=/run/lock/nginx.lock \
	--user=www-data \
	--group=www-data \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--http-client-body-temp-path=/var/cache/nginx/client-body \
	--http-proxy-temp-path=/var/cache/nginx/proxy \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
	--http-scgi-temp-path=/var/cache/nginx/scgi \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi

OPENRESTY_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENRESTY_FILE_AIO),--with-file-aio) \
	$(if $(BR2_PACKAGE_OPENRESTY_THREADS),--with-threads)

ifeq ($(BR2_PACKAGE_LIBATOMIC_OPS),y)
OPENRESTY_DEPENDENCIES += libatomic_ops
OPENRESTY_CONF_OPTS += --with-libatomic
OPENRESTY_CONF_ENV += ngx_force_have_libatomic=yes
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
OPENRESTY_CFLAGS += "-DAO_NO_SPARC_V9"
endif
else
OPENRESTY_CONF_ENV += ngx_force_have_libatomic=no
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
OPENRESTY_DEPENDENCIES += pcre
OPENRESTY_CONF_OPTS += --with-pcre
else
OPENRESTY_CONF_OPTS += --without-pcre
endif

OPENRESTY_CONF_OPTS += --with-luajit=/usr/luajit

# modules disabled or not activated because of missing dependencies:
# - google_perftools  (googleperftools)
# - http_perl_module  (host-perl)
# - pcre-jit          (want to rebuild pcre)

# Notes:
# * Feature/module option are *not* symetric.
#   If a feature is on by default, only its --without-xxx option exists;
#   if a feature is off by default, only its --with-xxx option exists.
# * The configure script fails if unknown options are passed on the command
#   line.

# misc. modules
OPENRESTY_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENRESTY_SELECT_MODULE),--with-select_module,--without-select_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_POLL_MODULE),--with-poll_module,--without-poll_module)

ifneq ($(BR2_PACKAGE_OPENRESTY_ADD_MODULES),)
OPENRESTY_CONF_OPTS += \
	$(addprefix --add-module=,$(call qstrip,$(BR2_PACKAGE_OPENRESTY_ADD_MODULES)))
endif

# http server modules
ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP),y)
ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_CACHE),y)
OPENRESTY_DEPENDENCIES += openssl
else
OPENRESTY_CONF_OPTS += --without-http-cache
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_V2_MODULE),y)
OPENRESTY_DEPENDENCIES += zlib
OPENRESTY_CONF_OPTS += --with-http_v2_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_SSL_MODULE),y)
OPENRESTY_DEPENDENCIES += openssl
OPENRESTY_CONF_OPTS += --with-http_ssl_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_XSLT_MODULE),y)
OPENRESTY_DEPENDENCIES += libxml2 libxslt
OPENRESTY_CONF_OPTS += --with-http_xslt_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_IMAGE_FILTER_MODULE),y)
OPENRESTY_DEPENDENCIES += gd jpeg libpng
OPENRESTY_CONF_OPTS += --with-http_image_filter_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_GEOIP_MODULE),y)
OPENRESTY_DEPENDENCIES += geoip
OPENRESTY_CONF_OPTS += --with-http_geoip_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_GUNZIP_MODULE),y)
OPENRESTY_DEPENDENCIES += zlib
OPENRESTY_CONF_OPTS += --with-http_gunzip_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_GZIP_STATIC_MODULE),y)
OPENRESTY_DEPENDENCIES += zlib
OPENRESTY_CONF_OPTS += --with-http_gzip_static_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_SECURE_LINK_MODULE),y)
OPENRESTY_DEPENDENCIES += openssl
OPENRESTY_CONF_OPTS += --with-http_secure_link_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_GZIP_MODULE),y)
OPENRESTY_DEPENDENCIES += zlib
else
OPENRESTY_CONF_OPTS += --without-http_gzip_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_HTTP_REWRITE_MODULE),y)
OPENRESTY_DEPENDENCIES += pcre
else
OPENRESTY_CONF_OPTS += --without-http_rewrite_module
endif

OPENRESTY_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_REALIP_MODULE),--with-http_realip_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_ADDITION_MODULE),--with-http_addition_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_SUB_MODULE),--with-http_sub_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_DAV_MODULE),--with-http_dav_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_FLV_MODULE),--with-http_flv_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_MP4_MODULE),--with-http_mp4_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_AUTH_REQUEST_MODULE),--with-http_auth_request_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_RANDOM_INDEX_MODULE),--with-http_random_index_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_DEGRADATION_MODULE),--with-http_degradation_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_SLICE_MODULE),--with-http_slice_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_STUB_STATUS_MODULE),--with-http_stub_status_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_CHARSET_MODULE),,--without-http_charset_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_SSI_MODULE),,--without-http_ssi_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_USERID_MODULE),,--without-http_userid_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_ACCESS_MODULE),,--without-http_access_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_AUTH_BASIC_MODULE),,--without-http_auth_basic_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_AUTOINDEX_MODULE),,--without-http_autoindex_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_GEO_MODULE),,--without-http_geo_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_MAP_MODULE),,--without-http_map_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_SPLIT_CLIENTS_MODULE),,--without-http_split_clients_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_REFERER_MODULE),,--without-http_referer_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_PROXY_MODULE),,--without-http_proxy_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_FASTCGI_MODULE),,--without-http_fastcgi_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_UWSGI_MODULE),,--without-http_uwsgi_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_SCGI_MODULE),,--without-http_scgi_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_MEMCACHED_MODULE),,--without-http_memcached_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_LIMIT_CONN_MODULE),,--without-http_limit_conn_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_LIMIT_REQ_MODULE),,--without-http_limit_req_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_EMPTY_GIF_MODULE),,--without-http_empty_gif_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_BROWSER_MODULE),,--without-http_browser_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_UPSTREAM_IP_HASH_MODULE),,--without-http_upstream_ip_hash_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_UPSTREAM_LEAST_CONN_MODULE),,--without-http_upstream_least_conn_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_UPSTREAM_RANDOM_MODULE),,--without-http_upstream_random_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_HTTP_UPSTREAM_KEEPALIVE_MODULE),,--without-http_upstream_keepalive_module)

else # !BR2_PACKAGE_OPENRESTY_HTTP
OPENRESTY_CONF_OPTS += --without-http
endif # BR2_PACKAGE_OPENRESTY_HTTP

# mail modules
ifeq ($(BR2_PACKAGE_OPENRESTY_MAIL),y)
OPENRESTY_CONF_OPTS += --with-mail

ifeq ($(BR2_PACKAGE_OPENRESTY_MAIL_SSL_MODULE),y)
OPENRESTY_DEPENDENCIES += openssl
OPENRESTY_CONF_OPTS += --with-mail_ssl_module
endif

OPENRESTY_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENRESTY_MAIL_POP3_MODULE),,--without-mail_pop3_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_MAIL_IMAP_MODULE),,--without-mail_imap_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_MAIL_SMTP_MODULE),,--without-mail_smtp_module)

endif # BR2_PACKAGE_OPENRESTY_MAIL

# stream modules
ifeq ($(BR2_PACKAGE_OPENRESTY_STREAM),y)
OPENRESTY_CONF_OPTS += --with-stream

ifeq ($(BR2_PACKAGE_OPENRESTY_STREAM_REALIP_MODULE),y)
OPENRESTY_CONF_OPTS += --with-stream_realip_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_STREAM_SET_MODULE),)
OPENRESTY_CONF_OPTS += --without-stream_set_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_STREAM_SSL_MODULE),y)
OPENRESTY_DEPENDENCIES += openssl
OPENRESTY_CONF_OPTS += --with-stream_ssl_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_STREAM_GEOIP_MODULE),y)
OPENRESTY_DEPENDENCIES += geoip
OPENRESTY_CONF_OPTS += --with-stream_geoip_module
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_STREAM_SSL_PREREAD_MODULE),y)
OPENRESTY_CONF_OPTS += --with-stream_ssl_preread_module
endif

OPENRESTY_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_LIMIT_CONN_MODULE),,--without-stream_limit_conn_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_ACCESS_MODULE),,--without-stream_access_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_GEO_MODULE),,--without-stream_geo_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_MAP_MODULE),,--without-stream_map_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_SPLIT_CLIENTS_MODULE),,--without-stream_split_clients_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_RETURN_MODULE),,--without-stream_return_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_UPSTREAM_HASH_MODULE),,--without-stream_upstream_hash_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_UPSTREAM_LEAST_CONN_MODULE),,--without-stream_upstream_least_conn_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_UPSTREAM_RANDOM_MODULE),,--without-stream_upstream_random_module) \
	$(if $(BR2_PACKAGE_OPENRESTY_STREAM_UPSTREAM_ZONE_MODULE),,--without-stream_upstream_zone_module)

endif # BR2_PACKAGE_OPENRESTY_STREAM

# external modules
ifeq ($(BR2_PACKAGE_OPENRESTY_UPLOAD),y)
OPENRESTY_CONF_OPTS += $(addprefix --add-module=,$(NGINX_UPLOAD_DIR))
OPENRESTY_DEPENDENCIES += nginx-upload
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_DAV_EXT),y)
OPENRESTY_CONF_OPTS += --add-module=$(NGINX_DAV_EXT_DIR)
OPENRESTY_DEPENDENCIES += nginx-dav-ext
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_NAXSI),y)
OPENRESTY_DEPENDENCIES += nginx-naxsi
OPENRESTY_CONF_OPTS += --add-module=$(NGINX_NAXSI_DIR)/naxsi_src
endif

ifeq ($(BR2_PACKAGE_OPENRESTY_MODSECURITY),y)
OPENRESTY_DEPENDENCIES += nginx-modsecurity
OPENRESTY_CONF_OPTS += --add-module=$(NGINX_MODSECURITY_DIR)
endif

# Debug logging
OPENRESTY_CONF_OPTS += $(if $(BR2_PACKAGE_OPENRESTY_DEBUG),--with-debug)

define OPENRESTY_DISABLE_WERROR
	$(SED) 's/-Werror//g' -i $(@D)/bundle/nginx-1.21.4/auto/cc/*
endef

OPENRESTY_PRE_CONFIGURE_HOOKS += OPENRESTY_DISABLE_WERROR

define OPENRESTY_POST_PATCH
	sed -i '/ngx_lua 0.9.11+ required/s/^/--/' $(@D)/bundle/lua-resty-mysql-0.25/lib/resty/mysql.lua
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0001-auto-type-sizeof-rework-autotest-to-be-cross-compila.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0002-auto-feature-add-mechanism-allowing-to-force-feature.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0003-auto-set-ngx_feature_run_force_result-for-each-featu.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0004-auto-lib-libxslt-conf-use-pkg-config.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0005-auto-unix-make-sys_nerr-guessing-cross-friendly.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0006-auto-lib-openssl-conf-use-pkg-config.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0007-auto-lib-libgd-conf-use-pkg-config.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0008-src-os-unix-ngx_linux_config.h-only-include-dlfcn.h-.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0009-auto-os-linux-fix-build-with-libxcrypt.patch
	patch -d $(@D)/bundle/nginx-1.21.4 -p1 < vendor/package/openresty/nginx-patches/0010-Allow-forcing-of-endianness-for-cross-compilation.patch
endef

OPENRESTY_POST_PATCH_HOOKS += OPENRESTY_POST_PATCH

define OPENRESTY_CONFIGURE_CMDS
	cd $(@D) ; $(OPENRESTY_CONF_ENV) \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		GDLIB_CONFIG=$(STAGING_DIR)/usr/bin/gdlib-config \
		LUAJIT_INC=$(STAGING_DIR)/usr/include LUAJIT_LIB=$(STAGING_DIR)/usr/lib \
		./configure $(OPENRESTY_CONF_OPTS) \
			--with-cc-opt="$(TARGET_CFLAGS) $(OPENRESTY_CFLAGS)"
endef

define OPENRESTY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR)
endef

define OPENRESTY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	$(RM) $(TARGET_DIR)/usr/sbin/nginx.old
	$(INSTALL) -D -m 0664 vendor/package/openresty/nginx.logrotate \
		$(TARGET_DIR)/etc/logrotate.d/nginx
endef

define OPENRESTY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 vendor/package/openresty/nginx.service \
		$(TARGET_DIR)/usr/lib/systemd/system/nginx.service
endef

define OPENRESTY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 vendor/package/openresty/S50nginx \
		$(TARGET_DIR)/etc/init.d/S50nginx
endef

$(eval $(generic-package))
