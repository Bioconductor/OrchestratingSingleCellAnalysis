#' Scrape dependencies
#' 
#' Scrape Rmarkdown reports in the book for all required dependencies.
#'
#' @param dir String specifying the directory containing Rmarkdown reports.
#'
#' @return Character vector of required packages.
#'
#' @details
#' The output of this should be added to the \code{Suggests} field of \pkg{OSCAUtils}, 
#' to make it easier to simply install all dependencies required for the book.
#'
#' @author Aaron Lun
#'
#' @examples
#' if (file.exists("analysis")) {
#'     scraped <- scrapeDependencies("analysis/")
#'     others <- c("GO.db")
#'     cat(paste0("    ", c(scraped, others)), sep=",\n")
#' }
#' @export
scrapeDependencies <- function(dir) {
    all.rmds <- list.files(dir, recursive=TRUE, full.names=TRUE, pattern="\\.Rmd$")
    collated <- character(0)
    
    for (i in seq_along(all.rmds)) {
        txt <- readLines(all.rmds[i])
        collated <- c(collated, 
            .extract_pkgname("library\\(([^\\)]+)\\)", txt),
            .extract_pkgname("require\\(([^\\)]+)\\)", txt),
            .extract_pkgname("([^\\( -,=+/:`]+)::", txt))
    }
    
    collated <- unique(collated)
    collated <- setdiff(collated, "OSCAUtils")
    sort(union(collated, "BiocStyle"))
}

.extract_pkgname <- function(pattern, txt) {
    keep <- grep(pattern, txt)
    matching <- regmatches(txt, regexpr(pattern, txt))
    sub(pattern, "\\1", matching) 
}

