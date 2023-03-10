% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{search_species}
\alias{search_species}
\title{Search for species}
\usage{
search_species(species, combine_species_forms = TRUE)
}
\arguments{
\item{species}{Character/Numeric. Search term, either name in English or
French, AOU code, or scientific genus or species. Matches by regular
expression but ignores case.}

\item{combine_species_forms}{Logical. Whether or not to search the combined
species data or the uncombined species. Note that this results in different
species names.}
}
\value{
Subset of the BBS species data frame matching the species pattern.
}
\description{
A helper function for finding the appropriate species name for use in
\code{stratify()}.
}
\examples{
\dontshow{if (have_bbs_data()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# Search for various terms
search_species("Paridae")
search_species("chickadee")
search_species("mésang")
search_species("Poecile")
search_species(7360)
search_species(73)
search_species("^73") # Use regex to match aou codes starting with 73
search_species("blue grouse")
search_species("sooty grouse")

# To combine or not
search_species("blue grouse", combine_species_forms = FALSE)
search_species("sooty grouse", combine_species_forms = FALSE)
search_species("northern flicker")
search_species("northern flicker", combine_species_forms = FALSE)
\dontshow{\}) # examplesIf}
}
\seealso{
Other helper functions: 
\code{\link{assign_prov_state}()},
\code{\link{load_map}()}
}
\concept{helper functions}
