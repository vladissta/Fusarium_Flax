#!/bin/bash
#SBATCH --job-name=pred_qc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --output=log.txt
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=16

module load r/4.1.2

Rscript --verbose QC.R LU_config.txt experiment_config.txt CpG --cov.bases 25 &&
Rscript --verbose DMR.R LU_config.txt experiment_config.txt CpG &&
Rscript --verbose Overlap.R LU_config.txt experiment_config.txt CpG --minoverlap 50 &&
Rscript --verbose Annotate.R LU_config.txt experiment_config.txt CpG
