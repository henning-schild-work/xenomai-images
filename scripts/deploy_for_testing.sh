#!/bin/sh

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
set -e
target="$1"

if [ -z "${target}" ]; then
    exit -1
fi
images_dir=build/tmp/deploy/images

if [ -z "${LAVA_SSH_USER}" ] || [ -z "${LAVA_SSH_HOST}" ]  || [ -z "${LAVA_SSH_PORT}" ]; then
    echo "Lava environment not available or incomplete - do not deploy"
    exit 0
fi

lava_ssh_destination="${LAVA_SSH_USER}@${LAVA_SSH_HOST}"

isar_base_name="${ISAR_IMAGE}-${ISAR_DISTRIBUTION}-${target}"
lava_deploy_dir="${LAVA_DEPLOY_DIR:-/var/lib/lava/artifacts}"
deploy_dir="${lava_deploy_dir}/${CI_PIPELINE_ID}"
lava_identity="-i ${LAVA_SSH_KEY_PATH:-~/.ssh/lava_id_rsa}"
if [ -n "${CI_PIPELINE_ID}" ]; then
    ssh -p ${LAVA_SSH_PORT} ${lava_identity} ${lava_ssh_destination} 'install -d -m 755 "'${deploy_dir}'"'
fi
#KERNEL
scp -P ${LAVA_SSH_PORT} ${lava_identity} ${images_dir}/${target}/${isar_base_name}-vmlinuz \
    ${lava_ssh_destination}:${deploy_dir}
# INITRD
scp -P ${LAVA_SSH_PORT} ${lava_identity} ${images_dir}/${target}/${isar_base_name}-initrd.img \
    ${lava_ssh_destination}:${deploy_dir}
# ROOTFS
if [ -n ${images_dir}/${target}/${isar_base_name}.*.gz  ]; then
    gzip ${images_dir}/${target}/${isar_base_name}.*
fi
scp -P ${LAVA_SSH_PORT} ${lava_identity} ${images_dir}/${target}/${isar_base_name}.* \
    ${lava_ssh_destination}:${deploy_dir}
# DTB
dtb="${images_dir}/${target}/*.dtb"
if [ -e ${dtb} ]; then
    scp -P ${LAVA_SSH_PORT} ${lava_identity} ${dtb} ${lava_ssh_destination}:${deploy_dir}
fi
