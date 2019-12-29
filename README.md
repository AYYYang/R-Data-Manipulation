# R-Data-Manipulation
## Overview
This is essentially a record how me teaching myself how to R
I will focus on using R to manipulate and mine **small-scale biological data**, mostly all kinds of sequencing data.

## MACS2
### peaks2excel:
* peakConvert:
  * convert MACS2 peaks output to Granges objects using [ChIPpeakAnno](https://www.bioconductor.org/packages/devel/bioc/vignettes/ChIPpeakAnno/inst/doc/ChIPpeakAnno.html#an-example-of-chip-seq-analysis-workflow-using-chippeakanno) package and annotate the coordinates by giving each start-end an Ensembl gene ID. Then rename and write to csv files.

* finalCompre:
  * subsetting desired columns for comparison. Then use sqldf and dplyr to query and combine peaks with desired attributes.

* utils:
  * functions that I wrote to make the scripts to more clean.

