#!/bin/sh -l

#SBATCH --nodes=1                  ##number of requested nodes (a node is a group of CPUs)
#SBATCH --tasks-per-node=12        ##number of requested CPUs
#SBATCH --time=11:00:00             ##time requested
#SBATCH --job-name SRA             ##name of job
#SBATCH -A microbiome                ##name of the queue you are using. Could be scholar or microbiome if you are on snyder

#########################################################################
echo "start time"
date +"%d %B %Y %H:%M:%S"

#step 1, set the working directory
cd /depot/microbiome/data/ANSC516/lester/assignments/

#step 2, Load Modules

echo "loading bioinfo"
module load bioinfo

echo "loading Qiime/2-2022.8"
module load Qiime/2-2022.8


qiime sample-classifier classify-samples \
  --i-table table.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Affection \
  --p-optimize-feature-selection \
  --p-parameter-tuning \
  --p-estimator RandomForestClassifier \
  --p-n-estimators 20 \
  --p-random-state 123 \
  --output-dir moving-pictures-classifier


qiime metadata tabulate \
  --m-input-file moving-pictures-classifier/predictions.qza \
  --o-visualization moving-pictures-classifier/predictions.qzv

qiime metadata tabulate \
  --m-input-file moving-pictures-classifier/probabilities.qza \
  --o-visualization moving-pictures-classifier/probabilities.qzv

qiime metadata tabulate \
  --m-input-file moving-pictures-classifier/feature_importance.qza \
  --o-visualization moving-pictures-classifier/feature_importance.qzv

qiime feature-table filter-features \
  --i-table table-filtered1.qza \
  --m-metadata-file moving-pictures-classifier/feature_importance.qza \
  --o-filtered-table moving-pictures-classifier/important-feature-table.qza

qiime sample-classifier heatmap \
  --i-table table.qza \
  --i-importance moving-pictures-classifier/feature_importance.qza \
  --m-sample-metadata-file metadata_assignment2.txt \
  --m-sample-metadata-column Affection \
  --p-group-samples \
  --p-feature-count 30 \
  --o-filtered-table moving-pictures-classifier/important-feature-table-top-30.qza \
  --o-heatmap moving-pictures-classifier/important-feature-heatmap.qzv

qiime sample-classifier heatmap \
--i-table table.qza \
--i-importance moving-pictures-classifier/feature_importance.qza  \
--m-sample-metadata-file metadata_assignment2.txt  \
--m-sample-metadata-column Affection \
--m-feature-metadata-file taxonomy.qza \
--m-feature-metadata-column Taxon \
--p-group-samples  \
--p-feature-count 30  \
--o-filtered-table moving-pictures-classifier/important-feature-table-taxonomy-top-30.qza \
--o-heatmap moving-pictures-classifier/important-feature-heatmap-taxonomy.qzv


echo "end time"
date +"%d %B %Y %H:%M:%S"
