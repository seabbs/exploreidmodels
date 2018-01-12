## Load packages
packages <- list("shiny", "shinydashboard", "shinyBS", "tidyverse", 
                   "rmarkdown", "plotly", "DT", "idmodelr", "biddmodellingcourse", "shinyWidgets")

## Assign usernames to github packages
names(packages)[packages %in% "idmodelr"] <- "seabbs"
names(packages)[packages %in% "biddmodellingcourse"] <- "bristolmathmodellers"

load_packages <- function(packages) {
  packages <- c("devtools", packages)
  
  for (i in 1:length(packages)) {
    package <- packages[[i]]
    user <- names(packages)[i]
    
    if (!library(package, logical.return = TRUE, 
                 character.only = TRUE, quietly = TRUE)) {
      if (is.na(user)) {
        install.packages(package)
      }else{
        user_package <- paste0(user, "/", package)
        devtools::install_github(user_package)
      }
      library(package, logical.return = TRUE, character.only = TRUE)
    }
  }
  
  return()
}

load_packages(packages)

