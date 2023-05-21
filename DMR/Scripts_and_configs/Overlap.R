suppressMessages(library(methylKit))
library(writexl)
library(readxl)
library(rtracklayer)
suppressMessages(library(dplyr))
library(argparser)
library(ggvenn)

# rm(list = ls(all = TRUE))

#<-----------------------------arsgparser-------------------------------------->

parser <- arg_parser('Argparser for DM')

parser <- add_argument(parser, 'Organism_config', 
                       help = 'Path to LU_config/FO_config')
parser <- add_argument(parser, 'experiment_config', 
                       help = 'Path to experiment config')
parser <- add_argument(parser, 'context', default = 'CpG', 
                       help = 'CpG/CHG/CHH')
parser <- add_argument(parser, '--minoverlap', type = 'numeric',
                       help = 'minoverlap', default=0)

args = parse_args(parser)

Organism_config <- args$Organism_config
experiment_config <- args$experiment_config
context <-  args$context
minoverlap <- args$minoverlap


#<------------------------------------------------------------------>

organism_df <- read.table(Organism_config, sep = '\t', 
                          col.names = c('variables', "comments"), 
                          comment.char = '%')

experiment_df <- read.table(experiment_config, sep = '\t', 
                            col.names = c('group', 'sample', 
                                          'treatment', 'path')) %>%
  mutate(group = as.factor(group))

#<------------------------------------------------------------------>

filename_path = paste(paste(unique(experiment_df$group)[1], 
                            unique(experiment_df$group)[2], sep = '_vs_'),
                      'DMR', context, sep = '_')

# dir.create(file.path(organism_df$variables[1], filename_path))
dir.create(file.path(organism_df$variables[1], filename_path, 'OUT_Overlap'))

filename_fun = function(TEXT){
  file.path(organism_df$variables[1], filename_path, 'OUT_Overlap', paste(filename_path, TEXT, sep = '_'))
}

# <----------------------Annotation------------------------>

dif_meth_all <- read_xlsx(file.path(organism_df$variables[1], filename_path, 
                                    'OUT_DMR', paste(filename_path, 'DM_ALL_regions.xlsx', sep = '_')))

dif_meth_up <-  read_xlsx(file.path(organism_df$variables[1], filename_path, 
                                    'OUT_DMR', paste(filename_path, 'DM_HYPERmethylated_regions.xlsx', sep = '_')))

dif_meth_down <- read_xlsx(file.path(organism_df$variables[1], filename_path, 
                                     'OUT_DMR', paste(filename_path, 'DM_HYPOmethylated_regions.xlsx', sep = '_')))

# <----------------------------------------------------
#reading bedfiles

bed_lu_genes <- import.bed(organism_df$variables[2])

# OVERLAPPING

dif_meth_granges_all = as(dif_meth_all, 'GRanges')
dif_meth_granges_up = as(dif_meth_up, 'GRanges')
dif_meth_granges_down = as(dif_meth_down, 'GRanges')

ovlps_all <- findOverlaps(dif_meth_granges_all, bed_lu_genes, minoverlap = minoverlap)
ovlps_up <- findOverlaps(dif_meth_granges_up, bed_lu_genes, minoverlap = minoverlap)
ovlps_down <- findOverlaps(dif_meth_granges_down, bed_lu_genes, minoverlap = minoverlap)


### overlapping with genes 

regions_hits_all <- dif_meth_granges_all[queryHits(ovlps_all)]
regions_hits_up <- dif_meth_granges_up[queryHits(ovlps_up)]
regions_hits_down <- dif_meth_granges_down[queryHits(ovlps_down)]


dif_meth_regions_all <- as.data.frame(regions_hits_all,
                                            row.names = 1:nrow(as.data.frame(ranges(regions_hits_all))))
dif_meth_regions_up <- as.data.frame(regions_hits_up,
                                           row.names = 1:nrow(as.data.frame(ranges(regions_hits_up))))
dif_meth_regions_down <- as.data.frame(regions_hits_down,
                                             row.names = 1:nrow(as.data.frame(ranges(regions_hits_down))))

hits_all <- bed_lu_genes[subjectHits(ovlps_all)]
hits_up <- bed_lu_genes[subjectHits(ovlps_up)]
hits_down <- bed_lu_genes[subjectHits(ovlps_down)]

dif_meth_all <- as.data.frame(hits_all,
                                    row.names = 1:nrow(as.data.frame(ranges(hits_all))))
dif_meth_up <- as.data.frame(hits_up,
                                   row.names = 1:nrow(as.data.frame(ranges(hits_up)))) 
dif_meth_down <- as.data.frame(hits_down,
                                     row.names = 1:nrow(as.data.frame(ranges(hits_down)))) 

colnames(dif_meth_all) = paste('genes', colnames(dif_meth_all), sep='_')
colnames(dif_meth_up) = paste('genes', colnames(dif_meth_up), sep='_')
colnames(dif_meth_down) = paste('genes', colnames(dif_meth_down), sep='_')

full_df_all <- cbind(dif_meth_regions_all,
                           dif_meth_all[c('genes_start', 'genes_end', 'genes_strand', 'genes_name')]) %>% 
  dplyr::select(-strand) %>% dplyr::rename(strand = genes_strand, gene = genes_name)

full_df_up <- cbind(dif_meth_regions_up,
                          dif_meth_up[c('genes_start', 'genes_end', 'genes_strand', 'genes_name')]) %>% 
  dplyr::select(-strand) %>% 
  dplyr::rename(strand = genes_strand, gene = genes_name)

full_df_down <- cbind(dif_meth_regions_down,
                            dif_meth_down[c('genes_start', 'genes_end', 'genes_strand', 'genes_name')]) %>% 
  dplyr::select(-strand) %>% 
  dplyr::rename(strand = genes_strand, gene = genes_name)

##### output table

write_xlsx(x=data.frame(full_df_all),
           path = filename_fun('ALL.xlsx'),
           col_names = TRUE, format_headers = TRUE)

write_xlsx(x=data.frame(full_df_up),
           path = filename_fun('HYPERmethylated.xlsx'),
           col_names = TRUE, format_headers = TRUE)

write_xlsx(x=data.frame(full_df_down),
           path = filename_fun('HYPOmethylated.xlsx'),
           col_names = TRUE, format_headers = TRUE)
