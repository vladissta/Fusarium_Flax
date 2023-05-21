required.packages <- c(
  'tidyverse',
  'readxl',
  'writexl',
  'cowplot',
  'ggnewscale',
  'showtext',
  'pheatmap',
  'gplots',
  'FactoMineR'
)

install.packages(c(required.packages, 'devtools'))

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(bioconductor.packages, dependencies=T)

# XGR installation
BiocManager::install("remotes", dependencies=T)
BiocManager::install("hfang-bristol/XGR", dependencies=T)

# sleuth installation
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
devtools::install_github("pachterlab/sleuth")

