
<!-- badges: start -->
[![R-CMD-check](https://github.com/bbsBayes/bbsBayes2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bbsBayes/bbsBayes2/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/bbsBayes/bbsBayes2/branch/main/graph/badge.svg)](https://app.codecov.io/gh/bbsBayes/bbsBayes2?branch=main)
[![R-Universe](https://bbsbayes.r-universe.dev/badges/bbsBayes2)](https://bbsbayes.r-universe.dev/)
[![Project Status: Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

# bbsBayes2 <img src="man/figures/logo.png" align="right"/>

bbsBayes2 is a package for performing hierarchical Bayesian analysis of North
American Breeding Bird Survey (BBS) data. 'bbsBayes2' will run a full model
analysis for one or more species that you choose, or you can take more control
and specify how the data should be stratified, prepared for Stan, or modelled.

bbsBayes2 is the successor to
[bbsBayes](https://github.com/bbsBayes/bbsBayes), with a major shift in
functionality. The MCMC backend is now *Stan* instead of *JAGS*, the
workflow has been streamlined, the syntax has changed, and there are new
functions. This vignette should help you get started with the package,
and there are three others that should help explain some of the new
features, choices, and more advanced uses:

Installation instructions are below.

See the [documentation](https://bbsBayes.github.io/bbsBayes2) for an overview of
how to use bbsBayes2.

In addition, there are four vignettes that will help users get familiar with the package and the new functionality.

-   [Getting Started vignette](https://bbsbayes.github.io/bbsBayes2/articles/bbsBayes2.html) 

-   [Stratification vignette](https://bbsbayes.github.io/bbsBayes2/articles/stratification.html) The stratification
    vignette explains the built-in options for spatial stratifications
    as well as the workflow required to apply a custom stratification.

-   [Models vignette](https://bbsbayes.github.io/bbsBayes2/articles/models.html) The models vignette explains the four built-in models that differ in the way the temporal components are structured, and it also covers the built-in options for error distributions and the differences among the model variants (e.g., `model_variant = "spatial"`).

-   [Advanced vignette](https://bbsbayes.github.io/bbsBayes2/articles/advanced.html) The advanced vignette is helpful for users wanting to take the bbsBayes2 functionality further, including alternate calculations of population trend, customizing the Stan models, adding covariates, and even some experimental functions that allow for k-fold cross-validations to compare among models. 


## Installation

bbsBayes2 can be installed from the bbsBayes R-Universe:

```r
install.packages("bbsBayes2",
                 repos = c(bbsbayes = 'https://bbsbayes.r-universe.dev',
                           CRAN = 'https://cloud.r-project.org'))
```

Alternatively you can install directly from our GitHub repository with either
the [pak](https://pak.r-lib.org/) (recommended) or 
[remotes](https://remotes.r-lib.org/) packages.

With pak:

```{r}
install.packages("pak")
pak::pkg_install("bbsBayes/bbsBayes2")
```

With remotes:

```{r}
install.packages("remotes")
remotes::install_github(("bbsBayes/bbsBayes2")
```

If you want to install a developmental branch (at your own risk!), you can use 
the following (assuming you want to install a branch called `dev`).

```{r}
pak::pkg_install("bbsBayes/bbsBayes2@dev")
