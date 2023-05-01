#!/bin/sh -l

#SBATCH --nodes=1                  ##number of requested nodes (a node is a group of CPUs)
#SBATCH --tasks-per-node=12        ##number of requested CPUs
#SBATCH --time=48:00:00             ##time requested
#SBATCH --job-name Ancom             ##name of job
#SBATCH -A microbiome                ##name of the queue you are using. Could be scholar or microbiome if you are on snyder

#########################################################################
echo "start time"
date +"%d %B %Y %H:%M:%S"

#step 1, set the working directory
cd /depot/microbiome/data/ANSC516/lester/assigment/adjusted/

#step 2, Load Modules

echo "loading bioinfo"
module load bioinfo

echo "loading Qiime/2-2022.8"
module load Qiime/2-2022.8

qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 20000 \
  --m-metadata-file metadata_assignment2.txt \
  --o-visualization alpha-rarefaction.qzv

qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv

qiime composition add-pseudocount \
  --i-table table.qza \
  --o-composition-table comp-table.qza

qiime composition ancom \
  --i-table comp-table.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Affection \
  --o-visualization ancom-affection.qzv


qiime taxa collapse \
  --i-table table-filtered1.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table table-l6.qza

qiime composition add-pseudocount \
  --i-table table-l6.qza \
  --o-composition-table comp-table-l6.qza

qiime composition ancom \
  --i-table comp-table-l6.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Affection \
  --o-visualization l6-ancom-affection.qzv

echo "end time"
date +"%d %B %Y %H:%M:%S"
