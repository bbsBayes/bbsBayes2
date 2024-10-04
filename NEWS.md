---
editor_options: 
  markdown: 
    wrap: sentence
---

# bbsBayes2 1.1.2

-   2024 release. Includes access to the 2024 release of the BBS database (observations from 1966 through to 2023). 

1.  adds options to generate spaghetti plots of population trajectories in `plot_indices`. Spaghetti plots show a selection of posterior draws of the population trajectories as many distinct lines. These lines provide a different way to summarise the uncertainty of the population trajectories that separates the uncertainty of the trends (shape of the population trajectory) from the uncertainty in the mean abundance (vertical placement on the graphs).

2.  adds options to estimate trends from any model using a gam-based smooth. The gam_smooths argument in the `generate_indices(gam_smooths = TRUE)` function creates an array of posterior draws of gam smooths through the population trajectory. These posterior draws can be used in the `generate_trends(gam = TRUE)` function to estimate trends and their uncertainties based on these smooths, for any custom range of dates. These smooth trends provide an alternative to the end-point trends that are the default in bbsBayes2. If the gam argument is set to TRUE, all of the trend and population change calculations are based on the posterior array of smooths, rather than the posterior array of annual indices. Calculating the smooths in `generate_indices` requires significantly more time and so the gam_smooths option is set to FALSE by default.

3.  adds informative error messages to: a) identify challenges with interpreting the observed annual means relative to estimate trajectories for composite regions (all except `stratum`); b) identify species and time-periods where analyses may be complicated by changes in species taxonomy (see `bbsBayes2::species_notes`); and c) identify when the strata_custom optional `sf` object passed to `stratify` does not have the correct crs and strata_name column type. 

4.  `prepare_data` now exports columns including latitude and longitude of each BBS route start-location in the `raw_data` component of the output list.

5.  fix a number of errors and issues identified in version 1.1.1.

# bbsBayes2 1.1.1

1.1.1 represents a patch to correct some failing checks and tests in 1.1.0, and includes all of the functionality of the 1.1.0 release.

# bbsBayes2 1.1.0

-   Second release. Includes access to the 2023 release of the BBS database. Also includes improvements to the management of the csv files created by Stan, increased ability to map values from `generate_trends()`, tweaks to the first_diff models to better handle the missing data in 2020 (when no BBS surveys were conducted), and options to use highest posterior density intervals (hpdi) to describe the posterior distribution in `generate_indices()` and `generate_trends()`.

More specifically, to support version 1.1.0, the following changes were made:

1.  adds some tweaks to the first_difference, spatial model to force 0 spatial variance in 2020 - the year when the BBS was cancelled and so there are no data and therefore no information with which to meaningfully estimate the variance in annual differences among strata.

2.  allows the `plot_map()` function to plot any of the numerical values in the output from `generate_trends()`.
    e.g., to display trend uncertainty by plotting the credible limits or width of the credible intervals of the trend estimates, or to display the mean relative abundance among strata during the trend period.
    Example added to the Advanced Vignette.

3.  package can access the newest database release to include field observations from 1966 - 2022.

4.  allows for the use of highest posterior density intervals in the `generate_indices()` and `generate_trends()` functions.
    HPDI often provide a better description of the posterior distribution, particularly for skewed distributions, such as those from a log-transformed predicted count (i.e., the indices of annual relative abundance).
    Example added to the Advanced Vignette.

5.  `run_model()` function by default now cleans up the .csv files created by Stan, once the model has finished and has been saved to .rds file (also done by default).
    Saves local disk space, as once the model output is saved in the rds file, the csv files are redundant.

# bbsBayes2 1.0.0

-   First release of bbsBayes2, the successor to bbsBayes!
