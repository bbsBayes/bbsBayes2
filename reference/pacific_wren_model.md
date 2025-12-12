# Example model output

Example model output from running a hierarchical first difference model
on the included sample data for Pacific Wrens.

## Usage

``` r
pacific_wren_model
```

## Format

### `pacific_wren_model`

A list output from
[`run_model()`](https://bbsbayes.github.io/bbsBayes2/reference/run_model.md)
with 4 items

- `model_fit` - cmdstanr model output

- `model_data` - list of data formatted for use in Stan modelling

- `meta_data` - meta data defining the analysis

- `meta_strata` - data frame listing strata meta data

- `raw_data` - data frame of summarized counts

## Examples

``` r
# Code to replicate:
if (FALSE) { # \dontrun{
pacific_wren_model <- stratify(by = "bbs_cws", sample_data = TRUE) %>%
  prepare_data() %>%
  prepare_model(model = "first_diff", set_seed = 111) %>%
  run_model(chains = 2, iter_sampling = 20, iter_warmup = 20, set_seed = 111)
} # }
```
