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

inherit dpkg

PROVIDES += "xenomai-kernel-source xenomai-runtime xenomai-runtime-dbgsym libxenomai1 libxenomai-dev libxenomai1-dbgsym"

# use bitbake get_srcrev to get the current commit id
def get_commit(d):
    try:
        return bb.fetch2.get_srcrev(d).strip('AUTOINC+')
    except bb.fetch2.FetchError:
        return ""

COMMIT="${@get_commit(d)}"

do_prepare_build() {
	# The xenomai-kernel-source package is supposed to be generic, but we
	# build it per architecture in Isar, and those packages happen to be
	# different in some file so far. Make sure they are pushed into the
	# target architecture to avoid conflicts.
	sudo sed -i 's/Architecture: all/Architecture: any/' ${S}/debian/control
}

dpkg_runbuild_prepend() {
    bbplain $(printf "xenomai-%s: Building revision %.20s\n" \
                     ${PV} ${COMMIT})

    sudo chroot --userspec=$( id -u ):$( id -g ) ${BUILDCHROOT_DIR} \
        sh -c "cd ${PP}/${PPS}; scripts/bootstrap"
}
