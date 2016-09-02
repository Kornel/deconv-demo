library(shiny)

tumor.names <- read.table('resources/tumor-names.csv', header = T, stringsAsFactors = F)

methods <- read.table('resources/methods.csv', header = T, stringsAsFactors = F)

shinyUI(fluidPage(

  titlePanel('TCGA Deconvolution'),

  sidebarLayout(
    sidebarPanel(
      selectInput('tumor', label = 'Tumor', choices = tumor.names),
      selectInput('method', label = 'Deconvolution Method', choices = methods)
    ),

    mainPanel(
      plotOutput('distPlot', height = '600px')
    )
  )
))
