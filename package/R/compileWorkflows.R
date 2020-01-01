#' Compile workflow chapters
#'
#' Compile workflows for the book so that \code{\link{extractCached}} calls work correctly in other chapters.
#'
#' @param dir String containing the path to the directory of book chapters.
#' Usually the same as \code{dir} in \code{\link{setupBookChapters}}.
#'
#' @return
#' All workflow chapters are (re)compiled to generate the corresponding \code{*_cache} directories.
#' \code{NULL} is invisibly returned.
#'
#' @details
#' Compilation is performed in an isolated session using \code{\link{r}} from the \pkg{callr} package.
#' This ensures that settings from one chapter do not affect the next chapter.
#'
#' @author Aaron Lun
#'
#' @export
#' @importFrom callr r
#' @importFrom rmarkdown render
compileWorkflows <- function(dir=".") {
    all.files <- list.files(dir, pattern=sprintf("^P%i_W.*\\.Rmd", .workflow_part), full.names=TRUE)
    for (f in all.files) {
        cache.loc <- sub("\\.Rmd$", "_cache", f)
        unlink(cache.loc, recursive=TRUE)
        r(function(input) { rmarkdown::render(input) }, args = list(input = f), 
            show=TRUE, spinner=FALSE)
    }
    invisible(NULL)
}
