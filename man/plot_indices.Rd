% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-indices.R
\name{plot_indices}
\alias{plot_indices}
\title{Generate plots of index trajectories by stratum}
\usage{
plot_indices(
  indices = NULL,
  ci_width = 0.95,
  min_year = NULL,
  max_year = NULL,
  title = TRUE,
  title_size = 20,
  axis_title_size = 18,
  axis_text_size = 16,
  line_width = 1,
  spaghetti = FALSE,
  n_spaghetti = 100,
  alpha_spaghetti = 0.2,
  add_observed_means = FALSE,
  add_number_routes = FALSE
)
}
\arguments{
\item{indices}{List. Indices generated by \code{generate_indices()}.}

\item{ci_width}{Numeric. Quantile defining the width of the plotted credible
interval. Defaults to 0.95 (lower = 0.025 and upper = 0.975). Note these
quantiles need to have been precalculated in \code{generate_indices()}.}

\item{min_year}{Numeric. Minimum year to plot.}

\item{max_year}{Numeric. Maximum year to plot.}

\item{title}{Logical. Whether to include a title on the plot.}

\item{title_size}{Numeric. Font size of plot title. Defaults to 20}

\item{axis_title_size}{Numeric. Font size of axis titles. Defaults to 18}

\item{axis_text_size}{Numeric. Font size of axis text. Defaults to 16}

\item{line_width}{Numeric. Size of the trajectory line. Defaults to 1}

\item{spaghetti}{Logical. False by default. Plotting option to visualise the
uncertainty in the estimated population trajectories. Instead of plotting
the trajectory as a single line with an uncertainty bound, if TRUE, then
the plot shows a sample of the posterior distribution of the estimated
population trajectories. E.g., 100 semi-transparent lines, each representing
one posterior draw of the population trajectory.}

\item{n_spaghetti}{Integer. 100 by default. Number of posterior draws of the
population trajectory to include in the plot. Ignored if spaghetti = FALSE.}

\item{alpha_spaghetti}{Numeric between 0 and 1, 0.2 by default. Alpha value - transparency
of each individual population trajectory line in the spaghetti plot.
Ignored if spaghetti = FALSE.}

\item{add_observed_means}{Logical. Whether to include points indicating the
observed mean counts. Default \code{FALSE}. Note: scale of observed means and
annual indices may not match due to imbalanced sampling among routes. Also,
pattern of change in observed means through time should reflect estimated
population trajectories for strata-level summaries. However, the temporal
patterns may be very different between means and annual indices for composite
regions (e.g., continental, state, province, or BCR) because the indices
for composite regions account for the variation in area weights and
variation in relative abundances among strata, and the observed mean counts
do not. For strata-level assessments, these observed means can be a useful
model assessment tool. For composite regions, their interpretation is more
complicated.}

\item{add_number_routes}{Logical. Whether to superimpose dotplot
showing the number of BBS routes included in each year. This is useful as a
visual check on the relative data-density through time because in most
cases the number of observations increases over time.}
}
\value{
List of ggplot2 plots, each item being a plot of a stratum's indices.
}
\description{
Generates the indices plot for each stratum modelled.
}
\examples{
# Using the example model for Pacific Wrens...

# Generate country, continent, and stratum indices
i <- generate_indices(model_output = pacific_wren_model,
                      regions = c("country", "continent", "stratum"))

# Now, plot_indices() will generate a list of plots for all regions
plots <- plot_indices(i)

# To view any plot, use [[i]]
plots[[1]]

names(plots)

# Suppose we wanted to access the continental plot. We could do so with
plots[["continent"]]

# You can specify to only plot a subset of years using min_year and max_year

# Plots indices from 2015 onward
p_2015_min <- plot_indices(i, min_year = 2015)
p_2015_min[["continent"]]

#Plot up indices up to the year 2017
p_2017_max <- plot_indices(i, max_year = 2017)
p_2017_max[["continent"]]

#Plot indices between 2011 and 2016
p_2011_2016 <- plot_indices(i, min_year = 2011, max_year = 2016)
p_2011_2016[["continent"]]

}
\seealso{
Other indices and trends functions: 
\code{\link{generate_indices}()},
\code{\link{generate_trends}()},
\code{\link{plot_geofacet}()},
\code{\link{plot_map}()}
}
\concept{indices and trends functions}
