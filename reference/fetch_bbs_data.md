# Fetch Breeding Bird Survey dataset

Fetch and download Breeding Bird Survey data from the United States
Geological Survey (USGS) FTP site. This is the raw data that is uploaded
to the site before any analyses are performed. Users can download
different types (`state`, `stop`) and different releases (currently
`2020`, `2022`, `2023`, `2024`, and `2025`).

## Usage

``` r
fetch_bbs_data(
  level = "state",
  release = 2025,
  force = FALSE,
  quiet = FALSE,
  compression = "none",
  include_unacceptable = FALSE
)
```

## Arguments

- level:

  Character. Which type of BBS counts to use, "state" or "stop". Default
  "state".

- release:

  Numeric. Which yearly release to use, 2022 (including data through
  2021 field season) or 2020 (including data through 2019). Default
  2022.

- force:

  Logical. Should pre-exising BBS data be overwritten? Default FALSE.

- quiet:

  Logical. Suppress progress messages? Default `FALSE`.

- compression:

  Character. What compression should be used to save data? Default is
  `none` which takes up the most space but is the fastest to load. Must
  be one of `none`, `gz`, `bz2`, or `xz` (passed to
  [`readr::write_rds()`](https://readr.tidyverse.org/reference/read_rds.html)'s
  `compress` argument).

- include_unacceptable:

  Logical. DO NOT change this unless you are very confident that you
  want these data. Should the package retain the BBS data collected on
  non-standard BBS routes (including some with fewer than 50 stops), or
  outside of the acceptable weather, season, and times-of-day structure
  of the BBS survey design. Default FALSE for good reason. If you change
  this to TRUE and thereby decide you want to include the BBS data that
  do not fit the BBS structured survey design, be sure you understand
  the information in at least the following columns of the route survey
  info: RouteTypeID, RouteTypeDetailID, RPID, RunType, and the rest of
  the information in the data release meta data.

## Details

Users will be asked before saving the BBS data to a package-specific
directory created on their computer. Before downloading any data, users
must thoroughly read through the USGS terms and conditions for that data
and enter the word "yes" to agree.

BBS `state` level counts provide counts beginning in 1966, aggregated in
five bins, each of which contains cumulative counts from 10 of the 50
stops along a route. In contrast, BBS `stop` level counts provides
stop-level data beginning in 1997, which includes counts for each
individual stop along routes. **Note that stop-level data is not
currently supported by the modelling utilities in bbsBayes2.**

There are multiple releases for each type of data, `2020`, `2022`,
`2023`, `2024` and `2025`. By default all functions use the most recent
release unless otherwise specified. For example, the `release` argument
in
[`stratify()`](https://bbsbayes.github.io/bbsBayes2/reference/stratify.md)
can be changed to `2020` to use the 2020 release of state-level counts.

bbsBayes2 by default removes observations from routes that were not
established following the stratified random design, the handful of
routes that are on water (not on roadsides), and any survey that was not
conducted within acceptable survey conditions (high winds, heavy
precipitation, outside of the acceptable time windows).

## See also

Other BBS data functions:
[`have_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/have_bbs_data.md),
[`load_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/load_bbs_data.md),
[`remove_cache()`](https://bbsbayes.github.io/bbsBayes2/reference/remove_cache.md)

## Examples

``` r
if (FALSE) { # interactive()

fetch_bbs_data(force = TRUE)
fetch_bbs_data(level = "stop", force = TRUE)
fetch_bbs_data(release = 2020, force = TRUE)
fetch_bbs_data(release = 2020, level = "stop", force = TRUE)
}
```
