# compare signalValue of experimental peaks to control peaks

# 1. find matching seqname, feature, insideFeature
# 2. use matching peaks in experimental to subtract control
# 3. if only present in experimental but not in control, then keep the peak
# final output should have 4 columns seqname, feature, insideFeature, sigValChange

# install.packages("sqldf")
library(sqldf)
library(data.table)
library(dplyr)
setwd("~/Desktop/Kuchenbauer2020/peaks/XLS")

# make 6 lists of different histone marks 
H3K27ac = getHisTable("H3K27ac")
H3K27me = getHisTable("H3K27me")
H3K36me = getHisTable("H3K36me")
H3K4me1 = getHisTable("H3K4me1")
H3K4me3 = getHisTable("H3K4me3")
H3K9me3 = getHisTable("H3K9me3")

setwd("~/Desktop")
CTRL = getHisTable("CTRL")
# pop all elements in CTRL as individual object
for (i in 1:length(CTRL)) {
  nam <- tablenames[[i]]
  assign(nam, CTRL[[i]])
}

# getSigDiff returns attributes of unique experimental peaks and overlapping peaks of exp and ctrl where the start and end difference are within 200 bps
# input: ctrl as the control peaks; exps as a list of experimental peaks
# output: matrix of ten attributes

# get result ----------
# getSigValDiff, exps is a list of peaks, ctrl is a peak file, names is a string
getSigValDiff(H3K27ac, peakCTRL_H3K27ac, "H3K27ac")
getSigValDiff(H3K27me,peakCTRL_H3K27me,"H3K27me")
getSigValDiff(H3K36me,peakCTRL_H3K36me,"H3K36me")
getSigValDiff(H3K4me1,peakCTRL_H3K4me1,"H3K4me1")
getSigValDiff(H3K4me3,peakCTRL_H3K4me3,"H3K4me3")
getSigValDiff(H3K9me3,peakCTRL_H3K9me3,"H3K9me3")


