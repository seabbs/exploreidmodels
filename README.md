
Explore Infectious Disease Models
=================================

[This shiny app](http://seabbs.co.uk/shiny/exploreidmodels) allows interactive exploration of a dynamic infections disease models abstracted from the required code implementation.

Installing the shiny app locally
--------------------------------

Manual Install
--------------

To install and run the shiny app locally on your own computer you will need to first install [R](https://www.r-project.org/), it is also suggested that you install [Rstudio](https://www.rstudio.com/products/rstudio/download/). After downloading the source code from [this repository](https://www.github.com/seabbs/exploreidmodels) click on the `exploreidmodels.Rprof` file, this will open an Rstudio window. Type the following code into the command line;

``` r
install.packages("packrat")
packrat::restore()
```

To run the app open the `ui.R` file and press run, depending on your computer this may take some time.

### Using Docker

[Docker](https://www.docker.com/what-docker) is a container software that seeks to eliminate "works on my machine" issues. For installation and set up instructions see [here](https://www.docker.com/community-edition).

This docker container is based on the [tidyverse](https://hub.docker.com/r/rocker/tidverse/) docker image, see [here](https://github.com/rocker-org/tidyverse) for instructions on use. To run the docker image run the following in a bash shell:

``` bash
docker pull seabbs/exploreidmodels
docker run --rm -p 8787:8787 -e USER=exploreidmdoels -e PASSWORD=exploreidmodels --name exploreidmodels seabbs/exploreidmodels
```

The Rstudio server can be found on port `:8787` at your local machines ip (or localhost on windows).
