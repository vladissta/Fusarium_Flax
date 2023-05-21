suppressMessages(library(methylKit))
library(writexl)
suppressMessages(library(dplyr))
library(argparser)
library(latex2exp)

# rm(list = ls(all = TRUE))

#<-----------------------------arsgparser-------------------------------------->

parser <- arg_parser('Argparser for DM')

parser <- add_argument(parser, 'Organism_config',
                       help = 'Path to LU_config/FO_config')
parser <- add_argument(parser, 'experiment_config',
                       help = 'Path to experiment config')
parser <- add_argument(parser, 'context', default = 'CpG',
                       help = 'CpG/CHG/CHH')
parser <- add_argument(parser, '--difference', default = 25, type = 'numeric',
                       help = 'Difference between methylation threshold %')
parser <- add_argument(parser, '--cores', default = 1,
                       help = 'number', type = 'numeric')

args = parse_args(parser)

Organism_config <- args$Organism_config
experiment_config <- args$experiment_config
context <-  args$context
difference <- args$difference
cores <- args$cores


#<------------------------------------------------------------------------>

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
dir.create(file.path(organism_df$variables[1], filename_path, 'OUT_DMR'))

filename_fun = function(TEXT){
  file.path(organism_df$variables[1], filename_path, 'OUT_DMR', paste(filename_path, TEXT, sep = '_'))
}
#<------------------------------------------------------------------>

# load(file = filename_fun('RData', '.'))
meth = readMethylDB(file.path(organism_df$variables[1], filename_path, '/OUT_methDB/methylBase_united.txt.bgz'))

# <-------------------------------DMR--------------------------------->

dif_meth <- calculateDiffMeth(meth, adjust = 'BH', save.db = F, mc.cores = cores)

# Volcano plot and methylation per CHR

DM_plots_pdf_name = filename_fun('DM_PLOTS.pdf')

pdf(DM_plots_pdf_name)

dif_meth<-dif_meth[order(dif_meth$qvalue),]

plot(dif_meth$meth.diff, -log10(dif_meth$qvalue), 
     xlab = 'Meth. Difference', ylab = TeX(r'($ - log_{10}$(q-value))'))
abline(v=0)
abline(v=c(-25,25), col="red")
abline(h=2, col="red")

diffMethPerChr(dif_meth)

dev.off()

# Filtration

dif_meth_all<- getMethylDiff(dif_meth, qvalue = 0.01, difference=25)
dif_meth_up <- getMethylDiff(dif_meth, qvalue = 0.01, difference=25, type = 'hyper')
dif_meth_down <- getMethylDiff(dif_meth, qvalue = 0.01, difference=25, type = 'hypo')

# Output tables with regions

excel_filename_all_regions = filename_fun('all_regions.xlsx')

excel_filename_filtered_regions = filename_fun('DM_ALL_regions.xlsx')
excel_filename_filtered_regions_UP = filename_fun('DM_upregulated_regions.xlsx')
excel_filename_filtered_regions_DOWN = filename_fun('DM_downregulated_regions.xlsx')

write_xlsx(x=data.frame(dif_meth),
           path = excel_filename_all_regions, 
           col_names = TRUE, format_headers = TRUE)

write_xlsx(x=data.frame(dif_meth_all),
           path =  excel_filename_filtered_regions,
           col_names = TRUE, format_headers = TRUE)

write_xlsx(x=data.frame(dif_meth_up),
           path =  excel_filename_filtered_regions_UP,
           col_names = TRUE, format_headers = TRUE)

write_xlsx(x=data.frame(dif_meth_down),
           path =  excel_filename_filtered_regions_DOWN,
           col_names = TRUE, format_headers = TRUE)
