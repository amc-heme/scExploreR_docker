# Dockerfile

FROM rocker/shiny-verse:4

# System libs: hdf5 (HDF5Array), glpk (igraph/Seurat).
RUN apt-get update \
    && apt-get install -y --no-install-recommends libglpk-dev libhdf5-dev \
    && rm -rf /var/lib/apt/lists/*

# scExploreR + full dep tree via BiocManager->remotes (Remotes: SCUBA, scDE,
# presto + all CRAN/Bioc deps). Hard deps only to skip test-only Suggests.
RUN R -e "install.packages(c('BiocManager','remotes')); if (!library(BiocManager, logical.return=T)) quit(status=10)"
RUN R -e "BiocManager::install('amc-heme/scExploreR', update=FALSE, ask=FALSE, dependencies=c('Depends','Imports','LinkingTo')); if (!library(scExploreR, logical.return=T)) quit(status=10)"

# Runtime deps scExploreR uses but doesn't declare (idempotent install).
RUN R -e "pkgs <- c('shinymanager','gtools','reactlog','profvis','bsicons','bslib','reticulate','anndata','R.devices'); missing <- setdiff(pkgs, rownames(installed.packages())); if (length(missing)) install.packages(missing); if (!all(sapply(pkgs, requireNamespace, quietly=TRUE))) quit(status=10)"
RUN R -e "install.packages('BPCells', repos=c('https://bnprks.r-universe.dev', getOption('repos'))); if (!library(BPCells, logical.return=T)) quit(status=10)"

# Pre-bake the uv-managed Python env (no conda) as the runtime user so it isn't
# fetched on first run. SCUBA py_require()s anndata/pandas/numpy/scipy; +mudata.
USER shiny
RUN R -e "library(SCUBA); reticulate::py_require('mudata>=0.3.1'); reticulate::import('anndata'); reticulate::import('mudata')"
USER root

# App files.
RUN rm -rf /srv/shiny-server
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server/ /srv/shiny-server/
RUN chown -R shiny:shiny /srv/shiny-server
