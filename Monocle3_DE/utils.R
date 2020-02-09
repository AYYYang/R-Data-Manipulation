# functions to use to make life easier 
# get libid to differentiate between Day0 and Week 20
getlibid <-function(cds) {
  libid <- cds@colData@rownames
  id <- substr(libid[1:length(libid)],18,18)
  colData(cds)$libid <- id
  return(cds)
}

# pre plot goEnrichment df processing and making
# takes an goEnrichment dataframe, a stats method(KS), returns a processed goEnrichment table
getPlotEnrich <- function(goEnrichment, stats) {
  goEnrichment <- goEnrichment[,c("GO.ID","Term",stats)]
  goEnrichment$Term <- gsub(" [a-z]*\\.\\.\\.$", "", goEnrichment$Term)
  goEnrichment$Term <- gsub("\\.\\.\\.$", "", goEnrichment$Term)
  goEnrichment$Term <- paste(goEnrichment$GO.ID, goEnrichment$Term, sep=", ")
  goEnrichment$Term <- factor(goEnrichment$Term, levels=rev(goEnrichment$Term))
  goEnrichment[,ncol(goEnrichment)] <- as.numeric(goEnrichment[,ncol(goEnrichment)])
  # replace any NA with the smallest numerical value
  goEnrichment[,ncol(goEnrichment)][is.na(goEnrichment[,ncol(goEnrichment)])] <- 1e-22
  return(goEnrichment)
}


# getTimeDiffGene(cds), returns a df of sig_coef with regression fit on libid
getTimeDiffGene <- function(cds) {
  gene_fits <- fit_models(cds, model_formula_str = "~libid", cores = 4, verbose = TRUE) 
  gene_fits <- coefficient_table(gene_fits)
  time_terms <- gene_fits %>% filter(term == "libid2")
  sig_coefs <- time_terms %>% filter (q_value < 0.05) %>%
    select(gene_short_name, term, q_value, estimate)
  time_diff_genes <- time_diff_genes <- sig_coefs[order(abs(sig_coefs$estimate), decreasing = TRUE),]
  return(time_diff_genes)
}



# getCellTypeDiffGene(cds), returns a df of sig_coef with regression fit on assigned_cell_type
getCellTypeDiffGene <- function(cds) {
  gene_fits <- fit_models(cds, model_formula_str = "~assigned_cell_type", cores = 4, verbose = TRUE) 
  gene_fits <- coefficient_table(gene_fits)
  time_terms <- gene_fits %>% filter(term == "assigned_cell_type")
  sig_coefs <- time_terms %>% filter (q_value < 0.05) %>%
    select(gene_short_name, term, q_value, estimate)
  time_diff_genes <- time_diff_genes <- sig_coefs[order(abs(sig_coefs$estimate), decreasing = TRUE),]
  return(time_diff_genes)
}


