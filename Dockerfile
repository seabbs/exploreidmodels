## Start with the shiny docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

ADD . /home/rstudio/exploreidmodels

RUN Rscript /home/rstudio/exploreidmodels/load_packages.R
