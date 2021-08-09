# TSSr: an R/Bioconductor package for comprehensive analyses of transcription start sit (TSS) data

##### Zhaolian Lu, Keenan Berry, Zhenbin Hu, Yu Zhan, Tae-Hyuk Ahn, Zhenguo Lin


## 1. Intruduction

Documentation is also available on GitHub Pages: https://github.com/Linlab-slu/TSSr

 TSSr an R package that provides rich functions for mapping transcription start sites (TSSs) and characterizations of structures and activities of core promoters based on all types of TSS sequencing data, such as cap analysis of gene expression (CAGE) (Takahashi, Lassmann et al. 2012), no-amplification non-tagging CAGE libraries for Illumina next-generation sequencers (nAnT-iCAGE) (Murata, Nishiyori-Sueki et al. 2014), a Super-Low Input Carrier-CAGE (SLIC-CAGE) (Cvetesic, Leitch et al. 2018), NanoCAGE (Cumbie, Ivanchenko et al. 2015), TSS-seq (Malabat, Feuerbach et al. 2015), transcript isoform sequencing (TIF-seq) (Pelechano, Wei et al. 2013), transcript-leaders sequencing (TL-seq) (Arribere and Gilbert 2013), precision nuclear run-on sequencing (PRO-Cap) (Mahat, Kwak et al. 2016), and GRO-Cap/5’GRO-seq (Kruesi, Core et al. 2013).
 
 TSSr package provides a comprehensive workflow on TSS data starts from accurate identification of TSS locations, clustering TSSs within small genomic regions corresponding to core promoters, and quantifications of transcriptional activity, as well as specialized downstream analyses including core promoter shape, cluster annotation, gene differential expression, core promoter shift. TSSr can take multiple formats of files as input, such as Binary Sequence Alignment Mao (BAM) files (single-ended or paired-ended), Browser Extension Data (bed) files, BigWig files, ctss files or tss tables. TSSr generates various types of TSS or core promoter track files which can be visualized in the UCSC Genome Browser or Integrative Genomics Viewer (IGV). TSSr also exports downstream analyses result tables and plots. Multiple cores are supported on Linux or Mac platforms.
 
## 2. Pre-requisites:

* R version
  * Download R (>3.4.0) version from CRAN.
    * Windows: https://cran.r-project.org/bin/windows/base/
    * Mac OS X: https://cran.r-project.org/bin/macosx/
    * Linux: https://cran.r-project.org/bin/linux/

- Rsamtools package

  * install by using the following R commands:

        if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install("Rsamtools")


- GenomicRanges

  * install by using the following R commands:

        if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install("GenomicRanges")

- GenomicFeature package

  * install by using the following R commands:

        if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install("GenomicFeatures")

- Gviz package

  * install by using the following R commands:

        if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install("Gviz")  

- rtracklayer package

  * install by using the following R commands:

        if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install("rtracklayer")

- DESeq2 package:

  * install by using the following R command:

        if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install("DESeq2")

- BSgenome package

  * install by using the following R command:

        if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install("BSgenome")

- data.table package

  * install by using the following R command:

        if (!requireNamespace("data.table", quietly = TRUE))
        install.packages("data.table")

- stringr package

  * install by using the following R command:

        if (!requireNamespace("stringr", quietly = TRUE))
        install.packages("stringr")
	

## 3. Installing TSSr Package:

To install the TSSr package all the prerequisites above need to be installed.
After confirming those packages are installed, you can install the development version directly from GitHub using devtools:

        devtools::install_github("Linlab-slu/TSSr")

## 4. Input data for TSSr

