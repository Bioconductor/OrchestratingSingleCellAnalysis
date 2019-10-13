#' Fetch image
#'
#' Fetch an image to display via \code{\link{include_graphics}}.
#' This either uses the path directly or obtains it from a URL if the file is not present at the indicated path.
#' 
#' @param path String containing a path to an image file.
#' Can be missing or point to a file that does not exist.
#' @param url String containing a URL to the image file, used if \code{path} does not exist.
#'
#' @details
#' This function uses \pkg{BiocFileCache} to cache the image from \code{url} if \code{path} does not point to a file.
#'
#' @return String containing a path to an image file.
#'
#' @author Aaron Lun
#' 
#' @seealso 
#' \code{\link{include_graphics}}, to use the returned path.
#'
#' @export
fetchImage <- function(path, url) {
    if (missing(path) || !file.exists(path)) {
        bfc <- BiocFileCache::BiocFileCache(ask=FALSE)
        path <- BiocFileCache::bfcrpath(bfc, url)
    } 
    path
}
