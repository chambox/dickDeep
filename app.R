library(shiny)
library(shinyjqui)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyAce)
library(styler)
library(shinyWidgets)
library(xesreadR)
library(tidyverse)
library(bupaR)
library(plotly)

source("utils.R")

shinyApp(
  ui = dashboardPagePlus(
    dashboardHeaderPlus(
      fixed = TRUE,
      title = "PmVis",
      enable_rightsidebar = FALSE
    ),
    dashboardSidebar(
      sidebarMenu(
        id = "sidebarArea",
          menuItem(expandedName = "dataInput",
            "Input data",
            icon = icon("database"),
              fileInput(
                "file1",
                "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv",".xes")
              ),
              # Input: Select number of rows to display ----
              radioButtons(
                "disp",
                "Display",
                choices = c(Head = "head",
                            All = "all",
                            Tail = "tail"),
                selected = "all"
              ),
              # Horizontal line ----
   
              # Input: Select separator ----
              radioButtons(
                "sep",
                "Separator",
                choices = c(
                  Comma = ",",
                  Semicolon = ";",
                  Tab = "\t"
                ),
                selected = ";"
              ),
              # Input: Select quotes ----
              radioButtons(
                "quote",
                "Quote",
                choices = c(
                  None = "",
                  "Double Quote" = '"',
                  "Single Quote" = "'"
                ),
                selected = '"'
              )
          ),
        menuItem(
          "Data quality check",
          expandedName = "dataQualityCheck",
          icon = icon("folder-open"),
          menuSubItem("Other Checks")
        ),
        menuItem(
          "View process",
          tabName = "viewProcess",
          icon = icon("folder-open")
        ),
        menuItem(
          "Animate process",
          tabName = "boxes",
          icon = icon("briefcase")
        ),
        menuItem(
          "Advance analytics",
          tabName = "buttons",
          icon = icon("cubes")
        ),
        menuItem("New Box elements",
                 tabName = "boxelements",
                 icon = icon("th")),
        menuItem(
          "Extra CSS effects",
          tabName = "extracss",
          icon = icon("magic")
        ),
        menuItem(
          "New extra elements",
          tabName = "extraelements",
          icon = icon("plus-circle")
        )
      )
    ),
    dashboardBody(uiOutput("body")),
    title = "shinyDashboardPlus"
  ),
  server = function(input, output) {
    #InputData
    source(file.path("Server/inputData", "inputDataServer.R"), local = TRUE)$value
    source(file.path("Server/inputData", "inputDataBody.R"), local = TRUE)$value
    source(file.path("Server/inputData", "inputDataHeader.R"), local = TRUE)$value
    
    #DataQualityCheck
    #source(file.path("Server/dataQualityCheck", "uiElements.R"), local = TRUE)$value
    source(file.path("Server/dataQualityCheck", "dataQualityCheckServer.R"), local = TRUE)$value
    source(file.path("Server/dataQualityCheck", "dataQualityCheckBody.R"), local = TRUE)$value
    source(file.path("Server/dataQualityCheck", "dataQualityCheckHeader.R"), local = TRUE)$value
    
    
    source(file.path("Server/", "displayBody.R"), local = TRUE)$value
  }
)