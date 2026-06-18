# Project Progress Log

## Sample
- Accession: ERR16657781 (HG001 / NA12878)
- Reference: chromosome 21, GRCh38

## Steps completed

### 1. Reference setup
- Downloaded chr21.fa
- Indexed with samtools faidx, samtools dict, bwa index

### 2. Read download
- Downloaded ERR16657781_1.fastq.gz and ERR16657781_2.fastq.gz from ENA
  - URL pattern: ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR166/081/ERR16657781/
- File 2 was corrupted during download (truncated mid-read due to connection timeout)
- Fixed by truncating both files to matching read counts (15,085,100 paired reads each):
  - ERR16657781_1_fixed.fastq.gz
  - ERR16657781_2_fixed.fastq.gz

### 3. Quality control
- Ran FastQC on raw reads
- Aggregated with MultiQC
- Reports saved in results/ (see fastqc/multiqc html files in this repo)

### 4. Alignment (in progress)
- Aligning fixed paired reads to chr21 reference with BWA MEM
- Output: results/ERR16657781_chr21_sorted.bam

## Data files (not stored in this repo — too large for GitHub)
Reproduce by running:
\`\`\`
wget https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR166/081/ERR16657781/ERR16657781_1.fastq.gz
wget https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR166/081/ERR16657781/ERR16657781_2.fastq.gz
\`\`\`
