#!/bin/bash

# 07_bam_qc.sh
# Runs BAM quality control checks: flagstat, idxstats, and depth summary
# on the filtered, mapped-only BAM file.

set -e

RESULTS_DIR=~/bioinfo_vc/results
LOGS_DIR=~/bioinfo_vc/logs

mkdir -p "$LOGS_DIR"

BAM_FILE="$RESULTS_DIR/ERR16657781_chr21_mapped_only.bam"

echo "Running flagstat..."
samtools flagstat "$BAM_FILE" > "$LOGS_DIR/bam_qc_flagstat.log"

echo "Running idxstats..."
samtools idxstats "$BAM_FILE" > "$LOGS_DIR/bam_qc_idxstats.log"

echo "Calculating depth summary..."
samtools depth -a "$BAM_FILE" | \
    awk '{sum+=$3; cnt++} END {print "Mean depth:", sum/cnt, "\nPositions covered:", cnt}' \
    > "$LOGS_DIR/bam_qc_depth.log"

echo "BAM QC complete. Logs saved in $LOGS_DIR"
cat "$LOGS_DIR/bam_qc_flagstat.log"
cat "$LOGS_DIR/bam_qc_idxstats.log"
cat "$LOGS_DIR/bam_qc_depth.log"
