# Remove bbsBayes2 cache

Remove all or some of the data downloaded via
[`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md)
as well as model executables created by
[`cmdstanr::cmdstan_model()`](https://mc-stan.org/cmdstanr/reference/cmdstan_model.html)
via
[`run_model()`](https://bbsbayes.github.io/bbsBayes2/reference/run_model.md).

## Usage

``` r
remove_cache(type = "bbs_data", level = "all", release = "all")
```

## Arguments

- type:

  Character. Which cached data to remove. One of "all", "bbs_data", or
  "models". If "all", removes entire cache directory (and all data
  contained therein). If "bbs_data", removes only BBS data downloaded
  with
  [`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md).
  If "models", removes only model executables compiled when
  `run_models()` is run.

- level:

  Character. BBS data to remove, one of "all", "state", or "stop". Only
  applies if `type = "bbs_data"`. Default "all".

- release:

  Character/Numeric. BBS data to remove, one of "all", 2020, 2022, 2024,
  or 2024. Only applies if `type = "bbs_data"`. Default "all".

## Value

Nothing

## See also

Other BBS data functions:
[`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md),
[`have_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/have_bbs_data.md),
[`load_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/load_bbs_data.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Remove everything
remove_cache(type = "all")

# Remove all BBS data files (but not the dir)
remove_cache(level = "all", release = "all")

# Remove all 'stop' data
remove_cache(level = "stop", release = "all")

# Remove all 2020 data
remove_cache(level = "all", release = 2020)

# Remove 2020 stop data
remove_cache(level = "stop", release = 2020)

# Remove all model executables
remove_cache(type = "model")
} # }
```
