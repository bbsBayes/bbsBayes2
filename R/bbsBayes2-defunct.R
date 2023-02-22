#' bbsBayes2 defunct functions
#'
#' @param ... Original function arguments
#'
#' @name bbsBayes2-defunct
#'
#' @description
#'
#' ## Superseded
#'
#'  No superseded functions
#'
#' ## No longer relevant
#'
#'  No non-relevant functions
#'
#' @seealso [bbsBayes2-deprecated]
#'
NULL

#' Error/Warn on deprecated function or argument
#'
#' @param when Character. Version of bbsBayes2 when `what` was made defunct.
#' @param what Character. Argument name or `NULL` for containing function.
#' @param replace Character. What the user should use instead. Will be wrapped
#'   in "Use REPLACE instead." So supply backticks as necessary.
#'
#' `dep_stop()` is for creating an error (i.e. user must fix the problem)
#' `dep_warn()` is for creating a warning (i.e. function will continue)
#'
#' @noRd

dep_stop <- function(when, what = NULL, replace = NULL) {
  msg <- dep(when, what, replace, type = "defunct")
  stop(msg, call. = FALSE)
}

dep_warn <- function(when, what = NULL, replace = NULL) {
  msg <- dep(when, what, replace, type = "deprecated")
  warning(msg, call. = FALSE)
}

dep <- function(when, what, replace, type) {
  fun <- as.character(sys.call(which = sys.parent(n = 2))[1])

  if(!is.null(what)) {
    msg <- paste0("The `", what, "` argument for ")
  } else msg <- ""

  msg <- paste0(msg, "`", fun, "()` is ", type, " as of bbsBayes2 ", when)

  if(!is.null(replace)) msg <- paste0(msg, "\nUse ", replace, " instead.")

  msg
}


# defunct functions ------------------------------------------------------
