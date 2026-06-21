#!/bin/bash

# 08_add_read_groups.sh
# Adds read group metadata to the filtered BAM file, required by GATK
# for variant calling.

set -e

RESULTS_DIR=~/bioinfo_vc/results

echo "Adding read group information..."

gatk AddOrReplaceReadGroups \
    -I "$RESULTS_DIR/ERR16657781_chr21_mapped_only.bam" \
    -O "$RESULTS_DIR/ERR16657781_chr21_RG.bam" \
    -RGID ERR16657781 \
    -RGLB lib1 \
    -RGPL ILLUMINA \
    -RGPU unit1 \
    -RGSM HG001

echo "Indexing BAM with read groups..."
samtools index "$RESULTS_DIR/ERR16657781_chr21_RG.bam"

echo "Read group addition complete."
samtools view -H "$RESULTS_DIR/ERR16657781_chr21_RG.bam" | grep "@RG"
