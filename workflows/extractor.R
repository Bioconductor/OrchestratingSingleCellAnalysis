setupHTML <- function() 
# Sets up the JS and CSS for the collapsible element.
{
    cat('<script>
document.addEventListener("click", function (event) {
    if (event.target.classList.contains("aaron-collapse")) {
        event.target.classList.toggle("active");
        var content = event.target.nextElementSibling;
        if (content.style.display === "block") {
          content.style.display = "none";
        } else {
          content.style.display = "block";
        }
    }
})
</script>

<style>
.aaron-collapse {
  background-color: #eee;
  color: #444;
  cursor: pointer;
  padding: 18px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  font-size: 15px;
}

.aaron-content {
  padding: 0 18px;
  display: none;
  overflow: hidden;
  background-color: #f1f1f1;
}
</style>')
}

extractCached <- function(prefix, chunk, objects)
# This function extracts the requested objects up to a requested chunk.
# It expects that:
# - all chunks to be stored are named.
# - all chunks to be stored are executed (i.e., no eval=FALSE).
# - all code occurs within triple backticks.
# - all triple backticks occur at the start of the line.
# - the report has already been compiled and its results cached.
# - any modifications to variables are assumed to be done with '<-'.
{
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

    # Collecting all variable names and loading them into the global namespace.
    if (is.null(old <- knitr::opts_knit$get("output.dir"))) {
        knitr::opts_knit$set(output.dir=".")
        on.exit(knitr::opts_knit$set(output.dir=old))
    }
    cache_path <- file.path(paste0(prefix, "_cache"), "html/")

    for (obj in objects) {
        assign.pattern <- paste0(obj, ".*<-")
        found <- FALSE
        for (x in rev(names(chunks))) {
            if (found <- any(grepl(assign.pattern, chunks[[x]]))) {
                assign(obj, envir=.GlobalEnv, 
                    value=knitr::load_cache(label=x, object=obj, path=cache_path))
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
    for (x in names(chunks)) {
        cat(sprintf("### %s ###\n", x))
        cat(chunks[[x]], sep="\n")
    }
    cat("```

</div>\n")
    invisible(NULL)
}



