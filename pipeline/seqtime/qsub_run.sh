#!/bin/bash -l

#$ -l h_rt=48:00:00
#$ -N micone_seqtime
#$ -P visant
#$ -o qsub_outputs.txt
#$ -e qsub_errors.txt
#$ -m e
#$ -pe omp 36

module load miniconda
conda activate micone

nextflow -c nextflow.config run main.nf -resume
