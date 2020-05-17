# Rmarkdown files for Orchestrating Single Cell Analyses

## Overview

This repository contains the basic ingredients for the [Orchestrating Single Cell Analysis](https://osca.bioconductor.org) book.
Developers wanting to contribute scientific content to the book should make pull requests to this repository, 
the others with `-release` or `-devel` suffixes are just used to host the book content on GitHub Pages.
Our set-up provides a light code-only repository (this one) for day-to-day developer use,
which avoids the Git blob bloat from storing PNGs and HTMLs in the other repository.
It also enables us to automatically reconstruct the section orderings without needing to manually rename the files.

## Structure

The repository subdirectories reflect the structure of the book:

- `intro`: some introductory sections focusing on how to install and use R and Bioconductor.
- `analysis`: the meat of the book, where each chapter focuses on a different step of a scRNA-seq analysis.
- `workflows`: end-to-end analysis Rmarkdown reports with minimal explanatory text.
- `about`: some bits and pieces about the contributors.
- `sundries`: some **bookdown**-related bits and pieces.
- `images`: various static images used throughout the book.

In addition, there is the **OSCAUtils** package in `package`, which provides utilities for book construction.

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

Install the **rebook** package from https://github.com/LTLA/rebook.

Run:

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook",
    quiet = FALSE, output_dir = "docs", new_session = TRUE)
```

### To contribute reports

Standard procedure: fork and PR.

- All `analysis` chapters must start from a `SingleCellExperiment` object and should be independent of other `analysis` chapters.
- All `workflow` chapters should use a `SingleCellExperiment` object throughout the various chunks.
This allows chapters to pick up the SCE at any point.
