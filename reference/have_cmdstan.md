# Check if cmdstan is installed

Wrapper around `cmdstanr::cmdstan_version(error_on_NA = FALSE)` for
quick check.

## Usage

``` r
have_cmdstan()
```

## Details

Used internally for skipping examples and tests if no cmdstan installed.
