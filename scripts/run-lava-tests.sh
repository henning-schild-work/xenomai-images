#!/bin/sh
#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2019-2020
#
# Authors:
#  Quirin Gylstorff <quirin.gylstorff@siemens.com>
#
# SPDX-License-Identifier: MIT
#
set -e
TARGET=$1
if [ -z "${TARGET}" ]; then
    echo "no target was given"
    exit -1
fi

lava_master_port="${LAVA_MASTER_PORT:-28080}"
if [ -n "${LAVA_SSH_PORT}" ]; then
    lava_ssh_port="-p ${LAVA_SSH_PORT}"
fi
lava_identity="-i ${LAVA_SSH_KEY_PATH:-~/.ssh/lava_id_rsa}"
lava_ssh_destination="${LAVA_SSH_USER}@${LAVA_SSH_HOST}"
# open connection for ssh port forwarding
ssh -N ${lava_ssh_port} ${lava_identity} -o 'LocalForward localhost:'${lava_master_port}' localhost:80' ${lava_ssh_destination} &
ssh_pid=$!
# wait for connection
interval=1
timeout=60
until ss -tulw | grep -q "${lava_master_port}"
do
    if [ ${timeout} -le 0 ]; then
        echo "could not open connection to LAVA Master"
        exit 1
    fi
    sleep ${interval}
    timeout=$(expr ${timeout} - ${interval})
done
lava_master_uri=http://localhost:${lava_master_port}

# connect to lava master
lavacli identities add --token ${LAVA_MASTER_TOKEN} --uri ${lava_master_uri} --username ${LAVA_MASTER_ACCOUNT} default
#generate lava job description from template
artifact_url="${LAVA_ARTIFACTS_URL:-http://localhost/artifacts}"
DEPLOY_URL="${artifact_url}/${CI_PIPELINE_ID}/${DEPLOY_DIR_EXTENSION}"
job_template_path="${JOB_TEMPLATE_PATH:-tests/jobs/xenomai}"
tmp_dir=$(mktemp -d)
template=${tmp_dir}/job_${TARGET}_${CI_PIPELINE_ID}.yml
cp ${job_template_path}-${TARGET}.yml ${template}
sed -i "s|\${TARGET}|${TARGET}|g" $template
sed -i "s|\${DEPLOY_URL}|${DEPLOY_URL}|g" $template
sed -i "s|\${ISAR_IMAGE}|${ISAR_IMAGE}|g" $template
sed -i "s|\${ISAR_DISTRIBUTION}|${ISAR_DISTRIBUTION}|g" $template
test_id=$(lavacli jobs submit ${template})
lavacli jobs logs ${test_id}
lavacli results ${test_id}
# change return code to generate a error in gitlab-ci if a test is failed
number_of_fails=$(lavacli results ${test_id} | grep fail | wc -l)
kill ${ssh_pid}
if [ "${number_of_fails}" -gt "0" ]; then
    exit 1
fi
