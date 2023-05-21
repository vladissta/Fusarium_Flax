# Differential Expression

## Contents

### Rmarkdown pipelines

Pipelines (*Rmarkdown files*) containing statistical calculation of differential gene expression of **ORGANISM**, including calculation, filtering, annotation and saving tables in .xlsx format and some figures in .pdf format

- **DE\_pipeline\_LU.Rmd** - **FLAX**
- **DE\_pipeline\_FO.Rmd** - **FUSARIUM**

### PCA

- **PCA_DE.Rmd** - Rmarkdown file that was used to create the PCA plots based on expression profile of samples
- **PCA** - directory containing .pdf files with PCA plots


***[!] All other directories described below are empty and only show how a working directory should look like.***  
***[!] The reason is that we cannot publish our full data***

#### kallisto results 

- **kallisto_FO** - output obtained after processing ***Fusarium*** RNA-seq data with kallisto tool
- **kallisto_LU** - output obtained after processing ***Flax*** RNA-seq data with kallisto tool

Example of how did kallisto otput looked like: [kallisto data example](https://www.dropbox.com/scl/fo/uvlf81h93luk3s1svun75/h?dl=0&rlkey=nxc7ajleurvlls6qfkvh9l0ag)

#### Output directories

These directories are created automatically during the execution of pipeline

- **OUT_FO** - output from execution of **DE\_pipeline\_FO.Rmd**
- **OUT_LU** - output from execution of **DE\_pipeline\_LU.Rmd**


## How to use

#### Firstly, install all required packages:

```bash
Rscript --verbose packages_installation.R
```
(or better run the script in your RStudio IDE)

**All information and comments are contained in Rmarkdown files** - simply open one of Rmarkdown pipelines files and follow the instructions
**Also, you can see the part of RNA-seq processing part in the root directory on the diagram of full pipeline**
