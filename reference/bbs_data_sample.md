# Sample BBS data

Contains only Pacific Wren data

## Usage

``` r
bbs_data_sample
```

## Format

### `bbs_data_sample`

A list containing:

- `birds` - counts of each bird seen per route per

- `routes` - data for each route run per year

- `species` - species list of North America

## Source

<https://www.sciencebase.gov/> via
[`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md)

## Details

A sample dataset containing only data for Pacific Wrens for the 2025
state-level BBS data. The full count set is obtained via the function
`fetch_bbs_data(release = 2025)`. The data are obtained from the BBS
database and is subject to change as new data are added each year. See
References for citation.

## References

Ziolkowski Jr., D.J., Lutmerding, M., Skalos, S.M., English, W.B., and
Hudson, M-A.R., 2025, North American Breeding Bird Survey Dataset 1966 -
2024: U.S. Geological Survey data release,
https://doi.org/10.5066/P14SNUV4.
