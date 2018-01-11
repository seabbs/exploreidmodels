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
             selectInput("model",
                         "Select a model:",
                         list(SI = "SI_ode",
                              `SI with demographics` = "SI_demo_ode",
                              SEI = "SEI_ode",
                              `SEI with demographics` = "SEI_demo_ode")),
             sliderInput("beta", 
                         "Beta:",
                         value = 2,
                         min = 0, 
                         max = 50,
                         step = 0.1),
             conditionalPanel(condition = "input.model == 'SEI_ode' || input.model == 'SEI_demo_ode'",
                              sliderInput("gamma",
                                          "Exposure period (months):",
                                          value = 6,
                                          min = 0,
                                          max = 300,
                                          step = 1)
             ),
             conditionalPanel(condition = "input.model == 'SEI_demo_ode' ||
                              input.model ==  'SI_demo_ode'",
                              sliderInput("mu",
                                          "Life Expectancy (years):",
                                          value = 80,
                                          min = 0, 
                                          max = 1000,
                                          step = 1)),
             radioButtons("maxtime",
                         "Timespan for model (years):",
                         selected = 10,
                         choices = c(10, 100, 1000), 
                         inline = TRUE)
                   ),
  hr(),
  helpText("Developed by ", a("Sam Abbott", href = "http://samabbott.co.uk"), 
           style = "padding-left:1em; padding-right:1em;position:absolute; bottom:1em; ")
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "exp-model",
            fluidRow(
              tabBox(width = 12, 
                     title = "Model Plots", 
                     side = "right",
                     tabPanel(title = "Trajectories",
                              plotlyOutput("plot_model_traj"),
                              checkboxInput("facet_model",
                                            label = "Plot each compartment seperately", 
                                            value = FALSE)
                              )
                     ),
                     tabBox(width = 12, 
                            title = "Model Tables", 
                            side = "right",
                            tabPanel(title = "Summary",
                                     tableOutput("model_sum_tab")),
                            tabPanel(title = "Trajectories",
                                     DT::dataTableOutput("model_sim_results")
                            )
                            )
    )),
    tabItem(tabName = "readme",
            withMathJax(), 
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
  skin = "black"
)