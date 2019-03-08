output$dataDisplay<-renderUI({
  if(is.null(input$file1)){
    text<-"No dataset has been uploaded!"
    ckBx<-checkboxInput("useDefualt", "Use built in event logs?", FALSE)
  }
  else{
    text<-""
    ckBx<-NULL
  }
  fluidRow(
    br(),
    column(
      width = 12,
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
      )))
})


output$contents <- DT::renderDataTable({
  # input$file1 will be NULL initially. After the user selects
  # and uploads a file, head of that data file by default,
  # or all rows if selected, will be shown.
  req(input$file1)
  # when reading semicolon separated files,
  # having a comma separator causes `read.csv` to error
  tryCatch(
    {
      df <- read.csv(input$file1$datapath,
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote)
    },
    error = function(e){
      # return a safeError if a parsing error occurs
      stop(safeError(e))
    }
  )
  if(input$disp == "head") {
    return(DT::datatable(head(df)))
  }
  if(input$disp == "tail") {
    return(DT::datatable(tail(df)))
  }
  if(input$disp == "all") {
    return(DT::datatable(df))
  }
  
})
