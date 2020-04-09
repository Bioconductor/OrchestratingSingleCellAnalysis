#' Fetch image
#'
#' Fetch an image from a URL to display via \code{\link{include_graphics}}.
#' 
#' @param name String containing the image file name for certain image files stored in the \pkg{OSCABase} repository.
#'
#' @details
#' Image files that are not otherwise available online can be committed to the \code{images} subdirectory 
#' of the \code{images} branch of the \pkg{OSCABase} repository.
#' We use a separate branch to isolate these (usually large) image files from the Git history of the rest of the repository;
#' this gives us the option of completely moving them from \pkg{OSCABase} to another location
#' without any residual blobs in the \code{master}.
#'
#' @return String containing a URL to an image file.
#'
#' @author Aaron Lun
#' 
#' @seealso 
#' \code{\link{include_graphics}}, to use the returned path.
#'
#' @export
fetchImage <- function(name) {
    file.path("https://raw.githubusercontent.com/Bioconductor/OSCABase/images/images", name)
}
