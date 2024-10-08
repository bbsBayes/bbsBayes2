% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch-bbs-data.R
\name{have_bbs_data}
\alias{have_bbs_data}
\title{Check whether BBS data exists locally}
\usage{
have_bbs_data(level = "state", release = 2024, quiet = FALSE)
}
\arguments{
\item{level}{Character. BBS data to check, one of "all", "state", or "stop".
Default "state".}

\item{release}{Character/Numeric. BBS data to check, one of "all", or the
annual releases. Default 2024}

\item{quiet}{Logical. Suppress progress messages? Default \code{FALSE}.}
}
\value{
\code{TRUE} if the data is found, \code{FALSE} otherwise
}
\description{
Use this function to check if you have the BBS data downloaded and where
bbsBayes2 is expecting to find it. If it returns \code{FALSE}, the data is not
present; use \code{fetch_bbs_data()} to retrieve it.
}
\examples{
have_bbs_data()
have_bbs_data(release = 2020)
have_bbs_data(release = "all", level = "all")
}
\seealso{
Other BBS data functions: 
\code{\link{fetch_bbs_data}()},
\code{\link{load_bbs_data}()},
\code{\link{remove_cache}()}
}
\concept{BBS data functions}
