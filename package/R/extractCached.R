#' Extract cached objects
#' 
#' Extract specific R objects from the knitr cache of a previously compiled Rmarkdown file.
#'
#' @param prefix String containing the prefix of the Rmarkdown file.
#' @param chunk String containing the name of the requested chunk.
#' @param objects Character vector containing variable names for one or more objects to be extracted.
#'
#' @details
#' Each object is extracted in its state at the requested chunk at \code{chunk}.
#' Note that the object does not have to be generated or even referenced in \code{chunk},
#' provided it was generated in a previous chunk.
#'
#' The Rmarkdown file is also subject to several constraints.
#' \itemize{
#' \item All chunks that can be referenced by \code{chunk} are named.
#' \item All named chunks are executed, i.e., no \code{eval=FALSE}.
#' \item All relevant code occurs within triple backticks, i.e., any inline code should be read-only.
#' \item All triple backticks occur at the start of the line, i.e., no code nested in list elements.
#' \item The report with prefix \code{prefix} has already been compiled with \code{cache=TRUE}.
#' \item Any assignment or modifications to variables are done \emph{correctly} with \code{<-}.
#' }
#' 
#' Unnamed chunks are allowed but cannot be referenced and will not be shown in the output of this function.
#' This should not be used for code that might affects varaiables in the named chunks.
#'
#' @return Variables with names \code{objects} are created in the global environment.
#' A markdown chunk (wrapped in a collapsible element) is printed that contains all commands needed to generate those objects, 
#' based on the code in the named chunks of the Rmarkdown file.
#' 
#' @author Aaron Lun
#'
#' @seealso
#' \code{\link{setupHTML}} and \code{\link{chapterPreamble}}, to set up the code for the collapsible element.
#' 
#' @export
#' @importFrom knitr opts_knit load_cache
extractCached <- function(prefix, chunk, objects) {
    all.lines <- readLines(paste0(prefix, ".Rmd"))

    # Extracting chunks until we get to the one with 'chunk'.
    named.pattern <- "^```\\{r ([^,]+).*\\}"
    opens <- grep(named.pattern, all.lines)

    chunks <- list()
    for (i in seq_along(opens)) {
        if (i < length(opens)) {
            j <- opens[i+1] - 1L
        } else {
            j <- length(all.lines)
        }

        available <- all.lines[(opens[i]+1):j]
        end <- grep("^```\\s*$", available)
        if (length(end)==0L) {
            stop("unterminated chunk")         
        } 

        curname <- sub(named.pattern, "\\1", all.lines[opens[i]])
        current.chunk <- available[seq_len(end[1]-1L)]
        chunks[[curname]] <- current.chunk
    }

    m <- match(chunk, names(chunks))
    if (is.na(m)) {
        stop(sprintf("could not find chunk '%s'", chunk))
    }
    chunks <- chunks[seq_len(m)]

    # Collecting all variable names and loading them into the global namespace.
    if (is.null(old <- opts_knit$get("output.dir"))) {
        opts_knit$set(output.dir=".")
        on.exit(opts_knit$set(output.dir=old))
    }
    cache_path <- file.path(paste0(prefix, "_cache"), "html/")

    for (obj in objects) {
        assign.pattern <- paste0(obj, ".*<-")
        found <- FALSE

        # Setting 'rev' to get the last chunk in which 'obj' was on the left-hand side of assignment.
        for (x in rev(names(chunks))) {
            if (found <- any(grepl(assign.pattern, chunks[[x]]))) {
                assign(obj, envir=.GlobalEnv, 
                    value=load_cache(label=x, object=obj, path=cache_path))
                break
            }
        }

        if (!found) {
            stop(sprintf("could not find '%s'", obj))
        }

    }

    # Pretty-printing the chunks.
    cat('<button class="aaron-collapse">View history</button>
<div class="aaron-content">
   
```r\n')
    first <- TRUE
    for (x in names(chunks)) {
        if (!first) {
            cat("\n")
        } else {
            first <- FALSE
        }
        cat(sprintf("### %s ###\n", x))
        cat(chunks[[x]], sep="\n")
    }
    cat("```

</div>\n")
    invisible(NULL)
}
