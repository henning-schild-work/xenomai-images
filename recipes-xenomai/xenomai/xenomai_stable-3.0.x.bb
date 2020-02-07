#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2018-2020
#
# Authors:
#  Quirin Gylstorff <quirin.gylstorff@siemens.com>
#  Jan Kiszka <jan.kiszka@siemens.com>
#
# SPDX-License-Identifier: MIT
#

require xenomai.inc

SRC_URI = " \
    git://github.com/xenomai-ci/xenomai.git;protocol=https;branch=stable/v3.0.x"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"
