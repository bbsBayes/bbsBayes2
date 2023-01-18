strip_model_files <- function(files) {
  f <- files[stringr::str_detect(files, ".csv$")]

  f_new <- stringr::str_remove(f, paste0(Sys.Date(), "-"))
  file.rename(f, f_new)

  # Trim to omit date/run related metrics (stuff that changes)
  for(i in f_new){
    x <- readLines(i)
    x <- x[!stringr::str_detect(x, "^#")]
    writeLines(x, i)
  }

  f_new
}


#' Wrapper for `expect_snapshot_value()` from testthat
#'
#' Copies parameters over from `expect_snapshot_value()`
#'
#' @noRd
expect_snapshot_value_safe <- function(...) {

   if(!interactive()) {
     testthat::expect_snapshot_value(...)
   } else message("Skipping snapshot tests because interactive")

}


#' Check if cmdstan is installed
#'
#' Wrapper around `cmdstanr::cmdstan_version(error_on_NA = FALSE)` for quick
#' check.
#'
#' Used internally for skipping examples and tests if no cmdstan installed.
#'
#' @export
have_cmdstan <- function() {
  !is.null(cmdstanr::cmdstan_version(error_on_NA = FALSE))
}


#' Skip tests if no BBS data
#'
#' @noRd
skip_if_no_data <-function() {
  testthat::skip_if_not(have_bbs_data())
}

#' Skip tests if no Stan installed
#'
#' @noRd
skip_if_no_stan <- function() {
  testthat::skip_if_not(have_cmdstan())
}
