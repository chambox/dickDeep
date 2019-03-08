
  # if(is.null(input$sidebarMenu)){
    output$body <- renderUI({
      if (is.null(input$sidebarItemExpanded)) {
        uiOutput("dataDisplay")
      } else if (input$sidebarItemExpanded == "dataInput"){
        uiOutput("dataDisplay")
      }
      else if(input$sidebarItemExpanded == "dataQualityCheck"){
            uiOutput("dataQualityCheckDisplay")
          }
     })

    