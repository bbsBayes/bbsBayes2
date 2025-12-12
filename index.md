# Version 1.1.3 release includes 2024 BBS data

## Error in some old versions of the non-hierarchical first-difference model

In versions 1.1.0, 1.1.1, and 1.1.2.0, the non-hierarchical variant of
the first-difference model included a coding error. Estimates of trends
and population trajectories from this model in these versions will be
biased.

The error was fixed in version 1.1.2.1. I am so sorry folks, please
[reach out](https://github.com/AdamCSmithCWS) if you would like more
information or assistance in fixing/recovering from this.

# bbsBayes2

bbsBayes2 is a package for performing hierarchical Bayesian analysis of
North American Breeding Bird Survey (BBS) data. ‘bbsBayes2’ will run a
full model analysis for one or more species that you choose, or you can
take more control and specify how the data should be stratified,
prepared for Stan, or modelled.

bbsBayes2 replaces [bbsBayes](https://github.com/bbsBayes/bbsBayes),
with a major shift in functionality. The MCMC backend is now *Stan*
instead of *JAGS*, the workflow has been streamlined, the syntax has
changed, and there are new functions. This vignette should help you get
started with the package, and there are three others that should help
explain some of the new features, choices, and more advanced uses:

Installation instructions are below.

See the [documentation](https://bbsBayes.github.io/bbsBayes2) for an
overview of how to use bbsBayes2.

In addition, there are four vignettes that will help users get familiar
with the package and the new functionality.

- [Getting Started
  vignette](https://bbsbayes.github.io/bbsBayes2/articles/bbsBayes2.html)

- [Stratification
  vignette](https://bbsbayes.github.io/bbsBayes2/articles/stratification.html)
  The stratification vignette explains the built-in options for spatial
  stratifications as well as the workflow required to apply a custom
  stratification.

- [Models
  vignette](https://bbsbayes.github.io/bbsBayes2/articles/models.html)
  The models vignette explains the four built-in models that differ in
  the way the temporal components are structured, and it also covers the
  built-in options for error distributions and the differences among the
  model variants (e.g., `model_variant = "spatial"`).

- [Advanced
  vignette](https://bbsbayes.github.io/bbsBayes2/articles/advanced.html)
  The advanced vignette is helpful for users wanting to take the
  bbsBayes2 functionality further, including alternate calculations of
  population trend, customizing the Stan models, adding covariates, and
  even some experimental functions that allow for k-fold
  cross-validations to compare among models.

## Installation

bbsBayes2 can be installed from the bbsBayes R-Universe:

``` r
install.packages("bbsBayes2",
                 repos = c(bbsbayes = 'https://bbsbayes.r-universe.dev',
                           CRAN = 'https://cloud.r-project.org'))
```

Alternatively you can install directly from our GitHub repository with
either the [pak](https://pak.r-lib.org/) (recommended) or
[remotes](https://remotes.r-lib.org/) packages.

With pak:

`{r} install.packages("pak") pak::pkg_install("bbsBayes/bbsBayes2")`

With remotes:

`{r} install.packages("remotes") remotes::install_github("bbsBayes/bbsBayes2")`

If you want to install the developmental branch (which often includes
additional options and newest updates), you can use the following. NOTE:
bbsBayes2 is supported by a small team of committed researchers with
limited capacity. The development branch may not be stable.

`{r} pak::pkg_install("bbsBayes/bbsBayes2@dev")`

## Why bbsBayes2

We hope you’ll agree that the BBS is a [spectacular
dataset](https://doi.org/10.1650/CONDOR-17-62.1). Generations of
committed and expert birders have contributed their time and expertise
to carefully keeping track of local bird populations. For many BBS
observers, it’s been a commitment that has lasted 20, 30, or even 40
years! Many federal, state, and provincial government agencies, as well
as local and national conservation organizations have supported the
coordination and curation of almost 60-years of data.

[The BBS was started](https://doi.org/10.1650/CONDOR-17-83.1) at the
dawn of the modern North American conservation movement, inspired by
changes in bird populations noticed by biologists, naturalists, farmers,
and other stewards of the natural world. A continental-scale survey of
birds, carefully designed to quantify changes in populations through
time, in hopes that Rachel Carson’s “Silent Spring”, would never come to
pass.

bbsBayes2 was created: to help researchers make use of these precious
data; to better understand the spatial and temporal changes in bird
populations; to make agency-derived estimates of population status more
transparent; and to inspire improvements, elaborations, and critical
feedback on the models provided here. We hope you enjoy the package and
we hope you will contribute your ideas and code to this open software
initiative.
