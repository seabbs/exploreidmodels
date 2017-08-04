#Load packages
library(shiny)
library(shinydashboard)
library(shinyBS)
library(tidyverse)
library(plotly)
library(idmodelr)
library(DT)
## Stop spurious warnings
options(warn = -1)

shinyServer(function(input, output) {
  
  ## Reactive slider for number of infected
  output$init_infected <- renderUI({
    sliderInput(inputId = "I_0", 
                label = "Initially Infected:",
                min = 0,
                max = input$N,
                value = 1)
  })
  
  model_sim <- reactive({
  ##across all models
  times <- seq(0, input$maxtime, 0.1)
  
    if (input$model %in% "SI_ode") {
      ## Model
      model <- SI_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta)
      
      ##initial pop
      inits <- data.frame(S = input$N - input$I_0, I = input$I_0)
    }else if (input$model %in% "SI_demo_ode") {
      ## Model
      model <- SI_demo_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, mu = 1/input$mu)
      
      ##initial pop
      inits <- data.frame(S = input$N - input$I_0, I = input$I_0)
    }else if (input$model %in% "SEI_ode") {
      ## Model
      model <- SEI_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, gamma = 1/input$gamma)
      
      ##initial pop
      inits <- data.frame(S = input$N - input$I_0, E = 0, I = input$I_0)
    }else if (input$model %in% "SEI_demo_ode") {
      ## Model
      model <- SEI_demo_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, gamma = 1/input$gamma, mu = 1/input$mu)
      
      ##initial pop
      inits <- data.frame(S = input$N - input$I_0, E = 0, I = input$I_0)
    }
    
    model_sim <- simulate_model(model = model, 
                                sim_fn = sim_fn, 
                                inits = inits, 
                                params = params,
                                times = times,
                                as_tibble = TRUE)
  })
  
  output$plot_model_traj <- renderPlot({
    model_sim() %>% 
      plot_model
  })
  
  output$model_sim_results <- DT::renderDataTable({
    model_sim()
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
