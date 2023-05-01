#!/bin/sh -l

#SBATCH --nodes=1                 ##number of requested nodes (a node is a group of CPUs)
#SBATCH -n 12                      ##number of requested CPUs
#SBATCH --time=04:00:00             ##time requested
#SBATCH --job-name diversity-analysis   ##name of job
#SBATCH -A microbiome                 ##name of the queue you are using. Could be scholar or microbiome if you are on snyder

#########################################################################

echo "Start time"
date +"%d %B %Y %H:%M:%S"

#step 1, cd into the proper directory. This directory must already exist

cd /depot/microbiome/data/ANSC516/lester/assignments/

pwd

#step 2, Load Modules

echo "loading bioinfo"
module load bioinfo

echo "loading qiime2-2022.8"
module load Qiime/2-2022.8

#step 3, Run the code you want

echo "initiating qiime2 pipeline"

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table-filtered.qza \
  --p-sampling-depth 10473 \
  --m-metadata-file metadata_assignment2.txt \
  --output-dir core-metrics-results

qiime diversity alpha-correlation \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file metadata_assignment2.txt \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-correlation \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file metadata_assignment2.txt \
  --o-visualization core-metrics-results/evenness-group-significance.qzv

qiime diversity alpha-correlation \
    --i-alpha-diversity core-metrics-results/shannon_vector.qza \
    --m-metadata-file metadata_assignment2.txt \
    --o-visualization core-metrics-results/shannon_vector.qzv

qiime diversity alpha-correlation \
    --i-alpha-diversity core-metrics-results/evenness_vector.qza \
    --m-metadata-file metadata_assignment2.txt \
    --o-visualization core-metrics-results/evenness_vector.qzv

qiime diversity alpha \
  --i-table table.qza \
  --p-metric chao1 \
  --o-alpha-diversity core-metrics-results/chao1_vector.qza

qiime diversity alpha-correlation \
  --i-alpha-diversity core-metrics-results/chao1_vector.qza \
  --m-metadata-file metadata_assignment2.txt \
  --o-visualization core-metrics-results/chao1-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file metadata_assignment2.txt \
  --o-visualization core-metrics-results/faith-pd-group-categorical-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file metadata_assignment2.txt \
  --o-visualization core-metrics-results/evenness-group-categorical-significance.qzv

qiime diversity alpha-group-significance \
    --i-alpha-diversity core-metrics-results/shannon_vector.qza \
    --m-metadata-file metadata_assignment2.txt \
    --o-visualization core-metrics-results/shannon_vector_categorical.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/chao1_vector.qza \
  --m-metadata-file metadata_assignment2.txt \
  --o-visualization core-metrics-results/chao1-group-significance-categorical.qzv

qiime diversity alpha-group-significance \
    --i-alpha-diversity core-metrics-results/observed_features_vector.qza \
    --m-metadata-file metadata_assignment2.txt \
    --o-visualization core-metrics-results/observed_features_vector_categorical.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Affection \
  --o-visualization core-metrics-results/unweighted-unifrac-affection-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Affection \
  --o-visualization core-metrics-results/weighted-unifrac-affection-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/jaccard_distance_matrix.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Affection \
  --o-visualization core-metrics-results/jaccard-affection-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Affection \
  --o-visualization core-metrics-results/bray-curtis-affection-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file metadata_assignment2.txt \
  --m-metadata-column Herd \
  --o-visualization core-metrics-results/bray-curtis-herd-significance.qzv \
  --p-pairwise


echo "End time"
date +"%d %B %Y %H:%M:%S"
