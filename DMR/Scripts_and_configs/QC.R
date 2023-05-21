suppressMessages(library(methylKit))
suppressMessages(library(dplyr))
library(argparser)

# rm(list = ls(all = TRUE))

#<-----------------------------arsgparser-------------------------------------->

parser <- arg_parser('Argparser for DM')

parser <- add_argument(parser, 'Organism_config',
                       help = 'Path to LU_config/FO_config')
parser <- add_argument(parser, 'experiment_config',
                       help = 'Path to experiment config')
parser <- add_argument(parser, 'context', default = 'CpG',
                       help = 'CpG/CHG/CHH')
parser <- add_argument(parser, '--cov.bases', default = 0,
                       help = 'number', type = 'numeric')
parser <- add_argument(parser, '--cores', default = 1,
                       help = 'number', type = 'numeric')

args = parse_args(parser)

Organism_config <- args$Organism_config
experiment_config <- args$experiment_config
context <-  args$context
cov.bases <- args$cov.bases
cores <- args$cores

#<------------------------------------------------------------------------>

organism_df <- read.table(Organism_config, sep = '\t', 
                          col.names = c('variables', "comments"), 
                          comment.char = '%')

experiment_df <- read.table(experiment_config, sep = '\t', 
                            col.names = c('group', 'sample', 
                                          'treatment', 'path')) %>%
  mutate(group = as.factor(group))

#<------------------------------OUT_QC------------------------------------>

filename_path = paste(paste(unique(experiment_df$group)[1],
                            unique(experiment_df$group)[2], sep = '_vs_'),
                      'DMR', context, sep = '_')

dir.create(file.path(organism_df$variables[1], filename_path))

dir.create(file.path(organism_df$variables[1], filename_path, 'OUT_QC'))

filename_fun = function(TEXT){
  file.path(organism_df$variables[1], filename_path, 'OUT_QC', paste(filename_path, TEXT, sep = '_'))
}

#<---------------------------------------------->

ls_files = as.list(c(experiment_df$path))

print(ls_files)

myobj <- methRead(location = ls_files, 
                  sample.id = as.list(c(experiment_df$sample)), 
                  context = context,
                  treatment = c(experiment_df$treatment), 
                  assembly = organism_df$variables[3], 
                  mincov = 3,
                  pipeline="bismarkCytosineReport")

# <----------------------QC------------------------>

# % methylation and % coverage

meth_n_cov_pdf_name = filename_fun('QC_methyaltion_and_coverage.pdf')

pdf(meth_n_cov_pdf_name, height = 12, width = 10)

par(mfrow = c(length(myobj)/2, 2))
for (i in 1:length(myobj)) {
  getMethylationStats(myobj[[i]], plot=TRUE, both.strands=FALSE, labels = T)
  getCoverageStats(myobj[[i]], plot=TRUE, both.strands=FALSE, labels = T)
}
par(mfrow = c(1, 1))

dev.off()

#<---------------------Tiling---------------------->

obj_tiled <-  tileMethylCounts(myobj,
                               win.size = 400,
                               step.size = 400,
                               mc.cores = cores,
                               cov.bases = cov.bases)

# filtration by coverage, normalization ------->

myobj_filtered<-filterByCoverage(obj_tiled, lo.count=10, lo.perc=NULL,
                                 hi.count=NULL,hi.perc=99.9)

myobj.norm <- normalizeCoverage(myobj_filtered, 
                                method = "median")

meth = unite(myobj.norm, destrand=FALSE,
             save.db = T, 
             dbdir = file.path(organism_df$variables[1], filename_path, 'OUT_methDB/'), 
             suffix = 'united') %>% as(. , 'methylBase')

# SDS histplot

sds_pdf_name = filename_fun('QC_SDS_plot.pdf')

pdf(sds_pdf_name)

pm_t <-percMethylation(meth)
sds_t<-matrixStats::rowSds(pm_t)
hist(sds_t,breaks=100, xlab = 'SD', main = "SD histogram before filtering")
abline(v=1.5, col="red")

meth <- meth[sds_t >= 2]

pm_t <-percMethylation(meth)
sds_t<-matrixStats::rowSds(pm_t)
hist(sds_t,breaks=100, xlab = 'SD', main = "SD histogram after filtering")
abline(v=1.5, col="red")

dev.off()

# Correlation

cor_pdf_name = filename_fun('QC_correlation.pdf')

pdf(cor_pdf_name)

getCorrelation(object = meth, plot=T, method = 'spearman')

dev.off()

# Clusterisation 

cluster_pdf_name = filename_fun('QC_Clusterisation.pdf')

pdf(cluster_pdf_name)

### dendrogram

clusterSamples(meth, dist="euclidean", method="ward.D", plot=TRUE)

### PCA

PCASamples(meth, screeplot=TRUE)

PCASamples(meth, scale = T, center = T, adj.lim = c(1,1))
 
dev.off()


