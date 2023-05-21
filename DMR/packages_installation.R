required.packages <- c(
  'dplyr',
  'readxl',
  'writexl',
  'argparser',
  'latex2exp'
)

bioconductor.packages <-c(
'methylKit',
'rtracklayer'
)

install.packages(c(required.packages, 'devtools'))

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(bioconductor.packages, dependencies=T)

# XGR installation
BiocManager::install("remotes", dependencies=T)
BiocManager::install("hfang-bristol/XGR", dependencies=T)

