#!/bin/bash

# 01_download_data.sh
# Downloads paired-end FASTQ reads for ERR16657781 (HG001/NA12878)
# and the GIAB chr21 truth set for benchmarking.

set -e  # stop the script immediately if any command fails

PROJECT_DIR=~/bioinfo_vc
DATA_DIR=$PROJECT_DIR/data
BENCHMARK_DIR=$PROJECT_DIR/benchmark

mkdir -p "$DATA_DIR" "$BENCHMARK_DIR"

echo "Downloading ERR16657781 paired-end reads..."

wget -c -P "$DATA_DIR" \
    https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR166/081/ERR16657781/ERR16657781_1.fastq.gz

wget -c -P "$DATA_DIR" \
    https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR166/081/ERR16657781/ERR16657781_2.fastq.gz

echo "Downloading GIAB HG001 truth VCF and BED..."

wget -c -P "$BENCHMARK_DIR" \
    https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/NA12878_HG001/NISTv4.2.1/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz

wget -c -P "$BENCHMARK_DIR" \
    https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/NA12878_HG001/NISTv4.2.1/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz.tbi

wget -c -P "$BENCHMARK_DIR" \
    https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/NA12878_HG001/NISTv4.2.1/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.bed

echo "Verifying download integrity..."

gzip -t "$DATA_DIR/ERR16657781_1.fastq.gz" && echo "File 1: OK"
gzip -t "$DATA_DIR/ERR16657781_2.fastq.gz" && echo "File 2: OK"

echo "Download step complete."


