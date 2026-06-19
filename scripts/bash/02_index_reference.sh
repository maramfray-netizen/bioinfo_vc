#!/bin/bash

# 02_index_reference.sh
# Indexes the chr21 reference FASTA so it can be used by
# samtools, BWA, and GATK downstream.

set -e

REFERENCE_DIR=~/bioinfo_vc/reference
REF_FASTA="$REFERENCE_DIR/chr21.fa"

echo "Indexing reference with samtools faidx..."
samtools faidx "$REF_FASTA"

echo "Creating sequence dictionary for GATK..."
samtools dict "$REF_FASTA" -o "$REFERENCE_DIR/chr21.dict"

echo "Building BWA index (this may take a few minutes)..."
bwa index "$REF_FASTA"

echo "Reference indexing complete."
ls -lh "$REFERENCE_DIR"
