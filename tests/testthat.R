library(testthat)

if (requireNamespace("cmdstanr", quietly = TRUE)) {
  if (is.null(cmdstanr::cmdstan_path(sanitize = FALSE))) {
    cmdstanr::install_cmdstan()
  }
}

suppressPackageStartupMessages(library(bbsBayes2))

test_check("bbsBayes2")

