setwd("/srv/shiny-server/project-name")

# Attach packages scExploreR calls unqualified (not in its NAMESPACE):
# R.devices=suppressGraphics, SingleCellExperiment=altExp/assay/..., tools=toTitleCase, reticulate=py_require
suppressPackageStartupMessages({
  library(R.devices)
  library(SingleCellExperiment)
  library(tools)
  library(reticulate)
})

scExploreR::run_scExploreR(
  browser_config = "/srv/shiny-server/project-name/config.yaml", 
  launch_browser = FALSE
  )
  