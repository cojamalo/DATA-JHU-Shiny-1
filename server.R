#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(ggplot2)
library(colorspace)
library(plyr)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    output$docs = renderText({
        "<h3>Documentation</h3>
        <p>Welcome to the Oil Fatty Acid Composition Viewer and Mixing Simulator!</p>
        <h4>Overview</h4>
        <p>This app uses the fatty acid concentration data supplied with the caret pacakge and allows the user to compare the fatty acid concentrations of six different oil types from the data's measurements.</p>
        <h4>Usage</h4>
        The app will generate different plots using ggplot2 dependent on what selection the user makes from the 'Compare Type', 'Plot Type', 'Oil Types', and 'Order Fatty Acids by Concentration of' inputs.
        <h5><i>Compare Type</i></h5>
        <p>Options: Separated, Mixed</p>
        <p>If the user selects 'Separated' and multiple oil types are selected, the plots will use facetting to compare the fatty acid concentrations. This setting allows the user to see the differences and similarities in the concentration of fatty acids for each selected oil type. If the user selects 'Mixed', the resulting plots will represent the concentration of a hypothetical 1:1 mix between the oils selected.</p>
        <h5><i>Plot Type</i></h5>
        <p>Options: Density Plot, Box Plot</p>
        <p>There are two plot types available to explore the distributuions of fatty acid concentrations in the selected oils. The density plot portrays a compositional 'fingerprint' of the oil by showing the probabiility density of the concentrations of each fatty acid type. The box plot shows the distribution of fatty acid concentrations in the oil using the familiar box-and-whisker format</p>
        <h5><i>Oil Types</i></h5>
        <p>Options: pumpkin, sunflower, peanut, olive, soybean, rapeseed</p>
        <p>This option allows the user to select which oils to include in the plot. </p>
        <h5><i>Order Fatty Acids by Concentration in</i></h5>
        <p>Options: (which options are available is dependent on which oil types are selected)</p>
        <p>This option only appears if the 'Box Plot' is selected for the 'Plot Type' input. The selected oil for this setting will determine how the fatty acids concentrations are ordered on the x-axis in the plot and will not change the values of the concentrations. For instance, if olive oil is selected, then the fatty acids in the plot will be arranged by the fatty acid with the lowest concentration to the fatty acid with the highest concentration assuming a typical distribution for olive oil. </p>
        "
        
        
        })
    observe({
        output$variables = renderText({
            paste("compareType:",input$compareType,"plotType:",input$plotType,"oilSelect:", input$oilSelect, "orderBy",input$orderBy)
            })
        data(oil)
        oil_y = revalue(oilType, c("A" = "pumpkin", "B" = "sunflower", "C" = "peanut", "D" = "olive", "E" = "soybean", "F" = "rapeseed", "G" = "corn"))
    if(input$compareType == "Separated") {
        if (length(input$oilSelect) == 0) {
            output$plotError = renderText({"<h1 style='color:red'>Please select an oil type to view a plot!</h1>"})
        }
        else {output$plotError = renderText({""})}
        output$distPlot <- renderPlot({
            oil_x = fattyAcids %>% mutate(source = oil_y) %>% filter(source %in% input$oilSelect) %>% mutate_if(is.numeric, function(x) x/100)
            updateSelectInput(session, "orderBy", choices = input$oilSelect, selected = input$orderBy)
            ordering = oil_x %>% filter(source == input$orderBy) %>% select(-source) %>% apply(2, median)
            data = oil_x %>% gather(key = oil_type, value = value, Palmitic, Stearic, Oleic, 
                                    Linoleic, Linolenic, Eicosanoic, Eicosenoic) %>%
                            mutate(original = oil_type)
            data$oil_type <- factor(data$oil_type, levels = c("Palmitic", "Stearic", "Oleic", "Linoleic", "Linolenic", "Eicosanoic", "Eicosenoic")[order(ordering)])
            
            #%>% mutate_if(is.character, factor) %>% group_by(source, oil_type)
            
            
            ## Final output type
            if (input$plotType == "Density Plot") {
                ggplot(data = data, aes(x = value, fill = factor(original))) + 
                    geom_density(adjust=2) + 
                    scale_x_continuous(breaks = c(seq(0,1, by=0.05)), labels = scales::percent) +
                    facet_grid(source~.) +
                    ylim(c(0,100)) +
                    theme(plot.title = element_text(hjust = 0.5)) +
                    labs(title = "Density Plot of Percent Concentration Measurements", y = "P(Percent Concentration)", x = "Percent Concentration")
            }
            else if (input$plotType == "Box Plot") {
                ggplot(data = data, aes(x = oil_type,y = value, fill = factor(original))) + 
                    geom_boxplot() +
                    scale_y_continuous(breaks = seq(0, 1, by = .05), labels = scales::percent) +
                    facet_grid(.~source) +
                    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 60, hjust = 1)) +
                    labs(title = "Box Plot of Percent Concentration Measurements", y = "Percent Concentration", x = "Fatty Acid")
            }
            
            
            
        })
        
    }
    else { # For Mixed Option
        if (length(input$oilSelect) == 0) {
            output$plotError = renderText({"<h1 style='color:red'>Please select an oil type to view a plot!</h1>"})
        }
        else {output$plotError = renderText({""})}
        output$distPlot <- renderPlot({
            
            oil_x = fattyAcids %>% mutate(source = oil_y) %>% filter(source %in% input$oilSelect) %>% mutate_if(is.numeric,function(x) x/100)
            updateSelectInput(session, "orderBy", choices = input$oilSelect, selected = input$orderBy)
            ordering = oil_x %>% filter(source == input$orderBy) %>% select(-source)%>% apply(2, median)
            data = oil_x %>% gather(key = oil_type, value = value, Palmitic, Stearic, Oleic, 
                                    Linoleic, Linolenic, Eicosanoic, Eicosenoic) %>%
                mutate(original = oil_type)
            data$oil_type <- factor(data$oil_type, levels = c("Palmitic", "Stearic", "Oleic", "Linoleic", "Linolenic", "Eicosanoic", "Eicosenoic")[order(ordering)])
            
            ## Final output type
            if (input$plotType == "Density Plot") {
                
                ggplot(data = data, aes(x = value, fill = factor(original))) + 
                    geom_density(adjust=2) + scale_x_continuous(breaks = c(seq(0,1, by=0.05)), labels = scales::percent) + 
                    ylim(c(0,100)) +
                    theme(plot.title = element_text(hjust = 0.5)) +
                    labs(title = "Density Plot of Percent Concentration Measurements", y = "P(Percent Concentration)", x = "Percent Concentration")
            }
            else if (input$plotType == "Box Plot") {
                ggplot(data = data, aes(x = oil_type,y = value, fill = factor(original))) + 
                    geom_boxplot() +
                    scale_y_continuous(breaks = seq(0, 1, by = .05), labels = scales::percent) +
                    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 60, hjust = 1)) +
                    labs(title = "Box Plot of Percent Concentration Measurements", y = "Percent Concentration", x = "Fatty Acid")
            }
        
        
    
    })
        }
    
    })
})
