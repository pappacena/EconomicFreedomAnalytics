
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

group_indicators <- grep("Change\\.In\\.", get_index_2014_headers(), invert=T, value=T)
group_indicators <- group_indicators[5:length(group_indicators)]

shinyUI(fluidPage(

    # Application title
    titlePanel("Index of Economic Freedom Analytics - A Brazilian View"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Compare evolution"),
            helpText("You can compare Brazilian evolutio to other countries in each",
                     "of these aspects"),
            selectInput("countries",
                        "Compare Brazil to:",
                        choices=get_countries(),
                        multiple=T),
            selectInput("indicators",
                        "Using this indicators",
                        choices=index_indicators,
                        multiple=F),
            
            h3("2014 country wealth (GDP per capta)"),
            helpText("Here, you can compare every country weath to it's other indicators"),
            selectInput("group_indicator",
                        "Using this indicator",
                        choices=group_indicators,
                        multiple=F),
            numericInput('groups', 'Groups', 5,
                         min = 1, max = 9)
            ),
               
        
        # Show a plot of the generated distribution
        mainPanel(
            helpText("This sites aims to analyse deeper aspects and correlations between data",
                     "gathered by The Heritage Foundation (http://www.heritage.org/)."),
        helpText("All data can be found at http://www.heritage.org/index/explore."),
        helpText("The site was consulted in 2014-06-17, and two datasets were downloaded: ",
                 "2014 macroeconomic data and all index data between 1995 and 2014."),
        
        h1("Comparison"),
        
        showOutput("evolution", "morris"),
        
        hr(),
        
        h1("GDP Per capta - groups"),
        tableOutput('countries_position'),
        showOutput("groups_chart", "highcharts"),
        h1("GDP Per capta - countries"),
        showOutput("countries_chart", "highcharts")
    )
  )
))
