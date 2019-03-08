output$dataDisplay <- renderUI({
  if (is.null(input$useDefualtData))
    checked <- FALSE
  else
    checked = computeKernel()$checked
  
  
  ckBx <-
    checkboxInput("useDefualtData", "Use built in event logs?", checked)
  if (is.null(input$file1)) {
    text <- "No dataset has been uploaded!"
  }
  else{
    text <- ""
  }
  fluidRow(
    br(),
    column(width = 12,
           align = "center"),
    br(),
    column(
      width = 12,
      align = "center",
      setShadow("box"),
        box(
          width = 12,
          p(text),
          ckBx,
          div(style = 'overflow-x: scroll', DT::dataTableOutput("contents"))
          
        )
      )
    )
})
