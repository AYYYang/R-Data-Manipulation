# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("ChIPpeakAnno")

# Reference: https://www.bioconductor.org/packages/devel/bioc/vignettes/ChIPpeakAnno/inst/doc/ChIPpeakAnno.html#an-example-of-chip-seq-analysis-workflow-using-chippeakanno

library(data.table)
library(ChIPpeakAnno)
library(org.Mm.eg.db)
library(dplyr)
setwd("~/Desktop/Kuchenbauer2020/peaks")
dir = "~/Desktop/Kuchenbauer2020/peaks"
data(TSS.mouse.GRCm38)


file155 <- listName(dir,"155")
annotate(file155, "peak155")
for (i in 1:6) {
  peakN <- names(peakName[i])
  nam <- paste("p_155_", substr(peakN, 9, nchar(peakN)))
  assign(nam, as.data.frame(peakName[i]))
  write.csv(as.data.frame(peakName[i]), file = paste(nam, ".csv", sep = ""))
}

fileCTRL <- listName(dir, "ctrl")
annotate(fileCTRL, "peakCTRL")
for (i in 1:6) {
  peakN <- names(peakName[i])
  nam <- paste("p_CTRL_", substr(peakN, 10, nchar(peakN)))
  assign(nam, as.data.frame(peakName[i]))
  write.csv(as.data.frame(peakName[i]), file = paste(nam, ".csv", sep = ""))
}

file708 <- listName(dir,"708")
annotate(file708,"peak708")
for (i in 1:6) {
  peakN <- names(peakName[i])
  nam <- paste("p_708_", substr(peakN, 9, nchar(peakN)))
  assign(nam, as.data.frame(peakName[i]))
  write.csv(as.data.frame(peakName[i]), file = paste(nam, ".csv", sep = ""))
}

fileMeis <- listName(dir, "Meis")
annotate(fileMeis,"peakMeis")

for (i in 1:6) {
  peakN <- names(peakName[i])
  nam <- paste("p_Meis_", substr(peakN, 10, nchar(peakN)))
  assign(nam, as.data.frame(peakName[i]))
  write.csv(as.data.frame(peakName[i]), file = paste(nam, ".csv", sep = ""))
}

filedHD <- listName(dir, "dHD")
annotate(filedHD, "peakdHD")
for (i in 1:6) {
  peakN <- names(peakName[i])
  nam <- paste("p_dHD_", substr(peakN, 9, nchar(peakN)))
  assign(nam, as.data.frame(peakName[i]))
  write.csv(as.data.frame(peakName[i]), file = paste(nam, ".csv", sep = ""))
}

fileVP16 <- listName(dir, "VP16")
annotate(fileVP16,"peakVP16")
for (i in 1:6) {
  peakN <- names(peakName[i])
  nam <- paste("p_VP16_", substr(peakN, 10, nchar(peakN)))
  assign(nam, as.data.frame(peakName[i]))
  write.csv(as.data.frame(peakName[i]), file = paste(nam, ".csv", sep = ""))
}
# rm(list = ls(pattern = "file"), dir, i, nam, TSS.mouse.GRCm38)


