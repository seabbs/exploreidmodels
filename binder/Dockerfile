
FROM rocker/binder:latest

USER root
COPY . ${HOME} cp ./* ./Child1/
RUN mkdir app && mv app ..
RUN cp -a ${HOME}/. ../app && mv ../app .
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}
    
RUN R -e "source('load_packages.R')"
