#!/bin/bash

# 10_filter_variants.sh
# Applies GATK-recommended hard filters to the raw VCF to flag
# low-confidence variant calls.

set -e

PROJECT_DIR=~/bioinfo_vc
REFERENCE_DIR=$PROJECT_DIR/reference
RESULTS_DIR=$PROJECT_DIR/results
LOGS_DIR=$PROJECT_DIR/logs

echo "Applying hard filters to raw VCF..."

gatk VariantFiltration \
    -R "$REFERENCE_DIR/chr21.fa" \
    -V "$RESULTS_DIR/ERR16657781_raw_variants.vcf.gz" \
    -O "$RESULTS_DIR/ERR16657781_filtered_variants.vcf.gz" \
    --filter-expression "QD < 2.0" --filter-name "QD2" \
    --filter-expression "FS > 60.0" --filter-name "FS60" \
    --filter-expression "MQ < 40.0" --filter-name "MQ40" \
    --filter-expression "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
    --filter-expression "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
    --filter-expression "DP < 10" --filter-name "LowDepth" \
    2> "$LOGS_DIR/variant_filtration.log"

echo "Filtering complete."
echo "Total variants:"
zcat "$RESULTS_DIR/ERR16657781_filtered_variants.vcf.gz" | grep -v "^#" | wc -l
echo "PASS (confident) variants:"
zcat "$RESULTS_DIR/ERR16657781_filtered_variants.vcf.gz" | grep -v "^#" | awk '$7=="PASS"' | wc -l
