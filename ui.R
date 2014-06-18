
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(rCharts)
source("common.R")

index_indicators <- get_all_index_headers()
index_indicators <- index_indicators[3:length(index_indicators)]

shinyUI(fluidPage(

    # Application title
    titlePanel("Index of Economic Freedom Analytics - A Brazilian View"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("countries",
                        "Compare Brazil to:",
                        choices=get_countries(),
                        multiple=T),
            selectInput("indicators",
                        "Using this indicators",
                        choices=index_indicators,
                        multiple=F)
            ),
               
        
        # Show a plot of the generated distribution
        mainPanel(
            helpText("This sites aims to analyse deeper aspects and correlations between data",
                     "gathered by The Heritage Foundation (http://www.heritage.org/)."),
        helpText("All data can be found at http://www.heritage.org/index/explore."),
        helpText("The site was consulted in 2014-06-17, and two datasets were downloaded: ",
                 "2014 macroeconomic data and all index data between 1995 and 2014."),
        
        h1("Comparision"),
        
        showOutput("evolution", "morris")
    )
  )
))
