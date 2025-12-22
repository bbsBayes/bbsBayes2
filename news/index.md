# Changelog

## bbsBayes2 1.1.3.1

- New Stratifications.

1.  `stratify(by = "bcr",...)`: Includes the 2025 version of the North
    American Bird Conservation Regions (BCRs). The changes are primarily
    in Northern Canada, where the largest northern BCRs have been
    subdivided into regions that are more similar in scale to the BCRs
    in the rest of the continent. These new BCRs have replaced the
    previous BCR stratification (i.e., `stratify(by = "bcr",...)` will
    now use this updated BCR map). For reproducibility, the previous BCR
    map is still available by calling `stratify(by = "bcr_old",...)`.

2.  `stratify(by = "bbs",...)`: Intersection of the 2025 updated BCRs
    with states, provinces, and territories in Canada and the United
    States. This stratification is conceptually the same as
    `stratify(by = "bbs_usgs",...)` but uses the updated BCRs.

- Two new arguments in
  [`stratify()`](https://bbsbayes.github.io/bbsBayes2/reference/stratify.md)

1.  `stratify(..., use_map = TRUE)`, the default is TRUE, where the BBS
    routes are stratified based on the spatial overlay
    ([`sf::st_join()`](https://r-spatial.github.io/sf/reference/st_join.html))
    of the strata polygons and the starting locations of each BBS route.
    This spatial overlay approach has always been used for custom
    stratifications, and now is also the default for the standard
    built-in stratifications. In previous versions, the BCR, province,
    state, or lat_long information for each BBS route was taken from the
    columns in the BBS database, so not an explictly spatial process. By
    setting `use_map = FALSE` this previous approach is still available
    for the following stratifications
    `"bcr_old", "bbs_cws", "bbs_usgs", "latlong", "prov_state"`. The new
    stratifications `"bbs" and "bcr"` do not allow `use_map = FALSE`
    (will be changed to TRUE with a message), because the full list of
    new BCRs does not yet exist in the BBS database.

2.  `stratify(..., distance_to_strata)`, optional numerical value
    indicating the distance in meters within which routes will be joined
    to the nearest stratum polygon, if the route start point does not
    intersect any strata. This argument is particularly useful to ensure
    that routes with starting locations on or near the coast or
    shoreline of large lakes are included. These coastal routes may be
    otherwise excluded due to errors in the spatial information (either
    the starting point coordinate or the strata map). For example, the
    map associated with the standard bbs stratification excludes 3,877
    surveys on 72 routes when this argument is NULL. All of these 72
    routes have starting locations on the coasts. Setting this argument
    to 4000 (any route within 4 km of at least one polygon) ensures all
    of these coastal routes are included in the nearest stratum. Users
    should be cautious of using this argument if the strata map does not
    represent the full landmass of Canada and the United States. For
    example using a subset of an existing strata map, such as all of the
    bbs strata within one country will treat routes within the set
    distance of the national border (e.g., some routes in the US as if
    they are in Canada) the same way it treats routes that happen to
    fall just off the coast of the supplied strata map.

## bbsBayes2 1.1.3

- 2025 release. Includes access to the 2025 release of the BBS database
  (observations from 1966 through to 2024).

Some of the key fixes and improvements:

1.  first-difference models (hierarchical and spatial) now better handle
    the missing data from 2020. The models estimate a single value of
    change (i.e., the difference between 2021 and 2019) and then use
    random draws from a beta distribution (beta(1,1)) for each posterior
    draw to randomly partition the difference between the first interval
    (2019-2020) and the second (2020-2021). This has the result of
    forcing the mean trajectory to follow a straight line between 2019
    and 2021, while increasing the uncertainty of the estimated index
    for 2020.

2.  the
    [`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md)
    function now allows the user to retain the BBS observations that do
    not conform to the survey design. The documentation includes
    warnings about how this is probably a bad idea.

3.  all models can now generate prior predictions using
    `prepare_model(..., use_likelihood = FALSE)`. This should be
    particularly useful for applications with a custom model.

4.  the function
    `plot_map(..., col_ebird = TRUE, alternate_column = "percent_change")`
    will plot the estimated percent change values using the same
    categories and colour scheme used by the eBird status and trend
    team.

5.  the function `generate_trends(..., export_full_posterior = TRUE)`
    will now add a tibble to the output list that includes the full
    posterior distribution of every trend estimate. Allows for formal
    tests/estimates of the differences between two trends (e.g., between
    two time-periods or two regions).

## bbsBayes2 1.1.2.1

- minor fixes to bugs in 1.1.2

## bbsBayes2 1.1.2

- 2024 release. Includes access to the 2024 release of the BBS database
  (observations from 1966 through to 2023).

1.  adds options to generate spaghetti plots of population trajectories
    in `plot_indices`. Spaghetti plots show a selection of posterior
    draws of the population trajectories as many distinct lines. These
    lines provide a different way to summarise the uncertainty of the
    population trajectories that separates the uncertainty of the trends
    (shape of the population trajectory) from the uncertainty in the
    mean abundance (vertical placement on the graphs).

2.  adds options to estimate trends from any model using a gam-based
    smooth. The gam_smooths argument in the
    `generate_indices(gam_smooths = TRUE)` function creates an array of
    posterior draws of gam smooths through the population trajectory.
    These posterior draws can be used in the
    `generate_trends(gam = TRUE)` function to estimate trends and their
    uncertainties based on these smooths, for any custom range of dates.
    These smooth trends provide an alternative to the end-point trends
    that are the default in bbsBayes2. If the gam argument is set to
    TRUE, all of the trend and population change calculations are based
    on the posterior array of smooths, rather than the posterior array
    of annual indices. Calculating the smooths in `generate_indices`
    requires significantly more time and so the gam_smooths option is
    set to FALSE by default.

3.  adds informative error messages to: a) identify challenges with
    interpreting the observed annual means relative to estimate
    trajectories for composite regions (all except `stratum`); b)
    identify species and time-periods where analyses may be complicated
    by changes in species taxonomy (see
    [`bbsBayes2::species_notes`](https://bbsbayes.github.io/bbsBayes2/reference/species_notes.md));
    and c) identify when the strata_custom optional `sf` object passed
    to `stratify` does not have the correct crs and strata_name column
    type.

4.  `prepare_data` now exports columns including latitude and longitude
    of each BBS route start-location in the `raw_data` component of the
    output list.

5.  fix a number of errors and issues identified in version 1.1.1.

## bbsBayes2 1.1.1

1.1.1 represents a patch to correct some failing checks and tests in
1.1.0, and includes all of the functionality of the 1.1.0 release.

## bbsBayes2 1.1.0

- Second release. Includes access to the 2023 release of the BBS
  database. Also includes improvements to the management of the csv
  files created by Stan, increased ability to map values from
  [`generate_trends()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_trends.md),
  tweaks to the first_diff models to better handle the missing data in
  2020 (when no BBS surveys were conducted), and options to use highest
  posterior density intervals (hpdi) to describe the posterior
  distribution in
  [`generate_indices()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_indices.md)
  and
  [`generate_trends()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_trends.md).

More specifically, to support version 1.1.0, the following changes were
made:

1.  adds some tweaks to the first_difference, spatial model to force 0
    spatial variance in 2020 - the year when the BBS was cancelled and
    so there are no data and therefore no information with which to
    meaningfully estimate the variance in annual differences among
    strata.

2.  allows the
    [`plot_map()`](https://bbsbayes.github.io/bbsBayes2/reference/plot_map.md)
    function to plot any of the numerical values in the output from
    [`generate_trends()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_trends.md).
    e.g., to display trend uncertainty by plotting the credible limits
    or width of the credible intervals of the trend estimates, or to
    display the mean relative abundance among strata during the trend
    period. Example added to the Advanced Vignette.

3.  package can access the newest database release to include field
    observations from 1966 - 2022.

4.  allows for the use of highest posterior density intervals in the
    [`generate_indices()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_indices.md)
    and
    [`generate_trends()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_trends.md)
    functions. HPDI often provide a better description of the posterior
    distribution, particularly for skewed distributions, such as those
    from a log-transformed predicted count (i.e., the indices of annual
    relative abundance). Example added to the Advanced Vignette.

5.  [`run_model()`](https://bbsbayes.github.io/bbsBayes2/reference/run_model.md)
    function by default now cleans up the .csv files created by Stan,
    once the model has finished and has been saved to .rds file (also
    done by default). Saves local disk space, as once the model output
    is saved in the rds file, the csv files are redundant.

## bbsBayes2 1.0.0

- First release of bbsBayes2, the successor to bbsBayes!
