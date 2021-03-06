#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2018
#
# Authors:
#  Jan Kiszka <jan.kiszka@siemens.com>
#
# SPDX-License-Identifier: MIT
#

inherit image

ISAR_RELEASE_CMD = "git -C ${LAYERDIR_xenomai} describe --tags --dirty --always --match 'v[0-9].[0-9]*'"
DESCRIPTION = "Xenomai demo and test image"

IMAGE_PREINSTALL += " \
    bash-completion less vim nano man \
    ifupdown isc-dhcp-client net-tools iputils-ping ssh \
    iw wireless-tools wpasupplicant dbus \
    gdb lsb-release"

IMAGE_INSTALL += "xenomai-runtime xenomai-runtime-dbgsym libxenomai1-dbgsym"
IMAGE_INSTALL += "customizations sshd-regen-keys expand-on-first-boot"
