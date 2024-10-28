// SPDX-License-Identifier: GPL-2.0
// Copyright (c) 2023 Fuzhou Rockchip Electronics Co., Ltd
#include "linux/list.h"
#include <linux/module.h>

struct rk_tb_client {
	struct list_head node;
	void *data;
	void (*cb)(void *data);
};

bool rk_tb_mcu_is_done(void) { return true; }
EXPORT_SYMBOL_GPL(rk_tb_mcu_is_done);

int rk_tb_client_register_cb(struct rk_tb_client *client) { return 0; }
EXPORT_SYMBOL_GPL(rk_tb_client_register_cb);

int rk_tb_client_register_cb_head(struct rk_tb_client *client) { return 0; }
EXPORT_SYMBOL_GPL(rk_tb_client_register_cb_head);

unsigned int get_rk_cam_h(void){return 0;}
EXPORT_SYMBOL_GPL(get_rk_cam_h);

ssize_t __modver_version_show(struct module_attribute * a,
                                     struct module_kobject *b, char *c){return 0;}
EXPORT_SYMBOL_GPL(__modver_version_show);