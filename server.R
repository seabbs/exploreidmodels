#Load packages
library(shiny)
library(shinydashboard)
library(shinyBS)
library(tidyverse)

## Stop spurious warnings
options(warn = -1)

shinyServer(function(input, output) {
  
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
