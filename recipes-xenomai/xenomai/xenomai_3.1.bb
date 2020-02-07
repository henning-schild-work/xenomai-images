#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2020
#
# Authors:
#  Jan Kiszka <jan.kiszka@siemens.com>
#
# SPDX-License-Identifier: MIT
#

require xenomai.inc

SRC_URI = " \
    git://gitlab.denx.de/Xenomai/xenomai.git;protocol=https;branch=master;tag=v${PV}"

S = "${WORKDIR}/git"
