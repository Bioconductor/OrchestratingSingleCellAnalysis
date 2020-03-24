#' Compile workflow chapters
#'
#' Compile workflows for the book so that \code{\link{extractCached}} calls work correctly in other chapters.
#'
#' @param dir String containing the path to the directory of book chapters.
#' Usually the same as \code{dir} in \code{\link{setupBookChapters}}.
#' @param fresh Logical scalar indicating whether or not to delete old caches.
#' @param files Character vector containing the path to individual workflow files.
#' If this is set, \code{dir} is ignored.
#'
#' @return
#' All workflow chapters in \code{dir} are (re)compiled to generate the corresponding \code{*_cache} directories.
#' (If \code{files} is specified, only those files are compiled.)
#' \code{NULL} is invisibly returned.
#'
#' @details
#' Compilation is performed in an isolated session using \code{\link{r}} from the \pkg{callr} package.
#' This ensures that settings from one chapter do not affect the next chapter.
#'
#' The default \code{fresh=TRUE} is recommended for a rigorous recompilation,
#' but setting it to \code{FALSE} may be more convenient for quick debugging cycles.
#'
#' If an error is encountered during compilation of any Rmarkdown file,
#' the standard output of \code{\link{render}} leading up to the error is printed out before the function exists.
#'
#' @author Aaron Lun
#'
#' @export
#' @importFrom callr r
#' @importFrom rmarkdown render
compileWorkflows <- function(dir=".", fresh=TRUE, files=NULL) {
    if (is.null(files)) {
        files <- list.files(dir, pattern=sprintf("^P%i_W.*\\.Rmd", .workflow_part), full.names=TRUE)
    }

    for (f in files) {
        if (fresh) {
            cache.loc <- sub("\\.Rmd$", "_cache", f)
            unlink(cache.loc, recursive=TRUE)
        }

        logfile <- tempfile(fileext=".log")
        E <- try(
            r(function(input) { rmarkdown::render(input) }, args = list(input = f), 
                stdout=logfile, stderr=logfile, spinner=FALSE),
            silent=TRUE
        )

        if (is(E, "try-error")) {
            message(sprintf("%s> %s\n", target, readLines(logfile)))
            stop(sprintf("failed to compile '%s'", script))
        }
    }

    invisible(NULL)
}
