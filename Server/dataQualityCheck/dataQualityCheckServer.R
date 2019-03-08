# filters data
  
output$case_id <- renderUI({
  if (computeKernel()$checked)
    selected = "Case ID"
  else
    selected = "None"
  dataNames <- as.list(c("None", names(computeKernel()$df1)))
  selectInput("case_id",
              "Select case identifier",
              choices = dataNames,
              selected = selected)
})

output$activity_id <- renderUI({
  if (computeKernel()$checked)
    selected = "Activity"
  else
    selected = "None"
  dataNames <- as.list(c("None", names(computeKernel()$df1)))
  selectInput("activity_id",
              "Select activity label",
              choices = dataNames,
              selected = selected)
})

output$activity_instance_id <- renderUI({
  dataNames <- as.list(c("None", names(computeKernel()$df1)))
  selectInput(
    "activity_instance_id",
    "Select activity instance",
    choices = dataNames,
    selected = "None"
  )
})



output$lifecycle_id <- renderUI({
  dataNames <- as.list(c("None", names(computeKernel()$df1)))
  selectInput("lifecycle_id",
              "Select status",
              choices = dataNames,
              selected = "None")
})


output$timestamp <- renderUI({
  if (computeKernel()$checked)
    selected = "timestamp"
  else
    selected = "None"
  dataNames <- as.list(c("None", names(computeKernel()$df1)))
  selectInput("timestamp",
              "Select timestamp",
              choices = dataNames,
              selected = selected)
})

output$resource_id <- renderUI({
  if (computeKernel()$checked)
    selected = "Resource"
  else
    selected = "None"
  dataNames <- as.list(c("None", names(computeKernel()$df1)))
  selectInput("resource_id",
              "Select resource",
              choices = dataNames,
              selected = selected)
})


### Creation of the event log object
create_event_log_reactive <- reactive({
  if(!is.null(input$lifecycle_id)){
    #Note that we only check if one of the inputs in NULL
    #since all these inputs get initialize at the same time.
    validate(need(input$case_id != "None", "Case id must be provided"))
    validate(need(
      input$activity_id != "None",
      "Activity label must be provided"
    ))
    validate(
      need(
        input$timestamp != "None",
        "Timestamp must be provided. However,
        if all events within a case are order select
        'ordered' from drop down"
      )
      )
    n_count <- dim(computeKernel()$df1)[1]
    if (input$lifecycle_id == "None")
      status <- c(1:n_count)
    else
      status <- unlist(computeKernel()$df1[, input$lifecycle_id])
    
    if (input$activity_instance_id == "None")
      activity_instance_id <- c(1:n_count)
    else
      activity_instance_id <-
      unlist(computeKernel()$df1[, input$activity_instance_id])
    
    if (input$resource_id == "None")
      resource_id <- c(1:n_count)
    else
      resource_id <- unlist(computeKernel()$df1[, input$resource_id])
    
    ds_<-data.frame(
      case_id = computeKernel()$df1[, input$case_id],
      timestamp = computeKernel()$df1[, input$timestamp],
      activity_id = computeKernel()$df1[, input$activity_id],
      status = status,
      activity_instance_id = activity_instance_id,
      resource_id = resource_id
    )
    
    names(ds_)<-c(input$case_id,
                  input$timestamp,
                  input$activity_id,
                  "activity_instance_id",
                  "status", "resource_id")
    ds_%>%
      eventlog(
        case_id = input$case_id,
        activity_id = input$activity_id,
        timestamp = input$timestamp,
        activity_instance_id = "activity_instance_id",
        lifecycle_id = "status",
        resource_id = "resource_id"
      ) -> ds_
    
    summary_map <- c(
      n_activities <- n_activities(ds_),
      n_activity_instances <- n_activity_instances(ds_),
      n_cases <- n_cases(ds_),
      n_events <- n_events(ds_),
      n_resources <- n_resources(ds_),
      n_traces <- n_traces(ds_)
    )
    
    names_of_map <- c(
      "Activities",
      "Number of activity instances",
      "Cases",
      "Events",
      "Resources",
      "Traces"
    )
    summary_res <- data.frame(summary_map, row.names = names_of_map)
    names(summary_res) <- "Counts"
    
    activities <- data.frame(activities(ds_)) %>%
      mutate(relative_frequency = round(relative_frequency, 2))
    names(activities) <-
      c("Activity", "Absolute Freq", "Relative Freq")
    
    resources  = data.frame(resources(ds_)) %>%
      mutate(relative_frequency = round(relative_frequency, 2))
    names(resources) <-
      c("Resource", "Absolute Freq", "Relative Freq")
    
    
    
    list(
      activities = activities,
      resources  = resources ,
      summary_res = summary_res
    )
    
  }
  })

output$activities_summary <- renderPlotly({
  if(!is.null(input$lifecycle_id))
  {
    plot_donut <- create_event_log_reactive()$activities %>%
      group_by(Activity) %>%
      plot_ly(labels = ~Activity, values = ~`Absolute Freq`) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "Donut charts of activities",  showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             showlegend = TRUE)
    plot_donut 

  }
})

output$resources_summary <- renderPlotly({
  if(!is.null(input$lifecycle_id))
  {
    plot_donut <- create_event_log_reactive()$resources%>%
      group_by(Resource) %>%
      plot_ly(labels = ~Resource, values = ~`Absolute Freq`) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "Donut charts of resources",  showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             showlegend = TRUE)
    plot_donut 
  }
})

output$summary_results <- DT::renderDataTable({
  if(!is.null(input$lifecycle_id))
  DT::datatable(create_event_log_reactive()$summary_res)
})
