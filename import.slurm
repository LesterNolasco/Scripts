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
cd /depot/microbiome/data/ANSC516/lester

#step 2, Load Modules

echo "loading bioinfo"
module load bioinfo

echo "loading Qiime/2-2022.8"
module load Qiime/2-2022.8

qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path manifest_file.txt \
--input-format PairedEndFastqManifestPhred33V2 \
--output-path demux.qza

qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv

echo "end time"
date +"%d %B %Y %H:%M:%S"
