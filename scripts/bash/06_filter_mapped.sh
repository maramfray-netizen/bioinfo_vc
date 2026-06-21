#!/bin/bash

# 06_filter_mapped.sh
# Filters the sorted BAM to keep only mapped reads (removes unmapped reads
# from chromosomes other than chr21, since input reads were whole-genome).

set -e

RESULTS_DIR=~/bioinfo_vc/results

echo "Filtering to mapped reads only..."
samtools view -b -F 4 "$RESULTS_DIR/ERR16657781_chr21_sorted.bam" \
    > "$RESULTS_DIR/ERR16657781_chr21_mapped_only.bam"

echo "Indexing filtered BAM..."
samtools index "$RESULTS_DIR/ERR16657781_chr21_mapped_only.bam"

echo "Filtering complete."
samtools flagstat "$RESULTS_DIR/ERR16657781_chr21_mapped_only.bam"
