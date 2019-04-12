## Load packages
source("load_packages.R")

sidebar <- dashboardSidebar(
  hr(),
  sidebarMenu(id = "menu",
              menuItem("Explore Model Dynamics", tabName = "exp-model", icon = icon("line-chart")),
              menuItem("About", tabName = "readme", icon = icon("mortar-board"), selected = TRUE),
              menuItem("Code",  icon = icon("code"),
                       menuSubItem("Github", href = "https://github.com/seabbs/exploreidmodels", icon = icon("github")),
                       menuSubItem("ui.R", tabName = "ui", icon = icon("angle-right")),
                       menuSubItem("server.R", tabName = "server", icon = icon("angle-right"))
              )
  ),
  conditionalPanel(condition = 'input.menu == "exp-model"',
             actionButton("go", "Run Model Simulation"),      
             selectInput("model",
                         "Select a model:",
                         list(SI = "SI_ode",
                              SIR = "SIR_ode",
                              `SIR with vaccination` = "SIR_vaccination_demographics_ode",
                              SEI = "SEI_ode",
                              SEIR = "SEIR_ode",
                              SHLIR = "SHLIR_ode",
                              `SHLITR with risk group` = "SHLITR_risk_demographics_ode")),
             switchInput("demographics",
                         label = "Demographics", 
                         value = FALSE),
             sliderInput("beta", 
                         "Beta:",
                         value = 2,
                         min = 0, 
                         max = 50,
                         step = 0.1),
             conditionalPanel(condition = "input.model == 'SEI_ode' || 
                              input.model == 'SEIR_ode'",
                              sliderInput("gamma",
                                          "Latent period (months):",
                                          value = 6,
                                          min = 0,
                                          max = 300,
                                          step = 1)
             ),
             conditionalPanel(condition = "input.model == 'SHLITR_risk_demographics_ode'",
                              sliderInput("beta_H", 
                                          "High risk Beta:",
                                          value = 6,
                                          min = 0, 
                                          max = 50,
                                          step = 0.1),
                              sliderInput("prop_high",
                                          "Proportion of the population that are high risk:",
                                          value = 1/5,
                                          min = 0, 
                                          max = 1),
                              sliderInput("M",
                                          "Between group mixing:",
                                          value = 1/5,
                                          min = 0, 
                                          max = 1),
                              sliderInput("epsilon",
                                          "Treatment time (months):",
                                          value = 6,
                                          min = 0,
                                          max = 24,
                                          step = 1)
                              
             ),
             conditionalPanel(condition = "input.model == 'SHLIR_ode' || 
                              input.model == 'SHLITR_risk_demographics_ode'",
                              sliderInput("nu",
                                          "High risk latent period (years):",
                                          value = 5,
                                          min = 0,
                                          max = 10,
                                          step = 1),
                              sliderInput("gamma_H",
                                          "Rate of developing active disease when high risk:",
                                          value = 1/5,
                                          min = 0, 
                                          max = 1),
                              sliderInput("gamma_L",
                                          "Low risk latent period (years):",
                                          value = 20,
                                          min = 0,
                                          max = 100,
                                          step = 1)
                              
             ),
             conditionalPanel(condition = "input.model == 'SEIR_ode' || input.model == 'SHLIR_ode' ||
                              input.model == 'SHLITR_risk_demographics_ode' || input.model == 'SIR_ode'",
                              sliderInput("tau",
                                          "Infectious period (months):",
                                          value = 3,
                                          min = 0,
                                          max = 150,
                                          step = 1)
             ),
             conditionalPanel(condition = "input.model == 'SIR_vaccination_demographics_ode'",
                              sliderInput("alpha", 
                                          "Proportion vaccinated:",
                                          value = 0.8,
                                          min = 0, 
                                          max = 1,
                                          step = 0.01),
                              sliderInput("lambda",
                                          "Effectiveness of the vaccine:",
                                          value = 0.8,
                                          min = 0, 
                                          max = 1)
                              
             ),
             conditionalPanel(condition = "input.demographics",
                              sliderInput("mu",
                                          "Life Expectancy (years):",
                                          value = 80,
                                          min = 0, 
                                          max = 1000,
                                          step = 1)),
             radioButtons(
               inputId = "maxtime", label = "Timespan (years):", 
               choices = c(10, 100, 200),
               selected = 10,
               inline = TRUE)),
  hr(),
  helpText("Developed by ", 
           a("Sam Abbott", href = "http://samabbott.co.uk"), 
           "Powered by",
           a("idmodelr", href = "http://samabbott.co.uk/idmodelr"),
           style = "padding-left:1em; padding-right:1em;position:absolute;")
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "exp-model",
          fluidPage(
            fluidRow(
              tabBox(
                width = 12,
                height = "800px",
                title = "Model", 
                side = "right",
                tabPanel(title = "Trajectories",
                         plotlyOutput("plot_model_traj", width = "100%", height = "650px") %>% 
                           withSpinner(),
                         switchInput("facet_model",
                                     label = "Plot compartments separately", 
                                     value = FALSE, inline = TRUE, width = "auto"),
                         switchInput("previous_model_run",
                                     label = "Show the previous model run", 
                                     value = FALSE, inline = TRUE, width = "auto")
                ),
                tabPanel(title = "Code",
                         verbatimTextOutput("model_code") %>% 
                           withSpinner()
                )
              )),
            fluidRow(
              tabBox(
                width = 12,
                title = "Model Tables", 
                side = "right",
                tabPanel(title = "Summary",
                         tableOutput("model_sum_tab") %>% 
                           withSpinner()),
                tabPanel(title = "Trajectories",
                         DT::dataTableOutput("model_sim_results") %>% 
                            withSpinner()
                )
              )
            )
          )
),
    tabItem(tabName = "readme",
            includeMarkdown("README.md")
    ),
    tabItem(tabName = "ui",
            box( width = NULL, status = "primary", solidHeader = TRUE, title = "UI",
                 downloadButton('downloadData2', 'Download'),
                 br(),br(),
                 pre(includeText("ui.R"))
            )
    ),
    tabItem(tabName = "server",
            box( width = NULL, status = "primary", solidHeader = TRUE, title = "Server",
                 downloadButton('downloadData3', 'Download'),
                 br(),br(),
                 pre(includeText("server.R"))
            )
    )
  )
)

dashboardPage(
  dashboardHeader(title = "Explore ID Models"),
  sidebar,
  body,
  skin = "green"
)
