#!/bin/bash
#PBS -l walltime=999:00:00
#PBS -l ncpus=12
. /share/apps/root-distros/root_v5.34.36.Linux-slc6-x86_64-gcc4.4/bin/thisroot.sh
set -euo pipefail
PBS_O_WORKDIR=(`echo $PBS_O_WORKDIR | sed "s/^\/state\/partition1//" `)
cd $PBS_O_WORKDIR

#RD-CNV autosomal calling with CNVNator

sampleId=$(basename $PWD)

#extract reads
/share/apps/CNVnator-distros/CNVnator_v0.3.3/src/cnvnator \
-chrom chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 \
-root "$sampleId".root \
-tree "$sampleId".bam \
-unique

#create histogram
/share/apps/CNVnator-distros/CNVnator_v0.3.3/src/cnvnator \
-chrom chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 \
-root "$sampleId".root \
-his 100 \
-d /share/apps/CNVnator-distros/gatk_v0_hg38_split

#stats
/share/apps/CNVnator-distros/CNVnator_v0.3.3/src/cnvnator \
-chrom chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 \
-root "$sampleId".root \
-stat 100

#partition
/share/apps/CNVnator-distros/CNVnator_v0.3.3/src/cnvnator \
-chrom chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 \
-root "$sampleId".root \
-partition 100

#calling
echo -e "CNV_type\tcoordinates\tCNV_size\tnormalized_RD\te-val1\te-val2\te-val3\te-val4\tq0" > "$sampleId"_cnv.txt
/share/apps/CNVnator-distros/CNVnator_v0.3.3/src/cnvnator \
-chrom chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 \
-root "$sampleId".root \
-call 100 >> "$sampleId"_cnv.txt
