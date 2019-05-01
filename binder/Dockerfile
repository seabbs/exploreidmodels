
FROM rocker/binder:latest

USER root
COPY . ${HOME}
RUN mkdir app
RUN cp -a ${HOME}/. app
RUN mv -a app ${HOME}/app
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}
    
RUN R -e "source('load_packages.R')"
