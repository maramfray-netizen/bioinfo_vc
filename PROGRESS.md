# Project Progress Log

## Sample
- Accession: ERR16657781 (HG001 / NA12878)
- Reference: chromosome 21, GRCh38

## 1. Reference setup
- Downloaded chr21.fa
- Indexed with samtools faidx, samtools dict, bwa index
- Confirmed correct GRCh38 build (chr21 length 46,709,983 bp, matches expected exactly)

## 2. Read download
- Downloaded ERR16657781_1.fastq.gz and ERR16657781_2.fastq.gz from ENA
  - URL pattern: https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR166/081/ERR16657781/
- File 2 was corrupted during download (truncated mid-read due to connection timeout)
- Fixed by truncating both files to matching read counts (15,085,100 paired reads each):
  - ERR16657781_1_fixed.fastq.gz
  - ERR16657781_2_fixed.fastq.gz

## 3. Quality control
- Ran FastQC on raw reads, aggregated with MultiQC
- Reports saved in results/ (fastqc/multiqc html files in this repo)

## 4. Trimming
- Trimmomatic PE, TruSeq3 adapters, standard/moderate settings
- 96% of read pairs survived (14,482,116 of 15,085,100)

## 5. Alignment
- Aligned trimmed reads to chr21 reference with BWA MEM, sorted with samtools
- Output: results/ERR16657781_chr21_sorted.bam (2.0GB)
- Note: ERR16657781 is whole-genome sequencing data, not chr21-targeted reads.
  Only ~34% of reads mapped to chr21 (rest belong to other chromosomes).

## 6. Filtering mapped reads
- Filtered to mapped-only reads: results/ERR16657781_chr21_mapped_only.bam
- 100% mapped (by definition), 44.55% properly paired after filtering

## 7. BAM QC
- Mean depth across chr21: ~21x
- All mapped reads confirmed on chr21 (idxstats), no contamination from other chromosomes

## 8. Read group metadata
- Added read groups (RGSM=HG001) required by GATK using AddOrReplaceReadGroups
- Output: results/ERR16657781_chr21_RG.bam

## 9. Variant calling
- GATK HaplotypeCaller (v4.6.2.0), single-threaded due to ~2.8GB WSL memory limit
- 302,148 raw variants called on chr21 (~3.7 hours runtime)

## 10. Variant filtering
- GATK hard filters (QD, FS, MQ, MQRankSum, ReadPosRankSum, DP < 10)
- 88,777 of 302,148 variants passed filters (29.4%)

## 11. Benchmarking
- Compared filtered PASS variants against GIAB truth set (chr21, high-confidence regions)
- Initial result: Precision 0.78%, Recall 0.59% (TP≈312, FP≈39,283, FN≈51,885)
- Investigated thoroughly:
  - Confirmed reference build, chromosome naming, sort order, and BED restriction all correct
  - Verified independently with GATK Concordance — consistent results (not a tooling artifact)
  - Re-indexed reference, truth set, and call VCFs from scratch — results unchanged
  - Manually inspected specific truth positions (e.g., chr21:9543217): confirmed real coverage
    (8-45 reads depending on counting method) but allele-by-chance misses at low depth
- Root cause: whole-genome reads filtered down to chr21 produce patchy, uneven effective
  coverage (2x-100+x range), unlike true chr21-targeted sequencing. This explains the low
  benchmark scores as a data/coverage limitation, not a pipeline bug.

## 12. Annotation
- SnpEff database download blocked on network (snpeff.blob.core.windows.net unreachable)
- Used bcftools csq with Ensembl GFF3 (release 110) instead
- Checked APP, RUNX1, CBS, SOD1, DYRK1A specifically — no variants overlap coding exons (CDS)
  of these genes; variants found in their genomic span are intronic
- Top annotated genes are mostly processed pseudogenes (ZNF355P, ANKRD30BP1/2, NCOR1P4, etc.)

## Next steps
- Write final report (methods, metrics, interpretation, limitations)
- Discuss with supervisor whether to re-approach with genuinely chr21-targeted reads for a
  stronger benchmark number

## Data files (not stored in this repo — too large for GitHub)
Reproduce by running scripts in scripts/bash/01 through scripts/bash/12 in order.
