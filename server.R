#Load packages
source("load_packages.R")

## Stop spurious warnings
options(warn = -1)

shinyServer(function(input, output) {
  
  ## Declare fixed parameters
  N <- 1000
  I <- 1
  R <- 0
  
  model_sim <- reactive({
  ##across all models
  times <- seq(0, input$maxtime, 0.1)
  
  ## Choose model and set up
    if (input$model %in% "SI_ode") {
      ## Model
      model <- ifelse(input$demographics, SI_demo_ode, SI_ode)
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta)
      
      ##initial pop
      inits <- data.frame(S = N - I, I = I)
    }else if (input$model %in% "SEI_ode") {
      ## Model
      model <- ifelse(input$demographics, SEI_demo_ode, SEI_ode)
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, gamma = 12/input$gamma)
      
      ##initial pop
      inits <- data.frame(S = N - I, E = 0, I = I)
    }else if (input$model %in% "SEIR_ode") {
      ## Model
      model <- ifelse(input$demographics, SEIR_demo_ode, SEIR_ode)
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, gamma = 12/input$gamma, tau = 12/input$tau)
      
      ##initial pop
      inits <- data.frame(S = N - I, E = 0, I = I, R = R)
    }else if (input$model %in% "SHLIR_ode") {
      ## Model
      model <- ifelse(input$demographics, SHLIR_demo_ode, SHLIR_ode)
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, gamma_H = input$gamma_H, 
                           gamma_L = 1 / input$gamma_L, nu = 1 / input$nu, tau = 12 / input$tau)
      
      ##initial pop
      inits <- data.frame(S = N - I, H = 0, L = 0, I = I, R = R)
    }else if (input$model %in% "SHLITR_risk_group_ode") {
      ## Model
      model <- SHLITR_risk_group_ode
      sim_fn <- solve_ode
      ##parameters
      params <- data.frame(beta = input$beta, beta_H = input$beta_H, 
                           gamma_H = input$gamma_H, epsilon = 1 / input$epsilon,
                           gamma_L = 1 / input$gamma_L, nu = 1 / input$nu, 
                           tau = 12 / input$tau, mu = 1 / input$mu, p = input$prop_high, M = input$M)
      
      ##initial pop
      inits <- data.frame(S = (1 - params$p) * N, H = 0, L = 0, I = 0, Tr = 0, R = 0,
                          S_H = params$p * N - I, H_H = 0, L_H = 0, I_H = I, Tr_H = 0, R_H = 0)
    }
  
  ## Add demographics
  if (input$demographics) {
    params$mu = 1/input$mu
  }
    
  ## Run model
    model_sim <- simulate_model(model = model, 
                                sim_fn = sim_fn, 
                                inits = inits, 
                                params = params,
                                times = times,
                                as_tibble = TRUE)
    
    models <- list(model_sim, model)
  })
  
  ## Plot model
  output$plot_model_traj <- renderPlotly({
    model_sim()[[1]] %>% 
      biddmodellingcourse::plot_model(facet = input$facet_model, interactive = TRUE)
  })
  
  ## Raw model table
  output$model_sim_results <- DT::renderDataTable({
    model_sim()[[1]]
  })
  
  ## Model summary table
  output$model_sum_tab <- renderTable({
    model_sim()[[1]] %>% 
      biddmodellingcourse::summarise_model() %>% 
      mutate_all(.funs = funs(round(., digits = 0))) %>% 
      mutate_all(.funs = as.integer)
  })
  
  
  ## Model code
  output$model_code <- renderPrint({
    print(model_sim()[[2]])
  })

  ## HTML readme
  output$readme_doc <- renderUI({
    tags$iframe(src = 'https:/www.github.com/seabbs/exploreidmodels/README.html',
                width = '100%', height = '800px', 
                frameborder = 0, scrolling = 'auto')
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
