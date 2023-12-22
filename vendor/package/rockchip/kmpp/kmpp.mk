################################################################################
#
# kernel-module-kmpp
#
################################################################################

KMPP_VERSION = 1.0.0
KMPP_SITE = $(KMPP_PKGDIR)src
KMPP_SITE_METHOD = local

KMPP_MODULE_MAKE_OPTS = KERNEL_DIR=$(LINUX_DIR) CONFIG_ROCKCHIP_RV1106_MPP=m

$(eval $(kernel-module))
$(eval $(generic-package))
