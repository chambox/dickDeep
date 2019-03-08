getExtension <- function(file) {
  ex <- strsplit(basename(file), split = "\\.")[[1]]
  return(ex[-1])
}
computeKernel <- reactive({
  checked <- input$useDefualtData
  df <- NULL
  df1 <- NULL
  # input$file1 will be NULL initially. After the user selects
  # and uploads a file, head of that data file by default,
  # or all rows if selected, will be shown.
  if (!is.null(input$file1)) {
    checked <- FALSE
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    if (getExtension(input$file1$datapath) == "csv") {
      tryCatch({
        df <- read_delim(input$file1$datapath,
                         delim = input$sep,
                         quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      })
    }
    else if (getExtension(input$file1$datapath) == "xes")
      tryCatch({
        df1 <- read_xes(input$file1$datapath)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      })
    
    if (input$disp == "head") {
      df <- head(df1)
    }
    if (input$disp == "tail") {
      df <- tail(df1)
    }
    if (input$disp == "all") {
      df <- df1
    }
    
  }
  else if (input$useDefualtData) {
    df1 <-
      read_delim(
        "sampleData/running-example-non-conforming.csv",
        delim = input$sep,
        quote = input$quote
      ) %>%
      dplyr::mutate(timestamp = as.POSIXct(`dd-MM-yyyy:HH.mm`)) %>%
      dplyr::select(-`dd-MM-yyyy:HH.mm`)
    
    if (input$disp == "head") {
      df <- head(df1)
    }
    if (input$disp == "tail") {
      df <- tail(df1)
    }
    if (input$disp == "all") {
      df <- df1
    }
    
  }
  list(checked = checked,
       df = df,
       df1 = df1)
})

output$contents <- DT::renderDataTable({
  if (!is.null(computeKernel()$df))
    DT::datatable(computeKernel()$df)
})
