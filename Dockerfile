## Start with the shiny docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

RUN export ADD=shiny && bash /etc/cont-init.d/add

ADD . /home/rstudio/exploreidmodels

RUN Rscript /home/rstudio/exploreidmodels/load_packages.R

ADD . /srv/shiny-server/exploreidmodels

EXPOSE 3838
EXPOSE 8787
