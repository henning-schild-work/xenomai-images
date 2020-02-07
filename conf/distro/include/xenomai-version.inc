#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2019
#
# Authors:
#  Quirin Gylstorff <quirin.gylstorff@siemens.com>
#
# SPDX-License-Identifier: MIT
#

XENOMAI_DEFAULT_KERNEL_VERSION = "4.19%"
XENOMAI_3_0_VERSION_LIST = "3.0 3.0% 3.0.% 3.0.10"
XENOMAI_3_0_KERNEL_VERSION = "4.4%"
# if PREFERRED_VERSION_xenomai contains any item from XENOMAI_3_0_VERSION_LIST use
# XENOMAI_3_0_KERNEL_VERSION
PREFERRED_VERSION_linux-xenomai ?= "${@bb.utils.contains_any('PREFERRED_VERSION_xenomai','${XENOMAI_3_0_VERSION_LIST}','${XENOMAI_3_0_KERNEL_VERSION}','${XENOMAI_DEFAULT_KERNEL_VERSION}',d) }"
