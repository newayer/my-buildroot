################################################################################
#
# autossh
#
################################################################################

AUTOSSH_VERSION = 1.4g
AUTOSSH_SITE = http://www.harding.motd.ca/autossh
AUTOSSH_SOURCE = autossh-$(AUTOSSH_VERSION).tgz
AUTOSSH_LICENSE = Modified BSD
AUTOSSH_LICENSE_FILES = autossh.c
# Fix AC_ARG_WITH code generation for --with-ssh
AUTOSSH_AUTORECONF = YES

AUTOSSH_CONF_OPTS = --with-ssh=/usr/bin/ssh

define AUTOSSH_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/autossh/S86autossh \
		$(TARGET_DIR)/etc/init.d/S86autossh
endef

define AUTOSSH_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/autossh/autossh.service \
		$(TARGET_DIR)/usr/lib/systemd/system/autossh.service
endef

$(eval $(autotools-package))
