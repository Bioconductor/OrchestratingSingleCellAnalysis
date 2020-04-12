#' Set up the book repository
#'
#' Initialize or update the repository containing the book contents.
#'
#' @param dir String containing the path to the (possibly existing) book repository.
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
spawnBook <- function(dir=".") {
    if (absent <- !dir.exists(dir)) {
        dir.create(dir)
    }

    wd <- getwd()
    setwd(dir)
    on.exit(setwd(wd))

    if (absent) {
        system2("git", "init")
    }

    setupBookChapters()

    # Copying over various bookdown required files.
    others <- list.files(file.path("OSCABase", "sundries"), full.names=TRUE)
    file.copy(others, basename(others))
    
    invisible(NULL)
}
