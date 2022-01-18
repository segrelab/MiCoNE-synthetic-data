#!/usr/bin/env bash

BASE_DIR="/home/dileep/Documents/Work/MIND/micone/micone/pipelines"

mkdir -p nf_micone
cp -r "${BASE_DIR}/templates" .
cp -r "${BASE_DIR}/modules" nf_micone
cp -r "${BASE_DIR}/functions" nf_micone
cp -r "${BASE_DIR}/configs" nf_micone
# cp -r "${BASE_DIR}/data" nf_micone
# cp "${BASE_DIR}/main.nf" .
# cp "${BASE_DIR}/nextflow.config" .
