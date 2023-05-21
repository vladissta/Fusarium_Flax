suppressMessages(library(methylKit))
library(writexl)
library(readxl)
library(rtracklayer)
suppressMessages(library(dplyr))
library(argparser)
suppressMessages(library(XGR))

rm(list = ls(all = TRUE))

#<-------------------------arsgparser------------------------------->

parser <- arg_parser('Argparser for DM')

parser <- add_argument(parser, 'Organism_config', 
                       help = 'Path to LU_config/FO_config')
parser <- add_argument(parser, 'experiment_config', 
                       help = 'Path to experiment config')
parser <- add_argument(parser, 'context', default = 'CpG', 
                       help = 'CpG/CHG/CHH')

args = parse_args(parser)

Organism_config <- args$Organism_config
experiment_config <- args$experiment_config
context <-  args$context

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
dir.create(file.path(organism_df$variables[1], filename_path, 'OUT_GO'))

filename_fun = function(TEXT){
  file.path(organism_df$variables[1], filename_path, 'OUT_GO', paste(filename_path, TEXT, sep = '_'))
}

#<------------------------------------------------------------------>
full_df_genes_all <- read_xlsx(file.path(organism_df$variables[1], filename_path,
                                     'OUT_Overlap', 
                                     paste(filename_path, 'ALL.xlsx', sep = '_')))

full_df_genes_up <- read_xlsx(file.path(organism_df$variables[1], filename_path,
                                         'OUT_Overlap', 
                                         paste(filename_path, 'HYPERmethylated.xlsx', sep = '_')))
full_df_genes_down <- read_xlsx(file.path(organism_df$variables[1], filename_path,
                                         'OUT_Overlap', 
                                         paste(filename_path, 'HYPOmethylated.xlsx', sep = '_')))

#<----------------------------GO-------------------------------->

bed_lu_genes <- import.bed(organism_df$variables[2])

go_table <- read_xlsx(organism_df$variables[4], 
                      col_names = c ('gene', 'name', 'description')) %>% 
  dplyr::select(gene, description)


table_for_annotation_genes_all <-  data.frame(bed_lu_genes$name,
                                            as.numeric(bed_lu_genes$name %in% full_df_genes_all$gene))
table_for_annotation_genes_up <-  data.frame(bed_lu_genes$name,
                                           as.numeric(bed_lu_genes$name %in% full_df_genes_up$gene))
table_for_annotation_genes_down <-  data.frame(bed_lu_genes$name,
                                             as.numeric(bed_lu_genes$name %in% full_df_genes_down$gene))


#<-------------------------------------------------------------->

annot  = function(sig, background, title, annotation_table){
  
  signames = as.data.frame(sig[,ncol(sig)]) %>% unique()
  
  xsig = xEnricherYours(signames, annotation_table, 
                        size.range=c(10,2000), 
                        min.overlap = 3,
                        test = "hypergeo",
                        background.file = background, 
                        p.adjust.method = 'BH', silent = T)

  
  table_sig <-  xEnrichViewer(xsig, sortBy = 'adjp', 
                               top_num = nrow(xsig$term_info))
  
  if(!is.null(table_sig)){
    table_sig <- table_sig %>% filter(adjp<0.01) 
    # %>% rename(description = name)
    
    rownames(table_sig) = NULL
    
    plot(xEnrichBarplot(xsig, displayBy = 'fdr', FDR.cutoff = 0.01, 
                        bar.label.size = 5,
                        top_num = 10, bar.width = .8) + ggtitle(title)) 
  }
  
  return(as.data.frame(table_sig))
}


pdf(filename_fun('GO_Barplot.pdf'), width = 16)

go_df_genes_all <- annot(full_df_genes_all, table_for_annotation_genes_all, 'ALL Genes', go_table)
go_df_genes_up <- annot(full_df_genes_up, table_for_annotation_genes_up, 'HYPERmethylated Genes', go_table)
go_df_genes_down <- annot(full_df_genes_down, table_for_annotation_genes_down, 'HYPOmethylated Genes', go_table)

dev.off()

#<-------------------------------------------------------------->
write_xlsx(x=go_df_genes_all, path = filename_fun('GO_ALL_Annotations.xlsx'),
           col_names = TRUE, format_headers = TRUE)
write_xlsx(x=go_df_genes_up, path = filename_fun('GO_HYPERmethylated_Annotations.xlsx'),
           col_names = TRUE, format_headers = TRUE)
write_xlsx(x=go_df_genes_down, path = filename_fun('GO_HYPOmethylated_Annotations.xlsx'),
           col_names = TRUE, format_headers = TRUE)

#<-------------------------------------------------------------->

reactome = read_xlsx('reactome_joint.xlsx')

pdf(filename_fun('Reactome_Barplot.pdf'), width = 16)
pathway_df_genes_all <- annot(full_df_genes_all, table_for_annotation_genes_all, 'ALL Genes', reactome)
pathway_df_genes_up <- annot(full_df_genes_up, table_for_annotation_genes_up, 'HYPERmethylated Genes', reactome)
pathway_df_genes_down <- annot(full_df_genes_down, table_for_annotation_genes_down, 'HYPOmethylated Genes', reactome)
dev.off()

#<-------------------------------------------------------------->
write_xlsx(x=pathway_df_genes_all, path = filename_fun('Reactome_ALL_Annotations.xlsx'),
           col_names = TRUE, format_headers = TRUE)
write_xlsx(x=pathway_df_genes_up, path = filename_fun('Reactome_HYPERmethylated_Annotations.xlsx'),
           col_names = TRUE, format_headers = TRUE)
write_xlsx(x=pathway_df_genes_down, path = filename_fun('Reactome_HYPOmethylated_Annotations.xlsx'),
           col_names = TRUE, format_headers = TRUE)
