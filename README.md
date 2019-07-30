![.](Static/Images/ONT_logo.png "Oxford Nanopore Technologies")

******************

# 1. Introduction:


### Overview:

The **cDNA expression profiling using DESeq2** tutorial is intended as a functional guide to demonstrate a simple strategy for differential expression analysis. This workflow uses Nanopore long read cDNA sequences; basic QC analysis is performed, and the cDNA sequence reads are mapped to the reference genome sequence. The mapped sequence reads and their genomic locations are used to identify the genes that are expressed and a statistical analysis using **`DESeq2`** is used to identify genes that are differentially expressed at a specified statistical confidence level and with a magnitudinal threshold.

### Features:

Sufficient information is provided with the tutorial so that the workflow can be tested, validated, and replicated. The tutorial is provided with an example human cDNA dataset. The tutorial is intended to address important questions;

* which genes are expressed in my study of interest?
* which genes are upregulated in my tumour sample?
* show grouped expression levels for gene *ENSG00000117523*?

******************

# 2. Getting started:

### Input and output: 

This tutorial uses the R markdown contained within this Github repository and an experimental design file (config.yaml) that associates cDNA sequence files (in fastq format) with experimental conditions and controls. An example design file is included within the repository along with replicated sequences from two experimental groups. The result of the tutorial will be a tutorial document in **`html`** format, and a collection of result files in .xlsx format suitable for review using Microsoft Excel. 

### Dependencies:

This tutorial requires a computer running Linux (Centos7, Ubuntu 18_10, Fedora 29). >16 Gb of memory would be recommended. The tutorial has been tested on minimal server installs of these operating systems.

Other dependencies include

* **`Conda`** is required by this tutorial and orchestrates and manages the installation of other required software
* **`R`** is a statistical analysis software and is used for the analysis and reporting of the sequence summary data
* **`Rstudio`** is a graphical user interface to **`R`** and provides much of the required reporting framework
* **`git`** packages for downloading the tutorial from Github repository.
* **`git-lfs`** is required to download the sequence and metadata files provided with the tutorial.
* **`minimap2`** is used for mapping the fastq format DNA sequence reads against the reference genome
* **`samtools`** is used to handle the `sam` and `bam` format mapping data
* **`snakemake`** is required for the automation and pipelining of the bioinformatics workflow used for data analysis
* **`fasta`** format genome reference - the provided `Snakefile` specifies the human genome
* **`gff`** format genome annotation for associating mapped reads with known genes
* **`R`** packages including **`Rsubread`**, **`ShortRead`**, **`DESeq2`**, and **`writexl`** are required for the analysis and interpretation of the genome mapping data, and for preparing results to be written to file. 

### Installation:

1. Most software dependecies are managed though **`conda`**, install as described at  <br> [https://conda.io/docs/install/quick.html](https://conda.io/docs/install/quick.html).
```
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh
    bash
```
2. Download Nanopore tutorials & example files into folder named `cDNA_DESeq2`. This tutorial requires the **`git-lfs`** large file support capabilities; this should be installed first through **`conda`**
```
    conda install -c conda-forge git-lfs
    git lfs install
    git clone https://github.com/nanoporetech/ont_tutorial_cdna_deseq2.git cDNA_DESeq2
```
3. Change working directory into the new `cDNA_DESeq2` folder 
```
    cd cDNA_DESeq2
```
4. Install conda software dependencies with
```
    conda env create --name cDNA_DESeq2 --file environment.yaml
```
5. Initialise conda environment with 
```
    source activate cDNA_DESeq2
```

#### Compilation From Source

This tutorial does not contain software that requires compilation.



### Usage: 

In your Conda environment, and in the tutorial working directory,

1. *optional* edit the provided **`config.yaml`** file to match your own sequence files, reference genome and annotation.
2. Run the **`snakemake`** command to perform the bioinformatics analysis on the specified sequence files
```
    snakemake
```
3. Render the tutorial report using the command below
```
    R --slave -e 'rmarkdown::render("Nanopore_cDNA_Tutorial.Rmd", "html_document")'
```

The provided Rmarkdown tutorial script can also be opened directly in Rstudio

```
rstudio Nanopore_cDNA_Tutorial.Rmd
```

The report can be prepared by "knit" from the GUI as shown in the figure

![.](Static/Images/KnitIt.png "Prepare a report using Knit")


******************

# 3. Results

This tutorial workflow will produce a rich description of your sequence library characteristics and the results from the differential expression analysis. Please visit the tutorial page at [https://community.nanoporetech.com/knowledge/bioinformatics]( https://community.nanoporetech.com/knowledge/bioinformatics) for more information

******************

# 4. Help:

### Licence and Copyright:

© 2019 Oxford Nanopore Technologies Ltd.

Bioinformatics-Tutorials is distributed by Oxford Nanopore Technologies under the terms of the MPL-2.0 license.

### FAQs:



### Abbreviations:


* __knit__ is the command to render an Rmarkdown file. The knitr package is used to embed code, the results of R analyses and their figures within the typeset text from the document. 

* __L50__  describes the number of sequences (or contigs) that are longer than, or equal to, the N50 length and therefore include half the bases of the assembly

* __N50__  describes the length (read length, contig length etc) where half the bases of the sequence collection are contained within reads/contigs of this length or longer

* __Rmarkdown__ is an extension to markdown. Functional R code can be embedded in a plain-text document and subsequently rendered to other formats including the PDF format of this report.

* __QV__  the quality value, -log10(p) that any given base is incorrect. QV may be either at the individual base level, or may be averaged across whole sequences


### References and Supporting Information:

*  https://community.nanoporetech.com/knowledge/bioinformatics
*  https://www.r-project.org/
*  https://snakemake.readthedocs.io/en/stable/
*  https://bioconda.github.io/

