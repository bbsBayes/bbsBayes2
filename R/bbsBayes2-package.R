#' @keywords internal
"_PACKAGE"

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "bbsBayes2 v", utils::packageVersion("bbsBayes2"), "\n",
    "Note: This is the successor to bbsBayes with a major shift in functionality, noteably:\n",
    " - The Bayesian modelling engine has switched from *JAGS* to *Stan*\n",
    " - The workflow has been streamlined, resulting in new functions/arguments\n",
    "See the documentation for more details: ",
    "https://bbsBayes.github.io/bbsBayes2"
    )
}


# Dealing with CRAN Notes due to Non-standard evaluation
.onLoad <- function(libname = find.package("bbsBayes2"),
                    pkgname = "bbsBayes2"){
  if(getRversion() >= "2.15.1")
    utils::globalVariables(
      # Vars used in Non-Standard Evaluations, declare here to
      # avoid CRAN warnings
      c("." # piping requires '.' at times
      )
    )
  backports::import(pkgname, "R_user_dir", force = TRUE)
}
