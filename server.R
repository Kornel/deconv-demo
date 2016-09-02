library(shiny)
library(reshape2)
library(ggplot2)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    
    path <- file.path('resources', input$method, paste0(input$tumor, '.rnaseq.RData'))
    
    df <- local(get(load(path)))
    
    df <- t(df)
    
    df <- melt(df, varnames = c('barcode', 'tissue'))
    
    tissue.order <- tapply(df$value, df$tissue, function(x) -median(x))
    unique.names <- unique(names(tissue.order[order(tissue.order)]))
    
    df$tissue.ordered <- factor(df$tissue, levels = unique.names, ordered = T)
    
    ggplot(df) + 
      geom_boxplot(aes(x = tissue.ordered, y = value)) + 
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
})
