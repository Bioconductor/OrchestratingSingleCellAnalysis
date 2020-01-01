#' Set up the book materials
#'
#' Create the raw materials to compile the book given the files in the \pkg{OSCAbase} repository.
#'
#' @param dir String containing a path to a Git repository in which the book is to reside.
#' 
#' @return
#' Creates or updates a Git submodule for the \pkg{OSCAbase} repository inside \code{dir}.
#' Creates or updates the Rmarkdown files comprising the book's contents.
#' Returns \code{NULL} invisibly.
#'
#' @details
#' This function should be run prior to any re-compilation of the book contents,
#' to ensure that the latest versions of all chapters are available.
#'
#' We use dynamic regeneration of book chapters in a separate repository to isolate the book source from its outputs.
#' This reduces the size of the \dQuote{effective} Git repository in \pkg{OSCABase},
#' making it easier to work with (i.e., faster cloning/pulling, no pollution of the commit history). 
#' Contributors are no longer burdened with the management of chapter numbering,
#' which if they are adding a new chapter in the middle of a part.
#' Our system also easily supports multiple versions of the book, e.g., for release and devel.
#' 
#' Note that any existing chapters will be deleted upon running this function.
#' Any persistent changes to chapter content should be made to the \pkg{OSCABase} repository. 
#'
#' @author Aaron Lun
#'
#' @export
setupBookChapters <- function(dir=".") {
    wd <- getwd()
    setwd(dir)
    on.exit(setwd(wd))

    basic <- "OSCABase"
    if (!file.exists(basic)) {
        system2("git", c("submodule", "add", "https://github.com/Bioconductor/OSCABase"))
    } else {
        system2("git", c("submodule", "update", "--remote"))
    }

    file.copy(file.path(basic, "intro", "index.Rmd"), "index.Rmd")
    file.copy(file.path(basic, "ref.bib"), "ref.bib")

    .uplift(part=1, 
        files=file.path(basic, "intro",
            c(
                "introduction.Rmd",
                "learning-r-and-bioconductor.Rmd",
                "beyond-r-basics.Rmd",
                "data-infrastructure.Rmd"
            )
        )
    )

    .uplift(part=2,
        files=file.path(basic, "analysis",
            c(
                "overview.Rmd",
                "quality-control.Rmd",
                "normalization.Rmd",
                "feature-selection.Rmd",
                "reduced-dimensions.Rmd",
                "clustering.Rmd",
                "marker-detection.Rmd",
                "cell-annotation.Rmd",
                "data-integration.Rmd",
                "sample-comparisons.Rmd",
                "doublet-detection.Rmd",
                "cell-cycle.Rmd",
                "trajectory.Rmd",
                "protein-abundance.Rmd",
                "repertoire-seq.Rmd",
                "interactive.Rmd",
                "big-data.Rmd",
                "interoperability.Rmd"
            )
        )
    )

    .uplift(part=.workflow_part,
        files=file.path(basic, "workflows",
            c(
                "lun-416b.Rmd",
                "zeisel-brain.Rmd",
                "tenx-unfiltered-pbmc4k.Rmd",
                "tenx-filtered-pbmc3k-4k-8k.Rmd",
                "tenx-repertoire-pbmc8k.Rmd",
                "grun-pancreas.Rmd",
                "muraro-pancreas.Rmd",
                "lawlor-pancreas.Rmd",
                "segerstolpe-pancreas.Rmd",
                "merged-pancreas.Rmd",
                "pijuan-embryo.Rmd",
                "bach-mammary.Rmd",
                "hca-bone-marrow.Rmd"
            )
        )
    )

    .uplift(part=4,
        files=file.path(basic, "about",
            c(
                "about-the-contributors.Rmd",
                "bibliography.Rmd"
            )
        )
    )
    
    invisible(NULL)
}

.uplift <- function(part, files) {
    newfiles <- sprintf("P%i_W%02d.%s", part, seq_along(files), basename(files))
    unlink(list.files(pattern=sprintf("^P%i_W[0-9]+\\..*\\.Rmd$", part)))
    file.copy(files, newfiles)
}

.workflow_part <- 3L
