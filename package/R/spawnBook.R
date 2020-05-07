#' Set up the book repository
#'
#' Initialize or update the repository containing the book contents.
#'
#' @param src String containing a path to the directory containing the \pkg{OSCABase} contents.
#' @param dir String containing a path to a directory in which the compiled book is to reside.
#'
#' @return
#' If \code{dir} does not already exist, a Git repository is created at that location.
#' The directory is then filled with the book contents.
#' A \code{NULL} is invisibly returned.
#'
#' @details
#' See \code{\link{.setupBookChapters}} for some reasons why we set up the book like this.
#'
#' @author Aaron Lun
#'
#' @export 
spawnBook <- function(src, dir) {
    dir.create(dir, showWarnings=FALSE)
    src <- normalizePath(src)

    wd <- getwd()
    setwd(dir)
    on.exit(setwd(wd))

    setupBookChapters(src, ".")

    # Copying over various bookdown required files.
    others <- list.files(file.path(src, "sundries"), full.names=TRUE)
    file.copy(others, basename(others), overwrite=TRUE)
    
    invisible(NULL)
}
