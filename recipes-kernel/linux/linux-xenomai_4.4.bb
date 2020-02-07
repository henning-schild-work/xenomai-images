#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2018-2020
#
# Authors:
#  Jan Kiszka <jan.kiszka@siemens.com>
#
# SPDX-License-Identifier: MIT
#

require recipes-kernel/linux/linux-xenomai.inc

SRC_URI_append_amd64 = " git://github.com/xenomai-ci/ipipe.git;protocol=https;nobranch=1;tag=ipipe-core-4.4.208-cip41-x86-21"
PV_amd64 = "4.4.208+"

SRC_URI_append_armhf = " git://github.com/xenomai-ci/ipipe.git;protocol=https;nobranch=1;tag=ipipe-core-4.4.176-arm-10"
PV_armhf = "4.4.176+"

S = "${WORKDIR}/git"
