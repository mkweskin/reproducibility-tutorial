#!/bin/sh

# This is modified from the example here: https://learning.cyverse.org/projects/cyverse-cyverse-reproducbility-tutorial/en/latest/step3.html

# Set the base directory for these analyses:
BASE=/scratch/test-workflow

# Make a directory and stage our data
DATADIRECTORY=${BASE}/data
mkdir -p ${DATADIRECTORY}

# Import data from CyVerse data store
echo "Getting raw data from cyverse data store"
iget -P /iplant/home/shared/cyverse_training/datasets/PRJNA79729/fastq_files/SRR064156.fastq.gz ${DATADIRECTORY}

#Make a directory for our analysis
ANALYSISDIR=${BASE}/analyses
mkdir -p ${ANALYSISDIR}

#Use Docker container to do fastqc
echo "Running fastqc..."
docker run -v ${DATADIRECTORY}:/work quay.io/biocontainers/fastqc:0.11.7--4 fastqc /work/SRR064156.fastq.gz

#move results to analyses directory
mkdir -p ${ANALYSISDIR}/fastqc
mv ${DATADIRECTORY}/*fastqc* ${ANALYSISDIR}/fastqc

#Use Docker container to do trimmomatic
echo "Running trimmomatic..."
docker run -v ${DATADIRECTORY}:/work quay.io/biocontainers/trimmomatic:0.39--1 trimmomatic SE -threads 8 /work/SRR064156.fastq.gz /work/SRR064156_trimmed.fastq.gz SLIDINGWINDOW:4:30

#move results to analyses directory
mkdir -p ${ANALYSISDIR}/trimmomatic
mv ${DATADIRECTORY}/*_trimmed.fastq.gz ${ANALYSISDIR}/trimmomatic

echo DONE
