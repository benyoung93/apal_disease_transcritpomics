#!/bin/bash
#BSUB -J STAR_align
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -e /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/error_output/align/error/alignment.e%J
#BSUB -o /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/error_output/align/output/alignment.o%J


# creating variables and what not
deproj='/scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro'


# making a list of sample names
PALMATA=`ls /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/trimmed_reads | sed 's/\(.*\)_trimmed.fastq/\1/g'`


# the files being processed
echo "samples being aligned"
echo $PALMATA

for PALPAL in $PALMATA
do
echo "$PALPAL"
echo '#!/bin/bash' > /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
echo '#BSUB -J '"$PALPAL"'' >> /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
echo '#BSUB -e /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/error_output/align/error/'"$PALPAL"'_error_alignment.txt' >> /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
echo '#BSUB -o /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/error_output/align/output/'"$PALPAL"'_output_alignment.txt' >> /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
echo '#BSUB -q bigmem'  >> /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
echo '#BSUB -n 8' >> /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
echo '#BSUB -R "rusage[mem=5000]"' >> /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh

echo '/nethome/bdy8/Ben_Xaymara_GE_project/programs/STAR \
--runThreadN 8 \
--genomeDir /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/star_index/ \
--readFilesIn /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/trimmed_reads/'"$PALPAL"'_trimmed.fastq \
--outSAMtype BAM SortedByCoordinate \
--quantMode TranscriptomeSAM GeneCounts \
--outSAMstrandField intronMotif \
--twopassMode Basic \
--twopass1readsN -1 \
--outFileNamePrefix /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/aligned/'"$PALPAL"'/'"$PALPAL"'_' >> /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
bsub < /scratch/projects/transcriptomics/ben_young/apalm_v2/acer_libro/scripts/align/"$PALPAL"_alignment.sh
done
