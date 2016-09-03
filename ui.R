library(shiny)

tumor.names <- read.table('resources/tumor-names.csv', header = T, stringsAsFactors = F)

methods <- read.table('resources/methods.csv', header = T, stringsAsFactors = F)

shinyUI(fluidPage(

  titlePanel('TCGA Deconvolution'),

  sidebarLayout(
    sidebarPanel(
      selectInput('tumor', label = 'Tumor', choices = tumor.names),
      selectInput('method', label = 'Deconvolution Method', choices = methods),
      selectInput('top', label = 'Select first', choices = c('All', 3, 5, 8, 13), selected = 5),
      
      hr(),
      
      selectInput('plot.type', label = 'Plot type', choices = c('Violin', 'Boxplot')),
      checkboxInput('coloured', label = 'Coloured', value = T)
    ),

    mainPanel(
      plotOutput('distPlot', height = '600px')
    )
  )
))
