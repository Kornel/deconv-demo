library(reshape2)

for (f in list.files('resources/lsfit//')) {
  if (length(grep('.RData', f) == 0)) {
    tumor <- sub('.RData', '', f)
    print(tumor)
    load(paste0('resources/lsfit/', f))
    df <- dcast(df, barcode ~ tissue.ordered, value.var = 'value')
    rownames(df) <- df$barcode
    df$barcode <- NULL
    
    save(df, file = paste0('resources/lsfit/heatmap/', f))
  }
}


for (f in list.files('resources/decon//')) {
  if (length(grep('.RData', f) == 0)) {
    tumor <- sub('.RData', '', f)
    print(tumor)
    load(paste0('resources/decon/', f))
    res <- dcast(res, barcode ~ tissue.ordered, value.var = 'value')
    rownames(df) <- df$barcode
    df$barcode <- NULL
    
    save(df, file = paste0('resources/decon/heatmap/', f))
  }
}