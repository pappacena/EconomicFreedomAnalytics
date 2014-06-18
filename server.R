
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(rCharts)
require(reshape2)
source("common.R")

shinyServer(function(input, output, session) {
    
    # Grouping
    groupData <- reactive({
        index2014 <- get_index_2014_data()
        index2014 <- index2014[c("Country.Name", "GDP.Per.Capta", input$group_indicator)]
        index2014$GDP.Per.Capta <- as.numeric(gsub("[\\$|\\.]", "", 
                                                   index2014$GDP.Per.Capta))
        index2014[, input$group_indicator] <- gsub("[\\$|\\.]", "", 
                                                 index2014[, input$group_indicator])

        index2014[, input$group_indicator] <- as.numeric(gsub("\\,", ".", 
                                                              index2014[, input$group_indicator]))

        index2014$GDP.Per.Capta <- as.numeric(index2014$GDP.Per.Capta)
        index2014[, input$group_indicator] <- as.numeric(index2014[, input$group_indicator])
        print(str(index2014))
        index2014[complete.cases(index2014), ]
    })
    
    clusters <- reactive({
        kmeans(groupData()[c("GDP.Per.Capta", input$group_indicator)], input$groups)
    })
    
    clustered_data <- reactive({
        data <- groupData()
        k <- clusters()
        data$cluster <- k$cluster
        data
    })
    
    output$groups_chart <- renderChart({
        data <- clustered_data()

        p <- hPlot(x="GDP.Per.Capta", y=input$group_indicator,
                   data=data, group="cluster", type="scatter")

        
        p$set(dom="groups_chart")
        #p$legend(enabled=F)
        #p$plotOptions(scatter = list(marker = list(symbol = 'circle')))
        #p$tooltip(formatter = "#! function() { return this.point; } !#")
        return(p)
    })
    
    output$countries_chart <- renderChart({
        data <- clustered_data()
        
        p <- hPlot(x="GDP.Per.Capta", y=input$group_indicator,
                   data=data, group="Country.Name", type="scatter")
        
        
        p$set(dom="countries_chart")

        p$legend(enabled=F)
        p$plotOptions(scatter = list(marker = list(symbol = 'circle')))
        #p$tooltip(formatter = "#! function() { return this.point; } !#")
        return(p)
    })
    
    output$countries_position <- renderTable({
        data <- clustered_data()
        
        data <- data[data$Country.Name %in% c("Brazil", input$countries), ]
    
        data[, c("Country.Name", "cluster")]
        print(data)
        data
    })

    
    
    #############
    # Evolution #
    #############
    
    output$evolution <- renderChart({
        data <- get_all_index_series(c("Brazil", input$countries), input$indicators)
        data$Index.Year <- as.character(data$Index.Year)
        
        p <- mPlot(x="Index.Year", y=input$indicators, group="Name", data=data, type="Line")
        
        p$set(dom="evolution")
        p$set(pointSize = 1, lineWidth = 1)
        return(p)
    })    

})
