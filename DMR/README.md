# Differential Methyaltion

## Contents

### Scripts\_and\_configs directory  

#### Scripts  

- **QC.R** - script that draws QC plots, filters by % methyaltion and coverage

- **DMR.R** - script that calculates differential methylation of regions (DMR) + draws volcano plot and DMR per chromosome

- **Overlap.R** - script that finds Lus genes that overlaps with found DM regions

- **Annotate.R** - script that annotate found Lus genes with functional terms  

- **slurm\_script\_example.sh** - *example* of script for work with slurm scheduler (all diff. methylation analysis was done on the cluster with slurm scheduler)  

#### Configs  

- **LU_config.txt** - config of organism. Contains following data (as rows in 1st column):  
  - output direction
  - path to bed file of genes
  - assembly name
  - path to annotation file

- **experiment_config.txt** - config of particular cmparison. Contains following data (as columns):  
  - group name
  - sample name
  - treatment (1 or 0)
  - path to file
 
### Example data

- test\_data - bismark output **example** data
- OUT\_LU\_test - The output from the pipeline run with **example test_data**. 

***It is only examples, beacuase we cannot publish our full data***

## How to use

#### Firstly, install all required packages:

```bash
Rscript --verbose packages_installation.R
```
(or better run the script in your RStudio IDE)

#### For analysis of one comparison

Run in terminal or write in slurm script:

```bash
Rscript --verbose QC.R LU_config.txt experiment_config.txt context --cov.bases X --cores Y
Rscript --verbose DMR.R LU_config.txt experiment_config.txt context --difference X --cores Y
Rscript --verbose Overlap.R LU_config.txt experiment_config.txt context
Rscript --verbose Annotate.R LU_config.txt experiment_config.txt context
```
**X and Y should be replaced with numbers if optional flags should be specified**

_**context** can be CpG, CHG or CHH - context of methylation_  
_**--cov.bases** by default is 0 (you can not to specify this parameter), - minimal number of unmethylated cytosines in one tile (bin)_  
_**--difference** by default is 25 (you can not to specify this parameter) - threshold % of methylation diffence between samples_  
_**--cores** by default is 1 (you can not to specify this parameter) - number of cores to use in work of functions inside the scripts_  

**It is assumed that scripts will be run alternately**

After obtaining and analysing results of first script - it is possible to change some settings and run it again or run the second script to continue pipeline
