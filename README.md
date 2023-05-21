![R](https://img.shields.io/badge/>=4.1.2-blue?style=for-the-badge&logo=r)
![bash](https://img.shields.io/badge/Bash-black?style=for-the-badge&logo=gnu-bash)

# Parasite-host interaction in Fusarium infection of flax

**NB!** We did not uploaded part of our data, because it will be used in our future work and published later as a part of article.

### Motivation and Aim:  
Fusarium wilt of flax is an aggressive disease caused by soil-borne fungal pathogen Fusarium oxysporum f. sp. lini (FOLINI) posing a major threat to flax production worldwide. It invades the plant through roots and spreads inside the vascular bundle. After germination, it develops microconidia, blocking water and nutrient flow, which leads to plant wilt and death. The fungus produces mycotoxins and enzymes hydrolyzing cell-wall components that facilitate tissue penetration. Most domesticated flax varieties are either highly or moderately resistant to Fusarium wilt. However, a rapid decrease of genetic diversity of flax cultivars and the host-pathogen arms race contribute to increased risk of developing disease. 

### Methods and Algorithms:  
To address the research questions, we examined susceptible LM98 and resistant Atalante flax varieties infected by Fusarium, where uninfected plants and pure culture of the fungus served as controls. Flax samples were harvested on the third and on the fifth day post inoculation (dpi). The total RNA and DNA mixtures (i.e., flax and fungus) were extracted from the infected plant roots. Next, we ran a series of RNA-seq and bisulfite sequencing (BS-seq) experiments. RNA-seq data was processed in parallel with kallisto/sleuth suite and BS-seq data with bismark tool and methylKit package using flax and Fusarium gene models. The enrichment analyses of resulting gene sets of differentially expressed and methylated genes were done with the XGR package using Gene Ontology (GO) and Plant Reactome terms (for flax).

### Results and discussion:  
The in-depth molecular profiling revealed distinct response modes in the studied flax varieties. The LM98 failed to show any methylation dynamic in response to pathogen. As the most important part of our study was integrative analysis, we decided to focus only on the Atalante variety to study molecular mechanisms of resistance to infection. Atalante exhibited a sharp response to infection and activation of mechanisms of ROS reduction, carbohydrates metabolism, kinases activity, cell wall modification, phytoalexins synthesis and endopeptidase inhibition. First three of them turned out to be regulated epigenetically by DNA methylation. Such a defense response faded down on the fifth dpi.

FOLINI methylation data were insufficient for analysis which is consistent with recent studies about low methylation dynamics in fungi. However, analysis of pathogen's differentially expressed genes revealed enriched GO terms associated with peptides synthesis (possibly some effectors and enzymes) and response to oxidative stress on the third dpi and transmembrane transport, carbohydrates metabolism and response to oxidative stress, thus pathogen continued to actively parasitise.

## Schematic representation of full pipeline

![diagram](diagram.png)

## Contents

- **DE** - All information about the directory can be seen in it
- **DMR** - All information about the directory can be seen in it
- **Heatmaps** - directory contains .pdf files of heatmaps of enriched GO and Plant Reactome terms 
- **Barplots** - barplots of number of differentially expressed genes (DEG) and genes associated with differentially methyalted regions of DNA (DMR).
- **Rmarkdown\_scripts** - .Rmd files which used to plot Heatmaps, Barplots and analyze common genes (DEG ∩ genes associated with DMR)  
- **RDS_files** - files that were created during the work of pipeline for fast access to varuiables from different scripts. **This directory is empty** as we cannot publish our full data.