* Input data files

  TSSr accepts two types of input data: read alignment files or TSS tables. The read alignment files in compressed binary alignment map (BAM) format are required if users intend to call TSSs from raw sequencing data. BAM files can be derived from mapping of either paired-end or single-end TSS sequencing reads. Users should set “inputFilesType” as “bam” for single-end reads and as “bamPairedEnd” for paired-end BAM files. To provide more accurate quantification of transcription initiation events at each TSS, we recommend excluding reads mapped to rRNA from BAM files before TSS calling and subsequent analyses. Removal of rRNA reads from BAM files can be carried out by rRNAdust (https://fantom.gsc.riken.jp/5/sstar/Protocols:rRNAdust) based on rRNA sequences provided by users. The reference genome stored as a BSgenome data package must be provided for TSS calling. TSSr also accepts TSS tables generated by TSSr or other bioinformatics tools as input data. A TSS table can be a tab-delimited text file, a BigWig (bw) binary type file, or browser extensible data (bed) type file. A tab-delimited TSS table contains chromosome ID, genomic coordinates, strand information, and raw or normalized read counts of each sample. An example tab-delimited TSS table is included in the package. Users should set “inputFilesType” as “TSStable” in this scenario. 
  

* Reference genome

  In this tutorial, we will be using TSS data from Saccharomyces cerevisiae. Therefore, the corresponding genome package is BSgenome.Scerevisiae.UCSC.sacCer3. 
library(BSgenome.Scerevisiae.UCSC.sacCer3)
In case the reference genome is not available in BSgenome package (not in the list returned by BSgenome::available.genomes() function), a custom genome has to be built and installed before run through this package. (See the vignette “How to forge a BSgenome data package” within the BSgenome package for instructions). 
Annotation file (GTF or GFF file) is required if annotateCluster function is called. We will use the annotation file of Saccharomyces cerevisiae which can be downloaded from SGD database (http://sgd-archive.yeastgenome.org/curation/chromosomal_feature/saccharomyces_cerevisiae.gff.gz).

* S4 object

  TSSr uses S4 object to store all input files and arguments and generate downstream analysis results.

## 5. Usage:

* Launch TSSr

        library(TSSr)
      
* Option 1: using the provided example TSSr object "exampleTSSr" to explore the fucntions of TSSr. Skip the TSS calling  step if the user plan to creat a new TSSr object using bam or TSS table files 

        myTSSr <- exampleTSSr 
        
* A subset of Saccharomyces cerevisiae TSS data generated by (Lu and Lin 2019) will be used in the following demonstrations of TSSr workflow. Bam files generated by HISAT2 (Kim, Langmead et al. 2015) with genomic coordinates of TSSs detected by nAnT-iCAGE under two growth conditions (YPD and cell arrest) are included in this package. These files contain a part of reads which are mapped to chromosome I and chromosome II.  There are two replicate files for each growth condition.
inputFiles = list.files() To creat a new TSSr object, users will need to generate a new input files "inputFiles" that contains the path and file names of input files. We provided for example bam files. The four example bam files (S01.sorted.bam, S02.sorted.bam, S03.sorted.bam, S04.sorted.bam) can be downloaded from http://zlinlab.org/TSSr.html.

        inputFiles <- c("S01.sorted.bam", "S02.sorted.bam", "S03.sorted.bam", "S04.sorted.bam")

* The TSSr object is created with the constructer function new, which requires information on reference genome name, input file path, input file type, samples labels, sampleLabelsMerged (if samples are to be merged), annotation file path (if annotateCluster is to be called), organism name (if annotateCluster is to be called).

        myTSSr <- new("TSSr", genomeName = "BSgenome.Scerevisiae.UCSC.sacCer3"
	              ,inputFiles = inputFiles
	              ,inputFilesType= "bam"
	              ,sampleLabels = c("SL01","SL02","SL03","SL04")
	              ,sampleLabelsMerged = c("control","treat")
	              ,mergeIndex = c(1,1,2,2)
	              ,refSource = "saccharomyces_cerevisiae.SGD.gff"
	              ,organismName = "Saccharomyces cerevisiae")
	
	To display the available slots in the created TSSr object:
	
	     myTSSr
	      
	      # An object of class "TSSr"
        # Slot "genomeName":
        #   [1] "BSgenome.Scerevisiae.UCSC.sacCer3"
        # 
        # Slot "inputFiles":
        #   [1] "S01.sorted.bam" "S02.sorted.bam" "S03.sorted.bam" "S04.sorted.bam"
        # 
        # Slot "inputFilesType":
        #   [1] "bam"
        # 
        # Slot "sampleLabels":
        #   [1] "SL01" "SL02" "SL03" "SL04"
        # 
        # Slot "sampleLabelsMerged":
        #   [1] "control" "treat"  
        # 
        # Slot "librarySizes":
        #   integer(0)
        # 
        # Slot "TSSrawMatrix":
        #   data frame with 0 columns and 0 rows
        # 
        # Slot "mergeIndex":
        #   numeric(0)
        # 
        # Slot "TSSmergedMatrix":
        #   data frame with 0 columns and 0 rows
        # 
        # Slot "TSSnormalizedMatrix":
        #   data frame with 0 columns and 0 rows
        # 
        # Slot "TSSfilteredMatrix":
        #   data frame with 0 columns and 0 rows
        # 
        # Slot "tagClusters":
        #   list()
        # 
        # Slot "consensusClusters":
        #   list()
        # 
        # Slot "clusterShape":
        #   list()
        # 
        # Slot "refSource":
        #   [1] "saccharomyces_cerevisiae.SGD.gff"
        # 
        # Slot "organismName":
        #   [1] "saccharomyces cerevisiae"
        # 
        # Slot "assignedClusters":
        #   list()
        # 
        # Slot "unassignedClusters":
        #   list()
        # 
        # Slot "DEtables":
        #   list()
        # 
        # Slot "PromoterShift":
        #   list()
	
	The information that was provided when creating the TSSr object can be seen in myTSSr object, whereas all other slots are empty since no data has been read and no analysis has been conducted.
	
* TSS calling from bam files or retrieving TSS data from TSS table 

	To read input files into the TSSr object, we use getTSS function, which retrieves TSS coordinates and tag counts from multiple samples into one data table.
	
        getTSS(myTSSr)
        
        myTSSr@TSSrawMatrix
        
        # chr    pos strand SL01 SL02 SL03 SL04
        # 1:  chrI   1561      +    0    0    0    1
        # 2:  chrI   1823      +    1    0    0    0
        # 3:  chrI   1828      +    0    0    0    2
        # 4:  chrI   1830      +    0    0    1    0
        # 5:  chrI   1831      +    0    0    0    1
        # ---                                        
        # 171537: chrII 812483      -    0    0    0    1
        # 171538: chrII 812789      -    0    0    0    2
        # 171539: chrII 812802      -    0    0    0    2
        # 171540: chrII 812805      -    0    0    0    1
        # 171541: chrII 812818      -    0    0    0    1

	TSSrawMatrix contains raw read counts of each called TSS. Raw TSS count can be exported to TSS tables can be used as inout for future analysis using TSSr. The output TSS table is saved as "ALL.samples.TSS.raw.txt" in the working directory.    

        exportTSStable(myTSSr, data = "raw", merged = "FALSE")
	
	To better acknowledge the TSS data across samples, we can use plotCorrelation function to calculate the pairwise correlation coefficients and plot pairwise scatter plots of TSS tags. A subset of samples can also be specified to display the pairwise correlations. Three correlation methods are supported: “pearson”, “kendall”, or “spearman”.
	
        plotCorrelation(myTSSr, samples = "all")
        
![01_TSS_correlation_plot_of_all_samples](https://github.com/Linlab-slu/TSSr/raw/master/vignettes/figures/01_TSS_correlation_plot_of_all_samples.png){width=50%}

  To further explore the variation present in the TSS dataset and identify which samples are similar to each other and which samples are very different, we can apply plotPCA function to plot principle component analysis among all samples. plotPCA will make a biplot which visualizes both how samples relate to each other in terms of PC1 and PC2 and simultaneously show how each variable contributes to each principal component.
  
    plotTssPCA(myTSSr, TSS.threshold=10)

![02_PCA_plot](https://raw.githubusercontent.com/Linlab-slu/TSSr/master/vignettes/figures/02_PCA_plot.png){width=50%}

  Based on the calculated correlations, two replicates are highly correlated. To facilitate the downstream analysis and comparisons between different growth condition, we merge the two replicates for each growth condition together with mergeSamples function. mergeIndex argument directs which samples will be merged and how the final dataset will be ordered accordingly.
  
        mergeSamples(myTSSr)
        
        myTSSr@TSSprocessedMatrix
        
        # chr    pos strand control treat
        # 1:  chrI   1561      +       0     1
        # 2:  chrI   1823      +       1     0
        # 3:  chrI   1828      +       0     2
        # 4:  chrI   1830      +       0     1
        # 5:  chrI   1831      +       0     1
        # ---                                  
        # 171537: chrII 812483      -       0     1
        # 171538: chrII 812789      -       0     2
        # 171539: chrII 812802      -       0     2
        # 171540: chrII 812805      -       0     1
        # 171541: chrII 812818      -       0     1

  To return library sizes (number of total sequenced tags) of each sample in TSSr object in the specified order (note: order is specified in mergeSample function):

        myTSSr@librarySizes
        # [1] 3353873 5563702

  Library sizes among different samples are different. To make samples comparable, we use normalizeTSS function to scale TSS raw counts by tags per million (TPM).

        normalizeTSS(myTSSr)
        
  There is a great amount of TSSs with low weak transcriptional signals. To filter out low-fidelity TSSs, we use filterTSS function to remove TSSs below the specified threshold. Two filtering methods are supported: “poisson” or “TPM”. 

        filterTSS(myTSSr, method = "TPM",tpmLow=0.1)
    
        myTSSr@TSSprocessedMatrix
        
        # chr    pos strand  control    treat
        # 1:  chrI   1561      + 0.000000 0.179736
        # 2:  chrI   1823      + 0.298163 0.000000
        # 3:  chrI   1828      + 0.000000 0.359473
        # 4:  chrI   1830      + 0.000000 0.179736
        # 5:  chrI   1831      + 0.000000 0.179736
        # ---                                      
        # 171537: chrII 812483      - 0.000000 0.179736
        # 171538: chrII 812789      - 0.000000 0.359473
        # 171539: chrII 812802      - 0.000000 0.359473
        # 171540: chrII 812805      - 0.000000 0.179736
        # 171541: chrII 812818      - 0.000000 0.179736

  The processed TSS matrix can be exported to either text tables or bedGraph/BigWig tracks which can be visualized in the UCSC Genome Browser or Integrative Genomics Viewer (IGV).    
        exportTSStoBedgraph(myTSSr, data = "processed", format = "bedGraph")
        exportTSStoBedgraph(myTSSr, data = "processed", format = "BigWig")
        
* TSS clustering

  TSSs within a small genomic region are likely regulated by the sample regulatory elements, and thus can be clustered together as tag clusters (TCs). The simplest and widely used algorithm is distance-based clustering (disclu) in which neighboring TSSs are grouped together if they are closer than a specified distance (Haberle, Forrest et al. 2015). Since disclu algorithm ignores TSS signal distribution within one cluster, it might potentially generate extra big clusters with more than one peaks if the distance threshold is too big. However, reducing distance threshold might create many small clusters. Thus, we developed a peak-based clustering algorithm in which TSSs are clustered based on strong TSS signals which are identified as peaks.
We will perform peak-based clustering with clusterTSS function using 100bp as the minimal range within which there is at most one peaks and use an extension distance 30bp to join neighboring TSSs into the peak defined clusters. We implement another layer of local filtering which rules out weak TSS signals downstream of peaks that are potentially brought out from recapping and are always considered as noise. After clustering, clusters below cluster Threshold will be filtered out. clusterTSS function generates a set of clusters for each sample separately. In each cluster, clusterTSS function returns genomic coordinates, sum of TSS tags, dominate TSS coordinate, a lower (q0.1) and an upper (q0.9) quantile coordinates, and interquantile widths.
This clustering step might be slow especially when the number of TSSs is in millions. Using multicores is highly recommended.

        clusterTSS(myTSSr, method = "peakclu",peakDistance=100,extensionDistance=30
	           ,localThreshold = 0.02,clusterThreshold = 1
	           ,useMultiCore=FALSE, numCores=NULL)
	           
        myTSSr@tagClusters
        
        # $`control`
        # cluster  chr start  end strand dominant_tss    tags tags.dominant_tss q_0.1 q_0.9 interquantile_width
        # 1:    1 chrI  6530  6564   +     6548  8.944883     3.577953  6548  6562         15
        # 2:    2 chrI  7166  7189   +     7169  1.192652     0.596326  7166  7189         24
        # 3:    3 chrI  8084  8087   +     8084  1.192652     0.596326  8084  8087          4
        # 4:    4 chrI  9325  9411   +     9327  4.770607     1.192651  9327  9391         65
        # 5:    5 chrI  9442  9479   +     9442  3.279792     1.788977  9442  9468         27
        # ---                                                        
        # 3485:  3485 chrII 810641 810721   -    810641 77.224157     21.765881 810641 810719         79
        # 3486:  3486 chrII 810760 811032   -    810916 46.513400     5.963255 810796 810962         167
        # 3487:  3487 chrII 811067 811170   -    811112 11.330187     8.348557 811111 811131         21
        # 3488:  3488 chrII 811200 811384   -    811291 29.518121     6.559581 811239 811366         128
        # 3489:  3489 chrII 811446 811512   -    811486 607.059367    313.965377 811485 811494         10
        # 
        # $treat
        # cluster  chr start  end strand dominant_tss    tags tags.dominant_tss q_0.1 q_0.9 interquantile_width
        # 1:    1 chrI  1828  1841   +     1828  1.078417     0.359473  1828  1841         14
        # 2:    2 chrI  6521  6564   +     6559  4.673145     1.617628  6530  6559         30
        # 3:    3 chrI  7096  7118   +     7100  1.797363     0.539209  7096  7114         19
        # 4:    4 chrI  8061  8087   +     8061  1.797363     0.539209  8061  8087         27
        # 5:    5 chrI  9327  9476   +     9359 10.604449     1.617628  9327  9452         126
        # ---                                                        
        # 3382:  3382 chrII 809707 809710   -    809707  1.258155     0.898682 809707 809710          4
        # 3383:  3383 chrII 810641 810736   -    810641 121.501831     29.297040 810641 810719         79
        # 3384:  3384 chrII 810773 811031   -    810916 67.401151     14.738388 810794 810963         170
        # 3385:  3385 chrII 811108 811377   -    811112 69.557986     14.019442 811112 811366         255
        # # 3386:  3386 chrII 811472 811503   -    811486 449.700575    234.196583 811486 811494          9

		    exportClustersTable(myTSSr, data = "assigned")
		    
		    exportClustersToBed(myTSSr, data = "tagClusters")

* Aggregating consensus clusters

  TSSs are clustered into tag clusters for each sample individually and they are often sample-specific. To make clusters comparable between samples, we will use consensusCluster function to generate a single set of consensus clusters. Similarly to clusterTSS function, consensusCluster function also returns genomic coordinates, sum of TSS tags, dominate TSS coordinate, a lower (q0.1) and an upper (q0.9) quantile coordinates, and interquantile widths for each consensus cluster in each sample.
  
        consensusCluster(myTSSr, dis = 50, useMultiCore = FALSE)
		    
  Tag clusters and consensus cluster with quantile positions can be exported to either text tables or BED tracks which can be visualized in the UCSC Genome Browser and IGV. 

		    exportClustersToBed(myTSSr, data = "consensusClusters")


* Core promoter shape

  According to the distribution of TSSs within a core promoter (cluster), termed as core promoter shape, core promoters were generally classified into sharp core promoters and broad core promoters. TSSr implements three methods to characterize core promoter shape. The simplest way is to use interquantile width representing core promoter shape. plotInterQuantile function plots interquantile width of each sample.

        plotInterQuantile(myTSSr,samples = "all",tagsThreshold = 1)
    
![03_Interquantile_plot_of_ALL_samples](https://github.com/Linlab-slu/TSSr/raw/master/vignettes/figures/03_Interquantile_plot_of_ALL_samples.png){width=50%}

  Another way to characterize core promoter shape is shape index (SI) which is determined by the probabilities of tags at every TSSs within one cluster (Hoskins, Landolin et al. 2011). SI is calculated using shapeCluster function with method set as “SI”. The greater value represents the sharper core promoter. SI is 2 representing singletons. Genome-wide SI score can be plotted with plotShape function.

  By integrating both inter quantile width and the observed probabilities of tags at every TSSs within a cluster, we developed a new metric called promoter shape score (PSS) to describe core promoter shape (Lu and Lin 2019). PSS can be calculated using using shapeCluster function with method set as “PSS”. The smaller value represents the sharper core promoter. PSS is 0 representing singletons. Genome-wide PSS score can be plotted with plotShape function.
  
        shapeCluster(myTSSr,clusters = "consensusClusters", method = "PSS",useMultiCore= FALSE, numCores = NULL)

        myTSSr@clusterShape
        
        # $`control`
        # cluster chr start end strand dominant_tss  tags tags.dominant_tss q_0.1 q_0.9 interquantile_width shape.score
        # 1:  432 chrII 127 175  +   150 3.279792   0.894488 145 171     27 -0.41938195
        # 2:  433 chrII 4016 4045  +   4016 2.087141   0.596326 4016 4045     30 -0.23592635
        # 3:  434 chrII 4299 4318  +   4300 1.192652   0.596326 4299 4318     20 0.50000000
        # 4:  435 chrII 5328 5359  +   5328 1.788977   1.192651 5328 5359     32 0.74837083
        # 5:  436 chrII 5577 5577  +   5577 1.788977   1.788977 5577 5577     1 2.00000000
        # ---                                 
        # 3484: 2526 chrI 222756 223117  -  222884 30.114450   2.385302 222847 223076     230 -2.83272807
        # 3485: 2528 chrI 223374 223416  -  223395 2.981629   1.490814 223374 223416     43 0.03903595
        # 3486: 2529 chrI 223656 223696  -  223660 1.490815   0.596326 223656 223696     41 0.07807191
        # 3487: 2530 chrI 225020 225056  -  225056 1.192652   0.596326 225020 225056     37 0.50000000
        # 3488: 2532 chrI 227236 227274  -  227274 2.385303   0.894488 227236 227274     39 -0.15563906
        # 
        # $treat
        # cluster chr start end strand dominant_tss  tags tags.dominant_tss q_0.1 q_0.9 interquantile_width shape.score
        # 1:  436 chrII 5525 5587  +   5577 2.875781   1.977101 5534 5577     44 0.9107699
        # 2:  437 chrII 5895 5955  +   5955 1.797364   0.718946 5920 5955     36 0.1634083
        # 3:  438 chrII 7626 7682  +   7649 7.189456   1.258155 7630 7658     29 -0.8540706
        # 4:  439 chrII 8410 8455  +   8425 4.313673   1.437892 8425 8452     28 -0.4516085
        # 5:  440 chrII 8492 8584  +   8550 12.401807   2.875783 8513 8557     45 -1.0242498
        # ---                                 
        # 3380: 2526 chrI 222797 222969  -  222851 17.614164   4.493411 222851 222961     111 -1.4326016
        # 3381: 2527 chrI 223326 223327  -  223326 1.258155   0.898682 223326 223327     2 1.1368794
        # 3382: 2529 chrI 223659 223697  -  223681 2.156836   0.718946 223659 223696     38 -0.3685225
        # 3383: 2531 chrI 226791 226810  -  226805 1.437890   0.359473 226791 226810     20 -0.5000000
        # 3384: 2532 chrI 227249 227300  -  227270 6.290774   1.977101 227258 227276     19 -0.2658030

        plotShape(myTSSr)
    
![04_Shape_plot_of_ALL_samples](https://github.com/Linlab-slu/TSSr/raw/master/vignettes/figures/04_Shape_plot_of_ALL_samples.png){width=50%}

		    exportShapeTable(myTSSr)

* Annotation

  TSSr identifies TSSs and therefore detect core promoters. However, the current databases are mainly on gene levels instead of TSS or core promoter levels. annorateCluster function is used to associate core promoters to genes. Since annotated genes in Saccharomyces cerevisiae GFF annotation file don’t contain 5’ untranslated region (UTR), that is, the first genomic position of each gene in annotations is start position of translation. Therefore, in order to associate clusters to genes, we specify the upstream distance as 1000 and downstream distance as 0. The 1000 bp region is defined as core promoter region. In case of overlapping with upstream genes, we specify upstreamOverlap argument as 500 representing only considering the first 500 bp regions as core promoter region if it is overlapped with upstream genes.
To reduce transcriptional or technical noise of small clusters downstream a strong cluster, we apply filterCluster argument and set filterClusterThreshold as 0.02, representing clusters in which total tags lower than the strong cluster*0.02 will be filtered out.

        annotateCluster(myTSSr,clusters = "consensusClusters",filterCluster = TRUE,
	                filterClusterThreshold = 0.02, annotationType = "genes"
	                ,upstream=1000, upstreamOverlap = 500, downstream = 0)
	                
        myTSSr@assignedClusters
        
        # $`control`
        # cluster chr start end strand dominant_tss  tags tags.dominant_tss q_0.1 q_0.9 interquantile_width  gene
        # 1:  6 chrI 9325 9411  +   9327 4.770607   1.192651 9327 9391     65 YAL066W
        # 2:  7 chrI 9442 9479  +   9442 3.279792   1.788977 9442 9468     27 YAL066W
        # 3:  8 chrI 11253 11343  +  11329 39.059326   16.995277 11275 11329     55 YAL064W-B
        # 4:  44 chrI 31027 31151  +  31108 46.215232   16.398951 31108 31145     38 YAL062W
        # 5:  45 chrI 31187 31263  +  31242 307.405801  117.774287 31212 31242     31 YAL062W
        # ---                                 
        # 864: 4493 chrII 804562 804593  -  804591 1.490814   0.894488 804562 804593     32 YBR298C
        # 865: 4494 chrII 804855 804975  -  804895 250.456717   68.875595 804868 804899     32 YBR298C
        # 866: 4497 chrII 809353 809377  -  809377 1.788977   1.490814 809353 809377     25 YBR300C
        # 867: 4498 chrII 809707 809748  -  809707 3.876117   2.087139 809707 809724     18 YBR300C
        # 868: 4503 chrII 811446 811512  -  811486 607.059367  313.965377 811485 811494     10 YBR302C
        # 
        # $treat
        # cluster chr start end strand dominant_tss  tags tags.dominant_tss q_0.1 q_0.9 interquantile_width  gene
        # 1:  1 chrI 1828 1841  +   1828 1.078417   0.359473 1828 1841     14 YAL067W-A
        # 2:  6 chrI 9327 9476  +   9359 10.604449   1.617628 9327 9452     126 YAL066W
        # 3:  8 chrI 11259 11343  +  11329 54.639873   20.130481 11288 11329     42 YAL064W-B
        # 4:  9 chrI 11651 11762  +  11651 1.977099   0.359473 11651 11750     100 YAL064W-B
        # 5:  10 chrI 11861 11934  +  11919 2.875780   0.898682 11889 11923     35 YAL064W-B
        # ---                                 
        # 816: 4488 chrII 801017 801061  -  801023 6.290772   1.797364 801022 801058     37 YBR296C-A
        # 817: 4494 chrII 804851 804952  -  804895 144.867571   50.326204 804872 804901     30 YBR298C
        # 818: 4497 chrII 809377 809389  -  809377 1.078419   0.718946 809377 809389     13 YBR300C
        # 819: 4498 chrII 809707 809710  -  809707 1.258155   0.898682 809707 809710     4 YBR300C
        # 820: 4503 chrII 811472 811503  -  811486 449.700575  234.196583 811486 811494     9 YBR302CThe 

  Instead of visualizing TSSs and core promoters in the UCSC Genome Browser or IGV, plotTSS function is able to generate publish ready figures when list of interested genes are provided and plotting region is specified.
                  
  A function of exportClustersTable is provided to export cluster tables with associated gene information.
        
        exportClustersTable(myTSSr, data = "assigned")

* Differential expression analysis

  The number of tags at each TSS reflects the number of transcripts initiated at the TSS. Thus, TSS data can be used for expression profiling. With specified sample pairs for comparison, deGene function counts raw tags of each consensus clusters and utilizes the DESeq2 package (Love, Huber et al. 2014) for differential expression analysis. 
        
        deGene(myTSSr,comparePairs=list(c("control","treat")), pval = 0.01,useMultiCore=FALSE, numCores=NULL)
        
  Differential expression analysis results can be visualized by plotDE function which generates a volcano plots. Names of genes differential expressed between the compared pairs are displayed on the dots when the withGeneName argument is set as TRUE.  

        plotDE(myTSSr, withGeneName = "TRUE",xlim=c(-2.5, 2.5),ylim=c(0,10))


  Differential expression analysis results can also be exported to a text file with exportDETable function. 

        exportDETable(myTSSr, data = "sig")

![05_Volcano_plot](https://github.com/Linlab-slu/TSSr/raw/master/vignettes/figures/05_Volcano_plot.png){width=50%}

* Core promoter shifts

  One gene might have multiple core promoters which can be used differently in different samples. TSSr implements degree of shift (Ds) algorithm (Lu and Lin 2019) to quantify the degree of promoter shift across different samples.

        shiftPromoter(myTSSr,comparePairs=list(c("control","treat")), pval = 0.01)
                
        myTSSr@PromoterShift
        
        # $`control_VS_treat`
        # gene                  Ds                  pval          padj
        # 1:   YAR027W    -10.350816320988                     0  0.000000e+00
        # 2:   YBL017C    16.4385383531034                     0  0.000000e+00
        # 3:   YBR006W   -26.1598728383391                     0  0.000000e+00
        # 4:   YBR023C     18.118979599068                     0  0.000000e+00
        # 5:   YBR039W   -27.4865860443054                     0  0.000000e+00
        # 6:   YBR121C    -32.547014080256                     0  0.000000e+00
        # 7:   YBL067C   -25.3869440027767 3.07511136581584e-289 1.273975e-287
        # 8:   YBL061C    23.7545209498577 3.44768363971726e-197 1.249785e-195
        # 9: YBL039W-B    23.4499059050598  4.6945530608788e-166 1.361420e-164
        # 10:   YBR040W    14.5616268341053 4.43031120733306e-147 1.167991e-145
        # 11:   YBR230C    12.4848555795528 7.72945248945236e-108 1.867951e-106
        # 12:   YBL003C    -4.1985604478168   6.7759310150691e-97  1.310013e-95
        # 13:   YBL016W    4.41343932260964  7.82940255472119e-47  1.195014e-45
        # 14:   YBR203W    10.6049068930757  6.08620650498862e-20  6.086207e-19
        # 15:   YBR086C     9.7196265707056  9.60207832249196e-19  9.282009e-18
        # 16:   YBR277C    17.2140839363989  2.44487670373165e-18  2.287143e-17
        # 17:   YBR295W    9.77234308829983   2.9084950406724e-17  2.635824e-16
        # 18:   YBR083W    4.17916131373144    9.606481245865e-16  8.442059e-15
        # 19:   YAL054C   -3.17330325909555  1.30266337135917e-15  1.111095e-14
        # 20:   YBR296C    9.18633075573362  2.50237783136509e-13  2.073399e-12
        # 21:   YBR093C   -3.40836871919578   1.6515719663441e-12  1.330433e-11
        # 22: YBR084C-A    9.00947030426105  1.86567997266701e-12  1.462290e-11
        # 23:   YBL004W   -1.67847881078767  2.07674225051448e-12  1.584882e-11
        # 24:   YBR184W   -15.1239290662261  7.92183774469212e-12  5.890597e-11
        # 25:   YBL105C    2.64342413974809   4.7745199157064e-11  3.461527e-10
        # 26:   YBL102W    -8.9100339041354  1.89050230887831e-10  1.305347e-09
        # 27:   YBL013W    -15.319403967074  3.99191692700095e-10  2.692223e-09
        # 28:   YBR211C    8.77437715012659  5.71127699857609e-10  3.764251e-09
        # 29:   YBR068C    8.67245301942337  6.31376887472524e-10  4.068873e-09
        # 30:   YBR175W    -9.1774269748887   3.3596751940423e-09  2.118056e-08
        # 31:   YBR218C    8.35135511413055  5.41322815151343e-08  3.340077e-07
        # 32:   YBR015C   -1.55009946287707  6.16237577511048e-08  3.723102e-07
        # 33:   YBR035C    2.18654908878179  6.92159737581857e-08  4.096456e-07
        # 34:   YBL054W    2.83357254525628  1.99671083965614e-07  1.158092e-06
        # 35:   YBR168W   -1.51588973572886  3.12105035998543e-07  1.774715e-06
        # 36:   YBR117C   -2.07172815538228  4.13101210450534e-05  2.260365e-04
        # 37:   YBR008C    1.03432937413973  6.72116190177454e-05  3.609513e-04
        # 38:   YBR270C   -1.68431187859011   7.7446526380902e-05  4.083544e-04
        # 39:   YBL083C   0.372760077005376                     1  1.000000e+00
        # 40:   YBR186W -0.0982423034021808                     1  1.000000e+00
        # 41:   YBR300C    0.86895953363737                     1  1.000000e+00
        # gene                  Ds                  pval          padj

  Below is an example of core promoter shift in gene YBL017C. The two major core promoters are differently used in control and treat samples.

        plotTSS(myTSSr,samples=c("control","treat"),tssData = "processed",clusters = "assigned",clusterThreshold = 0.02 ,genelist=c("YBL017C","YBL067C"),up.dis =500,down.dis = 100,yFixed=TRUE)
          
![06_TSS_graphs](https://github.com/Linlab-slu/TSSr/raw/master/vignettes/figures/06_TSS_graphs.png){width=50%}

  Results of core promoter shift analysis can also be exported to a text file with exportShiftTable function.
        
        exportShiftTable(myTSSr)
    

## 7. Contact:

Zhenguo Lin, PhD

Department of Biology, Saint Louis University, USA.

Email: zhenguo.lin@slu.edu

## 8. Reference:

Arribere, J. A. and W. V. Gilbert (2013). "Roles for transcript leaders in translation and mRNA decay revealed by transcript leader sequencing." Genome Res 23(6): 977-987.

Cumbie, J. S., M. G. Ivanchenko and M. Megraw (2015). "NanoCAGE-XL and CapFilter: an approach to genome wide identification of high confidence transcription start sites." BMC Genomics 16: 597.

Cvetesic, N., H. G. Leitch, M. Borkowska, F. Muller, P. Carninci, P. Hajkova and B. Lenhard (2018). "SLIC-CAGE: high-resolution transcription start site mapping using nanogram-levels of total RNA." Genome Res 28(12): 1943-1956.

Kruesi, W. S., L. J. Core, C. T. Waters, J. T. Lis and B. J. Meyer (2013). "Condensin controls recruitment of RNA polymerase II to achieve nematode X-chromosome dosage compensation." Elife 2: e00808.

Mahat, D. B., H. Kwak, G. T. Booth, I. H. Jonkers, C. G. Danko, R. K. Patel, C. T. Waters, K. Munson, L. J. Core and J. T. Lis (2016). "Base-pair-resolution genome-wide mapping of active RNA polymerases using precision nuclear run-on (PRO-seq)." Nat Protoc 11(8): 1455-1476.

Mahat, D. B., H. Kwak, G. T. Booth, I. H. Jonkers, C. G. Danko, R. K. Patel, C. T. Waters, K. Munson, L. J. Core and J. T. Lis (2016). "Base-pair-resolution genome-wide mapping of active RNA polymerases using precision nuclear run-on (PRO-seq)." Nat Protoc 11(8): 1455-1476.

Malabat, C., F. Feuerbach, L. Ma, C. Saveanu and A. Jacquier (2015). "Quality control of transcription start site selection by nonsense-mediated-mRNA decay." Elife 4.

Murata, M., H. Nishiyori-Sueki, M. Kojima-Ishiyama, P. Carninci, Y. Hayashizaki and M. Itoh (2014). "Detecting expressed genes using CAGE." Methods Mol Biol 1164: 67-85.

Pelechano, V., W. Wei and L. M. Steinmetz (2013). "Extensive transcriptional heterogeneity revealed by isoform profiling." Nature 497(7447): 127-131.

Takahashi, H., T. Lassmann, M. Murata and P. Carninci (2012). "5' end-centered expression profiling using cap-analysis gene expression and next-generation sequencing." Nat Protoc 7(3): 542-561.

