
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(rCharts)
source("common.R")

shinyServer(function(input, output) {
    index2014 <- get_index_2014_data()

    output$evolution <- renderChart({
        names(iris) = gsub("\\.", "", names(iris))
        data <- get_all_index_series(c("Brazil", input$countries), input$indicators)
        data$Index.Year <- as.character(data$Index.Year)
        
        print(data)
        p <- mPlot(x="Index.Year", y=input$indicators, group="Name", data=data, type="Line")
        
        p$set(dom="evolution")
        p$set(pointSize = 1, lineWidth = 1)
        print(p)
        return(p)
    })

})
