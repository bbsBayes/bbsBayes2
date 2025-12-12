# Check whether BBS data exists locally

Use this function to check if you have the BBS data downloaded and where
bbsBayes2 is expecting to find it. If it returns `FALSE`, the data is
not present; use
[`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md)
to retrieve it.

## Usage

``` r
have_bbs_data(level = "state", release = 2025, quiet = FALSE)
```

## Arguments

- level:

  Character. BBS data to check, one of "all", "state", or "stop".
  Default "state".

- release:

  Character/Numeric. BBS data to check, one of "all", or the annual
  releases. Default 2024

- quiet:

  Logical. Suppress progress messages? Default `FALSE`.

## Value

`TRUE` if the data is found, `FALSE` otherwise

## See also

Other BBS data functions:
[`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md),
[`load_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/load_bbs_data.md),
[`remove_cache()`](https://bbsbayes.github.io/bbsBayes2/reference/remove_cache.md)

## Examples

``` r
have_bbs_data()
#> Expected BBS state data 2025: '/home/runner/.local/share/R/bbsBayes2/bbs_state_data_2025.rds'
#> [1] TRUE
have_bbs_data(release = 2020)
#> Expected BBS state data 2020: '/home/runner/.local/share/R/bbsBayes2/bbs_state_data_2020.rds'
#> [1] FALSE
have_bbs_data(release = "all", level = "all")
#> Expected BBS state data 2020: '/home/runner/.local/share/R/bbsBayes2/bbs_state_data_2020.rds'
#> Expected BBS stop data 2022: '/home/runner/.local/share/R/bbsBayes2/bbs_stop_data_2020.rds'
#> Expected BBS state data 2023: '/home/runner/.local/share/R/bbsBayes2/bbs_state_data_2022.rds'
#> Expected BBS stop data 2024: '/home/runner/.local/share/R/bbsBayes2/bbs_stop_data_2022.rds'
#> Expected BBS state data 2025: '/home/runner/.local/share/R/bbsBayes2/bbs_state_data_2023.rds'
#> Expected BBS stop data 2020: '/home/runner/.local/share/R/bbsBayes2/bbs_stop_data_2023.rds'
#> Expected BBS state data 2022: '/home/runner/.local/share/R/bbsBayes2/bbs_state_data_2024.rds'
#> Expected BBS stop data 2023: '/home/runner/.local/share/R/bbsBayes2/bbs_stop_data_2024.rds'
#> Expected BBS state data 2024: '/home/runner/.local/share/R/bbsBayes2/bbs_state_data_2025.rds'
#> Expected BBS stop data 2025: '/home/runner/.local/share/R/bbsBayes2/bbs_stop_data_2025.rds'
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
```
