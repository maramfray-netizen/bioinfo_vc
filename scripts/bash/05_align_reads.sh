#!/bin/bash

# 05_align_reads.sh
# Aligns trimmed paired-end reads to the chr21 reference using BWA MEM,
# then sorts the output into a coordinate-sorted BAM file.
# Note: single-threaded settings used due to limited system RAM (~2.8GB WSL allocation).

set -e

PROJECT_DIR=~/bioinfo_vc
DATA_DIR=$PROJECT_DIR/data
REFERENCE_DIR=$PROJECT_DIR/reference
RESULTS_DIR=$PROJECT_DIR/results
LOGS_DIR=$PROJECT_DIR/logs

mkdir -p "$RESULTS_DIR" "$LOGS_DIR"

echo "Aligning trimmed reads to chr21 reference..."

bwa mem -t 1 "$REFERENCE_DIR/chr21.fa" \
    "$DATA_DIR/ERR16657781_1_trimmed.fastq.gz" \
    "$DATA_DIR/ERR16657781_2_trimmed.fastq.gz" \
    2> "$LOGS_DIR/bwa_mem.log" \
    | samtools sort -@ 1 -m 256M -T "$RESULTS_DIR/tmp_sort_final" \
        -o "$RESULTS_DIR/ERR16657781_chr21_sorted.bam" -

echo "Indexing sorted BAM..."
samtools index "$RESULTS_DIR/ERR16657781_chr21_sorted.bam"

echo "Alignment complete."
samtools flagstat "$RESULTS_DIR/ERR16657781_chr21_sorted.bam"
