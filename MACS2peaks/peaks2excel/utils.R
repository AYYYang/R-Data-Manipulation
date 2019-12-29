library("biomaRt")
ensembl=useMart("ensembl")
datasets <- listDatasets(ensembl)
# use the mouse genome 
ensembl = useDataset("mmusculus_gene_ensembl", mart = ensembl)

# getName of a variable
# takes a variable and returns its reference as a string
getName <- function(v1) {
  deparse(substitute(v1))
}

# list file with pattern name
listName <- function(path,name){
  files <- list.files(path = path, pattern = name)
  return(files)
}

#read all files and annotate for ctrl
# build a list of peaks
annotate <- function(files, peakName) {
  nameL <- ls(pattern = as.character(peakName))
  l <-list()
  for (file in files) {
    nam <- paste(as.character(peakName), substr(file,1,7), sep = "_")
    l[[nam]]<-annotatePeakInBatch(toGRanges(file, format ="narrowPeak"), AnnotationData=TSS.mouse.GRCm38)
  }
  peakName <<-l
  return(peakName)
}

# get Granges object into excel files
for (i in 1:6) {
  nam <- paste("p_CTRL", substr(nameL[i], 10, nchar(nameL[i])))
  assign(nam, as.data.frame(p_CTRL[i]))
  write.csv(as.data.frame(p_CTRL[i]), file = paste(nam, ".csv", sep = ""))
}
rm(list = ls(pattern ="peak_CTRL"))

# get tables
FREAD <- function(x) {
  fread(x,drop = c(1,6,9,10,11,13,14,17,18,19))
}

# Name tables
getTableName <- function(x) {
  gsub(".csv", "", x)
}
# remove old ones
rm(list = ls(pattern = "p_"))

# hisname is a string
getHisTable <- function(hisname){
  l<-list()
  hisname <- list.files(pattern = hisname)
  tablenames <- sapply(hisname, getTableName)
  hisname <- lapply(hisname, FREAD)
  for (i in 1:length(tablenames)) {
    pat <- paste(tablenames[[i]], ".", sep = "")
    print(pat)
    names(hisname[[i]]) <- gsub(pat, "", names(hisname[[i]]))
    l[[i]] = hisname[[i]]
  }
  return(l)
}

# getSigValDiff, exps is a list of peaks, ctrl is a peak file, names is a string
## set constraints of 200 bps for abs(p1.start - p2.start) <= 200  AND abs(p1.end - p2.end) <= 200 

getSigValDiff <- function(exps,ctrl,hisname) {
  # set variables for use
  setwd("/Users/apple/Desktop/Kuchenbauer2020/peaks/XLS/")
  res <- list()
  hisnames <- list.files(pattern=hisname)
  print(hisnames)
  
  # write csv
  for (i in 1:length(hisnames)) {
    p1 = exps[[i]]
    p2 = ctrl
    df1 = sqldf('Select  p1.*,(p1.signalValue - p2.signalValue) as sigValDiff
      From p1, p2
      Where p1.feature = p2.feature AND
      p1.insideFeature = p2.insideFeature AND
      abs(p1.start - p2.start) <= 200 AND
      abs(p1.end - p2.end) <= 200')
    
    df2 = sqldf('Select p1.*, p1.signalValue as sigValDiff
               From p1
               Where p1.feature NOT IN (
               Select p2.feature
               From  p2)')
    
    res[[i]] = rbind(df1,df2)
    res[[i]] = addGeneSymbol(res[[i]])
    filename <- hisnames[[i]]
    setwd("/Users/apple/Desktop/Kuchenbauer2020/peaks/XLS/SigValDiff")
    write.csv(as.data.frame(res[[i]]), file = filename)
  }
  rm(list = ls(pattern = hisname))
}

# add gene symbol according to the Gene ID, in this case, add gene symbols o the matching feature column
addGeneSymbol <- function(df){
  filterType <- "ensembl_gene_id"
  attributeNames <- c('ensembl_gene_id','external_gene_name')
  
  if(is.null(df$feature )) {
    stop("data frame does not have feature column")
  }
  filterValues <- df$feature 
  annot <- getBM(attributes=attributeNames, 
                 filters = filterType, 
                 values = filterValues, 
                 mart = ensembl)
  annotation <- annot[match(filterValues, annot$ensembl_gene_id),]
  if(nrow(df) != nrow(annotation)) {
    stop("data fram row nums is diff from gene name row nums")
  }
  df <- cbind(df, annotation$external_gene_name)
  return(df)
}








