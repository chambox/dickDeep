output$body <- renderUI({
  if (is.null(input$sidebarItemExpanded)) {
    uiOutput("dataDisplay")
  } else if (input$sidebarItemExpanded == "dataInput") {
    uiOutput("dataDisplay")
  } else if (input$sidebarItemExpanded == "tab2") {
    uiOutput("dataDisplay")
  }
})