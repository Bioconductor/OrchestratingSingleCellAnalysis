## knitr options for every section
library(Cairo)
knitr::opts_chunk$set(message = FALSE, warning = FALSE, error = FALSE,
                      cache = TRUE,
                      cache.extra = list(
                          R.version, sessionInfo(), format(Sys.Date(), '%Y-%m')
                      ),
                      dev = 'CairoPNG')
options(digits = 4)
library(BiocStyle)
source("workflows/extractor.R")
setupHTML()
