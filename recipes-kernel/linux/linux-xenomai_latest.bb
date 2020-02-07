#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2019-2020
#
# Authors:
#  Quirin Gylstorff <quirin.gylstorff@siemens.com>
#  Jan Kiszka <jan.kiszka@siemens.com>
#
# SPDX-License-Identifier: MIT
#

require recipes-kernel/linux/linux-xenomai.inc

PV = "9999-g${LINUX_COMMIT}"

def is_xeno_3_0(d):
    xeno_ver = d.getVar('PREFERRED_VERSION_xenomai') or ''
    return xeno_ver.startswith('3.0') or xeno_ver == 'stable-3.0.x'

GIT_REPO_amd64 = "${@'ipipe.git' if is_xeno_3_0(d) else 'ipipe-x86.git'}"
GIT_BRANCH_amd64 = "${@'ipipe-4.4.y-cip' if is_xeno_3_0(d) else 'ipipe-x86-4.19.y'}"

GIT_REPO_armhf = "${@'ipipe.git' if is_xeno_3_0(d) else 'ipipe-arm.git'}"
GIT_BRANCH_armhf = "${@'ipipe-4.4.y-cip' if is_xeno_3_0(d) else 'ipipe/master'}"

GIT_REPO_arm64 = "ipipe-arm64.git"
GIT_BRANCH_arm64 = "ipipe/master"

SRC_URI += "git://github.com/xenomai-ci/${GIT_REPO};protocol=https;branch=${GIT_BRANCH}"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"
