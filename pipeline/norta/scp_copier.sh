#!/usr/bin/env bash

BASE_DIR="scc4:/rprojectnb/visant/dkishore/synthetic_interactions/pipeline/norta"

# mkdir -p nf_micone
scp -r nf_micone/{modules,functions,configs} "${BASE_DIR}/nf_micone/"
# scp -r nf_micone/data "${BASE_DIR}/nf_micone/"
scp -r samplesheet.csv templates {main.nf,nextflow.config,qsub_run.sh} "${BASE_DIR}/"
