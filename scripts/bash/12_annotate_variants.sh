#!/bin/bash

# 12_annotate_variants.sh
# Annotates high-confidence variants with functional consequences using
# bcftools csq and an Ensembl GFF3 annotation file.
# Note: SnpEff was the original plan, but its database download
# (snpeff.blob.core.windows.net) was unreachable on this network,
# so bcftools csq with an Ensembl-sourced GFF3 was used instead.

set -e

REFERENCE_DIR=~/bioinfo_vc/reference
RESULTS_DIR=~/bioinfo_vc/results

echo "Downloading chr21 GFF3 annotation from Ensembl..."
wget -nc -P "$REFERENCE_DIR" \
    https://ftp.ensembl.org/pub/release-110/gff3/homo_sapiens/Homo_sapiens.GRCh38.110.chromosome.21.gff3.gz

echo "Reformatting chromosome naming and sorting..."
zcat "$REFERENCE_DIR/Homo_sapiens.GRCh38.110.chromosome.21.gff3.gz" | \
    awk 'BEGIN{FS=OFS="\t"} /^#/{print; next} {$1="chr21"; print}' | \
    sort -k1,1 -k4,4n -t$'\t' > "$REFERENCE_DIR/chr21_sorted.gff3"

bgzip -f "$REFERENCE_DIR/chr21_sorted.gff3"
tabix -f -p gff "$REFERENCE_DIR/chr21_sorted.gff3.gz"

echo "Running bcftools csq annotation..."
bcftools csq -f "$REFERENCE_DIR/chr21.fa" -g "$REFERENCE_DIR/chr21_sorted.gff3.gz" \
    "$RESULTS_DIR/ERR16657781_pass_highconf.vcf.gz" \
    -O z -o "$RESULTS_DIR/ERR16657781_annotated.vcf.gz"

echo "Annotation complete."
echo "Variants with functional annotation:"
zcat "$RESULTS_DIR/ERR16657781_annotated.vcf.gz" | grep -v "^#" | grep -c "BCSQ"
