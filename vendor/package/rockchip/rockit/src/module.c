#include <linux/module.h>
#include <linux/types.h>
#include <linux/version.h>

MODULE_AUTHOR("Matt Flax <flatmax@>");
MODULE_AUTHOR("Matt <matt@audioinjector.net>");
MODULE_DESCRIPTION("buildroot.rockchip module rockit");
MODULE_LICENSE("GPL v2");
MODULE_ALIAS("platform:module-rv1106-rockit");

MODULE_IMPORT_NS(VFS_internal_I_am_really_a_filesystem_and_am_NOT_a_driver);

