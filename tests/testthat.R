library(testthat)

  if (is.null(cmdstanr::cmdstan_version(error_on_NA = FALSE))) {
    cmdstanr::install_cmdstan()
  }


suppressPackageStartupMessages(library(bbsBayes2))

test_check("bbsBayes2")

