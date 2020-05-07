# Deployment script.

builddir <- commandArgs(trailingOnly=TRUE)[1]
if (is.na(builddir)) {
    stop("need to specify the build directory")
}

OSCAUtils::spawnBook(".", builddir)

setwd(builddir)
bookdown::render_book("index.Rmd", "bookdown::gitbook",
    quiet = FALSE, output_dir = "docs", new_session = TRUE)
