![R](https://img.shields.io/badge/>=4.1.2-blue?style=for-the-badge&logo=r)
![bash](https://img.shields.io/badge/Bash-black?style=for-the-badge&logo=gnu-bash)

# Parasite-host interaction in Fusarium infection of flax

**NB!** We did not uploaded part of our data, because it will be used in our future work and published later as a part of article.

### Motivation

Flax wilt is an aggressive disease caused by soil-borne pathogen Fusarium oxysporum f. sp. lini (FOLINI). The fungus poses a major threat to flax production worldwide, as occasionally yield losses reach 70%. Here, we present first insights into regulatory mechanisms involved in response of flax varieties to the infection.

### Aim and objectives:  
Our ain is to study the regulation of expression of genes responsible for the molecular mechanisms of flax response to FOLINI infestation

**Objectives:**  

* RNA and DNA sequencing data processing
	* Alignment of reads to the reference genome
	* Filtering and preprocessing data
* Statistical analysis of contrasts between various conditions of flax and FOLINI
	* Differential gene expression analysis (DE)
	* Determination of differential methylated DNA regions (DMR)
* Annotation enrichment analysis with terms:
	* Gene Ontology 
	* Plant Reactome (for flax)
* Integrative Analysis (DE genes ∩ DM genes → Enrichment)

### Experiment and methods

In this study we examined susceptible and resistant flax varieties, namely, LM98 and Atalante, infected by highly virulent MI39 FOLINI isolate. Uninfected plants and pure culture of the fungus served as controls. Flax samples were harvested on the third and the fifth day post inoculation (dpi).
A total RNA and DNA mixtures (i.e., flax and fungus) was extracted from infected plant roots and sequenced. DNA was converted by bisulfite before sequencing.

![experiment](experiment.png)

Reads were were aligned on reference genomes – MI39 isolate for fungus and flax genome assemble with accession number [GCA_000224295.2](https://www.ncbi.nlm.nih.gov/assembly/GCA_000224295.2). 
Aligning reads and abundances quantification of transcripts were obtained by processing RNA-seq data with [Kallisto](https://github.com/pachterlab/kallisto).
Aligning of reads and identification of methylation positions and context (CpG, CHG, CHH, where H = A/C/T) were obtained by processing BS-seq data with [Bismark](https://github.com/FelixKrueger/Bismark).
Quality control and filtering were complete with [sleuth](https://github.com/pachterlab/sleuth) and [methylKit](https://github.com/al2na/methylKit) R packages for transcriptome and methylome data respectively.
Transcripts and methylation regions were filtered by number of cytosines and coverage.  

We planned to analyze 12 flax and 4 FOILINI comparisons between different experimental conditions in differential expression and differential methylation analyses.
#### FOLINI
| Difference of gene expression ||||
|:---:|:---:|:---:|:---:|
| LMF3 vs. FO | LMF5 vs. FO | AtF3 vs. FO | AtF5 vs. FO |

#### Flax
| Difference of gene expression ||||
|:---:|:---:|:---:|:---:|
| Between infected and control samples |  | During infection ||
| LMF3 vs. LMK3 | LMF5 vs. LMK5 | LMF5 vs. LMF3 ||
| AtF3 vs. AtK3 | AtF5 vs. AtK5 | AtF5 vs. AtF3 ||
| Between varieties of flax |  | Between control samples ||
| AtF3 vs. LMF3 || LMK5 vs. LMK3 | AtK5 vs. AtK3 |
| AtF5 vs. LMF5 || AtK3 vs. LMK3 | AtK5 vs. LMK5 |

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