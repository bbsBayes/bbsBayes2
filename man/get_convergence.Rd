% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convergence.R
\name{get_convergence}
\alias{get_convergence}
\title{Convergence metrics}
\usage{
get_convergence(model_output, variables = NULL)
}
\arguments{
\item{model_output}{List. Model output generated by \code{run_model()}.}

\item{variables}{Character vector. Specific variables (e.g.,
\code{"strata_raw[1]"}) or variable types (e.g., \code{"strata_raw"}) for which to
calculate metrics. If \code{NULL} (default) all variables are returned.}
}
\value{
Data frame of convergence metrics for all model variables. Contains
\code{variable_type}, \code{variable}, \code{ess_bulk}, \code{ess_tail}, and \code{rhat}.
}
\description{
Calculate convergence metrics for the model run. Specifically calculates bulk
and tail effective sample sizes (ess_bulk, ess_tail) and R-hat (\code{rhat}).
Returns output very similar to \code{get_summary()}.
}
\examples{
# Temporarily suppress convergence warning for legibility
# "The ESS has been capped to avoid unstable estimates."
opts <- options(warn = -1)

# Using the example model for Pacific Wrens

get_convergence(pacific_wren_model)
get_convergence(pacific_wren_model, variables = "strata_raw")
get_convergence(pacific_wren_model, variables = "strata_raw[9]")

# Restore warnings
options(opts)
}
\seealso{
Other model assessment functions: 
\code{\link{get_model_vars}()},
\code{\link{get_summary}()}
}
\concept{model assessment functions}
