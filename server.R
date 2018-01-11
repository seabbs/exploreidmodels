#Load packages
source("load_packages.R")

## Stop spurious warnings
options(warn = -1)

shinyServer(function(input, output) {
  
  ## Declare fixed parameters
  N <- 1000
  I <- 1
  
  model_sim <- reactive({
  ##across all models
  times <- seq(0, input$maxtime, 0.1)
  
  ## Choose model and set up
    if (input$model %in% "SI_ode") {
      ## Model
      model <- SI_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta)
      
      ##initial pop
      inits <- data.frame(S = N - I, I = I)
    }else if (input$model %in% "SI_demo_ode") {
      ## Model
      model <- SI_demo_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, mu = 1/input$mu)
      
      ##initial pop
      inits <- data.frame(S = N - I, I = I)
    }else if (input$model %in% "SEI_ode") {
      ## Model
      model <- SEI_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, gamma = 12/input$gamma)
      
      ##initial pop
      inits <- data.frame(S = N - I, E = 0, I = I)
    }else if (input$model %in% "SEI_demo_ode") {
      ## Model
      model <- SEI_demo_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, gamma = 12/input$gamma, mu = 1/input$mu)
      
      ##initial pop
      inits <- data.frame(S = N - I, E = 0, I = I)
    }
    
  ## Run model
    model_sim <- simulate_model(model = model, 
                                sim_fn = sim_fn, 
                                inits = inits, 
                                params = params,
                                times = times,
                                as_tibble = TRUE)
  })
  
  ## Plot model
  output$plot_model_traj <- renderPlotly({
    model_sim() %>% 
      biddmodellingcourse::plot_model(facet = input$facet_model, interactive = TRUE)
  })
  
  ## Raw model table
  output$model_sim_results <- DT::renderDataTable({
    model_sim()
  })
  
  ## Model summary table
  output$model_sum_tab <- renderTable({
    model_sim() %>% 
      biddmodellingcourse::summarise_model() %>%
      rename_at(.vars = colnames(.)[!grepl("epi_", colnames(.))], .funs = funs(paste0("Final size: ", .))) %>% 
      rename(`Epidemic peak time` = epi_peak_time,
             `Epidemic peak` = epi_peak_size,
             `Epidemic duration` = epi_dur)
  })
  
  output$downloadData2 <- downloadHandler(filename = "ui.R",
                                          content = function(file) {
                                            file.copy("ui.R", file, overwrite = TRUE)
                                            }
                                          )
  output$downloadData3 <- downloadHandler(filename = "server.R",
                                          content = function(file) {
                                            file.copy("server.R", file, overwrite = TRUE)
                                            }
                                          )
  
})
