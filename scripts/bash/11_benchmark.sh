#!/bin/bash

# 11_benchmark.sh
# Benchmarks filtered PASS variants against the GIAB truth set,
# restricted to high-confidence regions, using bcftools.

set -e

BENCHMARK_DIR=~/bioinfo_vc/benchmark
RESULTS_DIR=~/bioinfo_vc/results

echo "Extracting chr21 truth set..."
bcftools view -r chr21 "$BENCHMARK_DIR/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz" \
    -O z -o "$BENCHMARK_DIR/truth_chr21.vcf.gz"
bcftools index -t -f "$BENCHMARK_DIR/truth_chr21.vcf.gz"

echo "Restricting truth set to high-confidence regions..."
grep "^chr21" "$BENCHMARK_DIR/HG001_GRCh38_1_22_v4.2.1_benchmark.bed" > "$BENCHMARK_DIR/highconf_chr21.bed"
bcftools view -R "$BENCHMARK_DIR/highconf_chr21.bed" "$BENCHMARK_DIR/truth_chr21.vcf.gz" \
    -O z -o "$BENCHMARK_DIR/truth_highconf.vcf.gz"
bcftools index -t -f "$BENCHMARK_DIR/truth_highconf.vcf.gz"

echo "Restricting PASS calls to high-confidence regions..."
bcftools view -f PASS "$RESULTS_DIR/ERR16657781_filtered_variants.vcf.gz" \
    -O z -o "$RESULTS_DIR/ERR16657781_pass_only.vcf.gz"
bcftools index -t -f "$RESULTS_DIR/ERR16657781_pass_only.vcf.gz"

bcftools view -R "$BENCHMARK_DIR/highconf_chr21.bed" "$RESULTS_DIR/ERR16657781_pass_only.vcf.gz" \
    -O z -o "$RESULTS_DIR/ERR16657781_pass_highconf.vcf.gz"
bcftools index -t -f "$RESULTS_DIR/ERR16657781_pass_highconf.vcf.gz"

echo "Comparing against truth set..."
rm -rf "$BENCHMARK_DIR/comparison"
mkdir -p "$BENCHMARK_DIR/comparison"
bcftools isec -p "$BENCHMARK_DIR/comparison" \
    "$RESULTS_DIR/ERR16657781_pass_highconf.vcf.gz" \
    "$BENCHMARK_DIR/truth_highconf.vcf.gz"

TP=$(grep -v "^#" "$BENCHMARK_DIR/comparison/0002.vcf" | wc -l)
FP=$(grep -v "^#" "$BENCHMARK_DIR/comparison/0000.vcf" | wc -l)
FN=$(grep -v "^#" "$BENCHMARK_DIR/comparison/0001.vcf" | wc -l)

PRECISION=$(echo "scale=4; $TP / ($TP + $FP)" | bc)
RECALL=$(echo "scale=4; $TP / ($TP + $FN)" | bc)
F1=$(echo "scale=4; 2 * $PRECISION * $RECALL / ($PRECISION + $RECALL)" | bc)

echo "True Positives: $TP"
echo "False Positives: $FP"
echo "False Negatives: $FN"
echo "Precision: $PRECISION"
echo "Recall: $RECALL"
echo "F1 Score: $F1"
