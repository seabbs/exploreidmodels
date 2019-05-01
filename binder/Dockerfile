
FROM rocker/binder:latest

USER root
COPY . ${HOME}
RUN mkdir ${HOME}/app && /
    cp -a ${HOME}/. ${HOME}/app
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}
    
RUN R -e "source('load_packages.R')"
