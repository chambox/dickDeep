output$dataQualityCheckDisplay <- renderUI({
  fluidRow(
    br(),
    column(width = 12,
           align = "center"),
    br(),
    column(
      width = 12,
      align = "center",
      setShadow("box"),
      boxPlus(
        title = "Create event log object",
        collapsible = TRUE,
        closable = FALSE,
        solidHeader = TRUE,
        status = "primary",
        width = 12,
        box(width = 4,
            uiOutput("case_id")),
        box(width = 4,
            uiOutput("timestamp")),
        box(width = 4,
            uiOutput("activity_id")),
        box(width = 4,
            uiOutput("activity_instance_id")),
        box(width = 4,
            uiOutput("lifecycle_id")),
        box(width = 4,
            uiOutput("resource_id"))
      ),
      boxPlus(
        title = "Summary results",
        collapsible = TRUE,
        closable = FALSE,
        solidHeader = TRUE,
        status = "primary",
        width = 12,
        box(width = 12,
            DT::dataTableOutput("summary_results")),
        box(width = 6,
            plotlyOutput("activities_summary")),
        box(width = 6,
            plotlyOutput("resources_summary"))
      )
    )
  )
})
