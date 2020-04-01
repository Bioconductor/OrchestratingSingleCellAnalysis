#' Compile workflow chapters
#'
#' Compile workflows for the book so that \code{\link{extractCached}} calls work correctly in other chapters.
#'
#' @param files Character vector containing the path to individual workflow files.
#'
#' @return
#' All files are (re)compiled to generate the corresponding \code{*_cache} directories.
#' \code{NULL} is invisibly returned.
#'
#' @details
#' Compilation is performed in an isolated session using \code{\link{r}} from the \pkg{callr} package.
#' This ensures that settings from one chapter do not affect the next chapter.
#'
#' If an error is encountered during compilation of any Rmarkdown file,
#' the standard output of \code{\link{render}} leading up to the error is printed out before the function exists.
#'
#' @author Aaron Lun
#'
#' @export
#' @importFrom callr r
#' @importFrom rmarkdown render
compileWorkflows <- function(files) {
    for (f in files) {
        logfile <- tempfile(fileext=".log")
        E <- try(
            r(function(input) { rmarkdown::render(input) }, args = list(input = f), 
                stdout=logfile, stderr=logfile, spinner=FALSE),
            silent=TRUE
        )

        if (is(E, "try-error")) {
            message(sprintf("> %s\n", readLines(logfile)))
            stop(sprintf("failed to compile '%s'", f))
        }
    }

    invisible(NULL)
}
