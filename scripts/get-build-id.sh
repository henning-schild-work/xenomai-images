#!/bin/sh
#
# Xenomai Real-Time System
#
# Copyright (c) Siemens AG, 2020
#
# Authors:
#  Quirin Gylstorff <quirin.gylstorff@siemens.com>
#
# SPDX-License-Identifier: MIT
#

name=$1
if [ -z "${name}" ]; then
    echo "no build name was given"
    exit -1
    fi
index=0
JSON=$(curl -s --header "PRIVATE-TOKEN: ${API_TOKEN}" "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/pipelines/${CI_PIPELINE_ID}/jobs?scope[]=success"  )
while  [ ${index} -le ${MAX_TEST:-16} ]
do
    build_name=$(echo "${JSON}"  | tr '\r\n' ' ' | jq -r ".[${index}].name")
    if [ "$build_name" = "${name}" ]; then
        break
    fi
     index=$((index+1))
done
id=$(echo "${JSON}"  | tr '\r\n' ' ' | jq -r ".[${index}].id")
echo $id
