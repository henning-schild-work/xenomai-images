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

require recipes-kernel/linux/linux-custom.inc

KERNEL_DEFCONFIG = "${DISTRO_ARCH}_defconfig"

SRC_URI += "file://${KERNEL_DEFCONFIG}"

DEPENDS += "xenomai-kernel-source"
KBUILD_DEPENDS += "xenomai-kernel-source"

LINUX_COMMIT="${@bb.fetch2.get_srcrev(d).strip('AUTOINC+')}"

dpkg_runbuild_prepend() {
	case ${DISTRO_ARCH} in
	armhf)
		ARCH=arm
		;;
	arm64)
		ARCH=arm64
		;;
	amd64)
		ARCH=x86
		;;
	*)
		bberror "Unsupported architecture ${DISTRO_ARCH}"
		exit 1
	esac
	bbplain $(printf "linux-xenomai-%s: Building revision %.20s\n" \
			 ${PV} ${LINUX_COMMIT})

	${BUILDCHROOT_DIR}/usr/src/xenomai-kernel-source/scripts/prepare-kernel.sh \
		--linux=${BUILDCHROOT_DIR}/${PP}/${PPS} --arch=$ARCH \
		--outpatch=${WORKDIR}/xenomai-kernel.patch
	patch -d ${BUILDCHROOT_DIR}/${PP}/${PPS} \
		-p1 -i ${WORKDIR}/xenomai-kernel.patch
}
