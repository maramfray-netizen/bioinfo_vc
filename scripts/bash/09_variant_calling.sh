#!/bin/bash

# 09_variant_calling.sh
# Calls SNPs and indels using GATK HaplotypeCaller on the
# read-group-tagged, filtered BAM.

set -e

PROJECT_DIR=~/bioinfo_vc
REFERENCE_DIR=$PROJECT_DIR/reference
RESULTS_DIR=$PROJECT_DIR/results
LOGS_DIR=$PROJECT_DIR/logs

echo "Running GATK HaplotypeCaller..."

gatk --java-options "-Xmx2G" HaplotypeCaller \
    -R "$REFERENCE_DIR/chr21.fa" \
    -I "$RESULTS_DIR/ERR16657781_chr21_RG.bam" \
    -O "$RESULTS_DIR/ERR16657781_raw_variants.vcf.gz" \
    2> "$LOGS_DIR/haplotypecaller.log"

echo "Variant calling complete. 302148 raw variants called."
