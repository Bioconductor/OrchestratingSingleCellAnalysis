# Rmarkdown files for Orchestrating Single Cell Analyses

## Overview

This repository contains the raw Rmarkdown files for the 
[Orchestrating Single Cell Analysis](https://github.com/Bioconductor/OrchestratingSingleCellAnalysis) book.
Developers wanting to contribute scientific content to the book should make pull requests to this repository, 
the one linked above is just required to build the actual book.
This set-up provides a light code-only repository (this one) for day-to-day developer use,
which avoids the Git blob bloat from storing PNGs and HTMLs in the other repository.
It also enables us to automatically reconstruct the section orderings without needing to manually rename the files.

## Structure

The repository subdirectories reflect the structure of the book:

- `intro`: some introductory sections focusing on how to install and use R and Bioconductor.
- `analysis`: the meat of the book, where each chapter focuses on a different step of a scRNA-seq analysis.
- `about`: some bits and pieces about the contributors.

Within `analysis`, there is an additional `workflows` subdirectory.
This contains end-to-end analysis Rmarkdown reports with minimal text and the bare minimum of code.
We will refer to these `analysis/workflows` files as "workflows", in contrast to the "chapters" in `analysis` itself.

## Using cached objects

Compilation of the workflows will cache the objects generated after each chunk.
This allows objects to be quickly re-used in the chapters without having to repeat or rewrite the prior steps.
The `extractCached()` calls littered in the chapters will extract objects of interest from each cache,
also reporting the steps used to generate those objects in a folded code chunk.
This enables readers of each chapter to inspect the code without interrupting the pedagogical flow.

As a consequence, compilation of many of the chapters depends on compilation of the workflows.
Thus, all contributors should compile the latter first.
Those writing new chapters should move all set-up code into a similar workflow 
and exploit the `extractCached()` to obtain a starting point for their chapter.
Also note the `setupHTML()` code chunk that is required at the top of each chapter to set up the code folding Javascript and CSS.

## Instructions

### To build the reports

Before compilation of the chapters, the workflows must be compiled:

```r
all.workflows <- list.files('analysis/workflows', pattern="Rmd$", full=TRUE)
for (x in all.workflows) {
    rmarkdown::render(x)
}
```

Each chapter should be compilable as a standalone unit, depending only on the workflows and not on other chapters.
As such, there is no need to compile chapters in any chronological order.

```{r}
rmarkdown::render("analysis/clustering.Rmd")
rmarkdown::render("analysis/quality-control.Rmd")
rmarkdown::render("analysis/reduced-dimensions.Rmd")
```

### To contribute reports

Standard procedure: fork and PR.

- All chapters must start from a `SingleCellExperiment` object.
- All workflows should use a `SingleCellExperiment` object throughout the various chunks.
This allows chapters to pick up the SCE at any point.

@LTLA will review all incoming PRs for `analysis/`-related code.
