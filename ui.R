#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Oil Fatty Acid Composition Viewer and Mixing Simulator"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
            selectInput("compareType", "Compare Type:", choices = c("Separated", "Mixed"), selected = "Separated"),
            selectInput("plotType", "Plot Type", choices=c("Density Plot", "Box Plot")),
            checkboxGroupInput("oilSelect", "Oil Types", 
                        choices=c("pumpkin", "sunflower", "peanut","olive","soybean","rapeseed"), selected = "pumpkin"),
            conditionalPanel( condition = "input.plotType == 'Box Plot'", 
                              selectInput("orderBy", "Order Fatty Acids by Concentration in:", choices = "pumpkin", selected = "pumpkin"))
            
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        #textOutput("variables"),
        htmlOutput("plotError"),
       plotOutput("distPlot"),
       htmlOutput("docs")
       
    )
  )
))
