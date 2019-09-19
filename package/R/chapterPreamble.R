#' Execute chapter preamble code
#'
#' Execute code to set up knitr compilation flags, HTML content, load required packages, etc. at the start of every chapter.
#'
#' @details
#' Compilation is performed with no tolerance for errors, no printing of package start-up messages, 
#' and no printing of warnings.
#'
#' If the \pkg{Cairo} package is available, it will be used with the \code{"CairoPNG"} device to generate figures.
#'
#' Numbers are printed to 4 digits of precision.
#' 
#' JS and CSS elements are set up using \code{\link{setupHTML}}.
#' 
#' @author Aaron Lun
#' 
#' @export
#' @importFrom knitr opts_chunk
chapterPreamble <- function(use_cache = TRUE) {
    opts_chunk$set(message = FALSE, warning = FALSE, error = FALSE, cache = use_cache)
    suppressPackageStartupMessages(require(BiocStyle))
    if (suppressWarnings(require(Cairo, quietly=TRUE))) {
        opts_chunk$set(dev="CairoPNG")
    }
    options(digits = 4)
    setupHTML()
}
