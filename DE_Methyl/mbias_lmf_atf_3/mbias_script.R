library(methylKit)
library(ggplot2)
setwd('../mbias_lmf_atf_3/')

files = list.files(pattern = '*R[12]*')

read_mbias <- function(sample_name, R){
chg = read.table(paste('M', sample_name ,'_pe.CHG.(',R ,').M-bias.txt', sep = ''),
                 skip = 2, comment.char = '%', header = T)

chh = read.table(paste('M', sample_name ,'_pe.CHH.(',R ,').M-bias.txt', sep = ''),
                 skip = 2, comment.char = '%', header = T)

cpg = read.table(paste('M', sample_name ,'_pe.CpG.(',R ,').M-bias.txt', sep = ''),
                 skip = 2, comment.char = '%', header = T)
return(list(chg, chh, cpg, sample_name, R))
}

mbiasplot <-  function(list_data){
ggplot() + 
  geom_line(data = list_data[[1]], aes(x = position, y=count.1, col = 'red')) +
  geom_line(data = list_data[[2]], aes(x = position, y=count.1, col = 'blue')) +
  geom_line(data = list_data[[3]], aes(x = position, y=count.1, col = 'green')) +
  geom_smooth(data = list_data[[1]], aes(x = position, y=count.1, col = 'red')) +
  geom_smooth(data = list_data[[2]], aes(x = position, y=count.1, col = 'blue')) +
  geom_smooth(data = list_data[[3]], aes(x = position, y=count.1, col = 'green')) +
  scale_color_manual(values = c('red', 'blue', 'green'), name="Position", 
                     labels=c('CHG','CHH','CpG')) +
  labs(title = paste(list_data[[4]], list_data[[5]], 'methylation percentage per postion'),
      x = 'Sites', y = 'Methylation (%)')
}
  
meth_atf1_r1 = readmbias('AtF3-1', 'R1')
meth_atf2_r1 = readmbias('AtF3-2', 'R1')
meth_atf3_r1 = readmbias('AtF3-3', 'R1')

meth_atf1_r2 = readmbias('AtF3-1', 'R2')
meth_atf2_r2 = readmbias('AtF3-2', 'R2')
meth_atf3_r2 = readmbias('AtF3-3', 'R2')

mbiasplot(meth_atf1_r1)
mbiasplot(meth_atf1_r2)

mbiasplot(meth_atf2_r1)
mbiasplot(meth_atf2_r2)

mbiasplot(meth_atf3_r1)
mbiasplot(meth_atf3_r2)

meth_lmf1_r1 = readmbias('LMF3-1', 'R1')
meth_lmf2_r1 = readmbias('LMF3-2', 'R1')
meth_lmf4_r1 = readmbias('LMF3-4', 'R1')

meth_lmf1_r2 = readmbias('LMF3-1', 'R2')
meth_lmf2_r2 = readmbias('LMF3-2', 'R2')
meth_lmf4_r2 = readmbias('LMF3-4', 'R2')

mbiasplot(meth_lmf1_r1)
mbiasplot(meth_lmf1_r2)

mbiasplot(meth_lmf2_r1)
mbiasplot(meth_lmf2_r2)

mbiasplot(meth_lmf3_r1)
mbiasplot(meth_lmf3_r2)
