## Start with the shiny docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

ADD . /home/rstudio/exploreidmodels

RUN Rscript -e 'source("/home/rstudio/load_packages.R")'
