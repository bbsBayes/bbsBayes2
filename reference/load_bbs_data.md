# Load Breeding Bird Survey data

Load the local, minimally processed, raw, unstratified data. The data
must have been previously fetched using
[`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md).
This function is provided for custom explorations and is not part of the
analysis workflow;
[`stratify()`](https://bbsbayes.github.io/bbsBayes2/reference/stratify.md)
will do the loading for you.

## Usage

``` r
load_bbs_data(level = "state", release = 2025, sample = FALSE, quiet = TRUE)
```

## Arguments

- level:

  Character. Which type of BBS counts to use, "state" or "stop". Default
  "state".

- release:

  Numeric. Which yearly release to use, 2022 (including data through
  2021 field season) or 2020 (including data through 2019). Default
  2022.

- sample:

  Logical. Whether or not to use the sample data for Pacific Wrens (see
  ?bbs_data_sample). Default is `FALSE`. If `TRUE`, `level` and
  `release` are ignored.

- quiet:

  Logical. Suppress progress messages? Default `FALSE`.

## Value

Large list (3 elements) consisting of:

- birds:

  Data frame of sample bird point count data per route, per year

- routes:

  Data frame of sample yearly route data

- species:

  Sample list of North American bird species

## See also

Other BBS data functions:
[`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md),
[`have_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/have_bbs_data.md),
[`remove_cache()`](https://bbsbayes.github.io/bbsBayes2/reference/remove_cache.md)
