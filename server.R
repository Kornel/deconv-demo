library(shiny)
library(reshape2)
library(ggplot2)
library(dplyr)
library(pheatmap)

shinyServer(function(input, output) {

  generateHeatmap <- function() {
    path <- file.path('resources', input$method, 'heatmap', paste0(input$tumor, '.RData'))
    df <- local(get(load(path)))
    
    if (input$top != 'All') {
      n <- as.numeric(input$top)
      df <- df[, seq(1:n)]
    }
  
    pheatmap(df, fontsize = 5)
  }
  
  generatePlot <- function() {
    path <- file.path('resources', input$method, paste0(input$tumor, '.RData'))
    
    df <- local(get(load(path)))
    
    if (input$top != 'All') {
      n <- as.numeric(input$top)
      top.tissues <- as.character(levels(df$tissue.ordered)[1:n])
      df <- df %>% filter(tissue.ordered %in% top.tissues)
    }
    
    if (input$plot.type == 'Violin') {
      geom_type <- geom_violin
    } else {
      geom_type <- geom_boxplot
    }
    
    if (input$coloured == T) {
      geom <- geom_type(aes(x = tissue.ordered, y = value, fill = tissue.ordered))
      x.label <- theme(axis.text.x = element_blank())
    } else {
      geom <- geom_type(aes(x = tissue.ordered, y = value))
      x.label <- theme(axis.text.x = element_text(angle = 90, hjust = 1))
    }
    
    ggplot(df) + 
      geom +
      theme_bw() +
      x.label + 
      scale_fill_brewer(palette = 'Spectral', name = 'Tissue type') +
      xlab('Tissue type') + 
      ylab('Contribution')
  }
  
  output$distPlot <- renderPlot({ generatePlot() })
  
  output$heatmap <- renderPlot({ generateHeatmap() })
  
  output$download = downloadHandler(
    filename = function() { 
      sprintf('%s-%s.pdf', input$tumor, input$method)
    },
    content = function(file) {
      device <- function(..., width, height) {
        grDevices::pdf(..., width, height)
      }
      
      path <- file.path('resources', input$method, 'heatmap', paste0(input$tumor, '.RData'))
      df <- local(get(load(path)))
      
      if (input$top != 'All') {
        n <- as.numeric(input$top)
        df <- df[, seq(1:n)]
      }
      
      ggsave(file, plot = generatePlot(), device = device)
    })

})
