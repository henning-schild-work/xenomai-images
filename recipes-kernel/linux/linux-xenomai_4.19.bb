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

require recipes-kernel/linux/linux-xenomai.inc

SRC_URI_append_amd64 = " git://github.com/xenomai-ci/ipipe-x86.git;protocol=https;nobranch=1"
SRCREV_amd64 ?= "ipipe-core-4.19.94-cip18-x86-10"
PV_amd64 ?= "4.19.94+"

SRC_URI_append_arm64 = " git://github.com/xenomai-ci/ipipe-arm64.git;protocol=https;nobranch=1"
SRCREV_arm64 ?= "ipipe-core-4.19.55-arm64-4"
PV_arm64 ?= "4.19.55+"

SRC_URI_append_armhf = " git://github.com/xenomai-ci/ipipe-arm.git;protocol=https;nobranch=1"
SRCREV_armhf ?= "ipipe-core-4.19.55-arm-5"
PV_armhf ?= "4.19.55+"

S = "${WORKDIR}/git"
