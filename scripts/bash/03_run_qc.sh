#!/bin/bash

# 03_run_qc.sh
# Runs FastQC on raw paired-end reads and aggregates the
# results into a single MultiQC report.

set -e

PROJECT_DIR=~/bioinfo_vc
DATA_DIR=$PROJECT_DIR/data
RESULTS_DIR=$PROJECT_DIR/results

mkdir -p "$RESULTS_DIR"

echo "Running FastQC on raw reads..."
fastqc "$DATA_DIR"/ERR16657781_1.fastq.gz \
       "$DATA_DIR"/ERR16657781_2.fastq.gz \
       -o "$RESULTS_DIR" \
       -t 4

echo "Aggregating results with MultiQC..."
multiqc "$RESULTS_DIR" -o "$RESULTS_DIR"

echo "QC step complete. Report saved to $RESULTS_DIR/multiqc_report.html"
