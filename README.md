# Rmarkdown files for Orchestrating Single Cell Analyses

## Overview

This repository contains the basic ingredients for the 
[Orchestrating Single Cell Analysis](https://github.com/Bioconductor/OrchestratingSingleCellAnalysis) book.
Developers wanting to contribute scientific content to the book should make pull requests to this repository, 
the one linked above is just used to host the book content on GitHub Pages.
Our set-up provides a light code-only repository (this one) for day-to-day developer use,
which avoids the Git blob bloat from storing PNGs and HTMLs in the other repository.
It also enables us to automatically reconstruct the section orderings without needing to manually rename the files.

## Structure

The repository subdirectories reflect the structure of the book:

- `intro`: some introductory sections focusing on how to install and use R and Bioconductor.
- `analysis`: the meat of the book, where each chapter focuses on a different step of a scRNA-seq analysis.
- `workflows`: end-to-end analysis Rmarkdown reports with minimal explanatory text.
- `about`: some bits and pieces about the contributors.

In addition, there is the **OSCAUtils** package in `package`, which provides a number of utilities for book construction;
and `sundries`, which provides some **bookdown**-related bits and pieces.

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
Also note the `chapterPreamble()` code chunk that is required at the top of each chapter to set up the collapsible elements.

## Instructions

### To build the workflows

Install the **OSCAUtils** package with `R CMD INSTALL package`.

Run the following code to create a book repository in `"some_dir"`.

```r
library(OSCAUtils)
spawnBook("OSCA")
compileWorkflows("OSCA")
```

Setting `fresh=FALSE` in `compileWorkflows()` will avoid deleting old caches for a faster compilation,
though it is recommended to routinely compile with `fresh=TRUE` to avoid problems with silently invalidated caches.

### To build the book

To compile the book in its entirety, the following code will create the book in a subdirectory (in this case `OSCA/docs/`).

```r
setwd("OSCA") # process must be started in the book directory
bookdown::render_book("index.Rmd", "bookdown::gitbook",
                      quiet = FALSE, output_dir = "docs", new_session = TRUE)
```

Note that for pushing figures to the main book repository, the `Cairo` library is required so that images are rendered as PNG files (see the `chapterPreamble()` function of the `OSCAUtils` package).

### To contribute reports

Standard procedure: fork and PR.

- All `analysis` chapters must start from a `SingleCellExperiment` object and should be independent of other `analysis` chapters.
- All `workflow` chapters should use a `SingleCellExperiment` object throughout the various chunks.
This allows chapters to pick up the SCE at any point.
