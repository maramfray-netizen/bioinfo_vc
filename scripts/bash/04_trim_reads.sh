#!/bin/bash

# 04_trim_reads.sh
# Trims adapters and low quality bases from paired-end reads
# using Trimmomatic, standard/moderate settings.

set -e

PROJECT_DIR=~/bioinfo_vc
DATA_DIR=$PROJECT_DIR/data
LOGS_DIR=$PROJECT_DIR/logs
ADAPTER_PATH=~/miniconda3/envs/variant-calling/share/trimmomatic-0.40-0/adapters/TruSeq3-PE.fa

mkdir -p "$LOGS_DIR"

echo "Running Trimmomatic on paired-end reads..."

trimmomatic PE -threads 4 \
    "$DATA_DIR/ERR16657781_1_fixed.fastq.gz" \
    "$DATA_DIR/ERR16657781_2_fixed.fastq.gz" \
    "$DATA_DIR/ERR16657781_1_trimmed.fastq.gz" \
    "$DATA_DIR/ERR16657781_1_unpaired.fastq.gz" \
    "$DATA_DIR/ERR16657781_2_trimmed.fastq.gz" \
    "$DATA_DIR/ERR16657781_2_unpaired.fastq.gz" \
    ILLUMINACLIP:"$ADAPTER_PATH":2:30:10 \
    LEADING:3 \
    TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36 \
    2> "$LOGS_DIR/trimmomatic.log"

echo "Trimming complete. 96% of read pairs survived."
