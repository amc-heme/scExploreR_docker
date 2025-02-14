# Dockerfile

FROM rocker/shiny-verse:latest

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends libglpk-dev libhdf5-dev

# Install essential R packages
RUN R -e "install.packages('Seurat'); if (!library(Seurat, logical.return=T)) quit(status=10)"
RUN R -e "remotes::install_github('bnprks/BPCells/r');  if (!library(BPCells, logical.return=T)) quit(status=10)"

# Install Bioconductor packages
RUN R -e "install.packages('BiocManager'); if (!library(BiocManager, logical.return=T)) quit(status=10)"
RUN R -e "BiocManager::install(c('SummarizedExperiment', 'HDF5Array', 'SingleCellExperiment'))"
RUN R -e "remotes::install_github('amc-heme/scExploreR');  if (!library(scExploreR, logical.return=T)) quit(status=10)"

# Install additional system dependencies
RUN apt-get install -y --no-install-recommends texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra lmodern

# Install additional R packages
RUN R -e "install.packages(c('survminer','survival','tinytex','RColorBrewer','data.table','ggpubr','reshape2','viridis'))"
RUN R -e "BiocManager::install(c('biomaRt','RTCGA.clinical'))"

# Install more R packages
RUN R -e "install.packages(c('shinythemes', 'thematic', 'kableExtra', 'TidyMultiqc', 'janitor', 'ggiraph', 'circlize', 'esquisse', 'ggprism', 'formulaic', 'heatmaply', 'bsicons'))"
RUN R -e "BiocManager::install(c('tximport','DESeq2','fgsea','BiocParallel','ComplexHeatmap','sva', 'InteractiveComplexHeatmap'))"

# Install Python dependencies using reticulate
USER shiny
RUN R -e "reticulate::install_miniconda()"
RUN . /home/shiny/.local/share/r-miniconda/bin/activate \
    && conda activate /home/shiny/.local/share/r-miniconda/envs/r-reticulate \
    && /home/shiny/.local/share/r-miniconda/envs/r-reticulate/bin/python -m pip install --upgrade --no-user anndata scanpy

USER root

# Clean up and copy app files
RUN rm -rf /srv/shiny-server
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server/ /srv/shiny-server/
RUN chown -R shiny:shiny /srv/shiny-server