library(methylKit)

ls_files = as.list(c(list.files('./BAMs/AtF3', full.names=T), list.files('./BAMs/LMF3', full.names=T)))

print(ls_files)

myobj <- processBismarkAln(ls_files, sample.id = list("AtF3-1","AtF3-2","AtF3-3",
                                                      "LMF-1", 'LMF-2', 'LMF-4'), read.context = 'CHG',
                           treatment = c(1,1,1,0,0,0), assembly = 'atf3_vs_lmf3', mincov=1)

obj_tiled = tileMethylCounts(myobj, win.size = 1000, step.size = 500, mc.cores = 32, cov.bases = 0)

myobj.norm <- normalizeCoverage(obj_tiled, method = "median")

#meth_1l=unite(myobj.norm, destrand=FALSE, min.per.group=1L)
meth_2l=unite(myobj.norm, destrand=FALSE, min.per.group=2L)
meth_3l=unite(myobj.norm, destrand=FALSE, min.per.group=3L)

#cal_meth_1l <- calculateDiffMeth(meth_1l, adjust="fdr")
cal_meth_2l <- calculateDiffMeth(meth_2l, adjust="fdr")
cal_meth_3l <- calculateDiffMeth(meth_3l, adjust="fdr")

#de_meth_1l <- getMethylDiff(cal_meth_1l, qvalue = 0.01, difference=25)
de_meth_2l <- getMethylDiff(cal_meth_2l, qvalue = 0.01, difference=25)
de_meth_3l <- getMethylDiff(cal_meth_3l, qvalue = 0.01, difference=25)

print(de_meth_1l)
print(de_meth_2l)
print(de_meth_3l)

#write.csv(de_meth_1l, 'table_atf3_vs_lmf3_cpg_1l_1000_step_500.csv')
write.csv(de_meth_2l, 'table_atf3_vs_lmf3_chg_2l_1000_step_500.csv')
write.csv(de_meth_3l, 'table_atf3_vs_lmf3_chg_3l_1000_step_500.csv')
save(meth_2l, meth_3l, myobj.norm, file= 'meth_kit_atf3_vs_lmf3_chg.RData')