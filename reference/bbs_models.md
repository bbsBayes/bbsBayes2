# Stan models included in bbsBayes2

These models are included in bbsBayes2. The model files themselves can
be found in the folder identified by
`system.file("models", package = "bbsBayes2")`. To create a custom Stan
model, see
[`copy_model_file()`](https://bbsbayes.github.io/bbsBayes2/reference/copy_model_file.md)
and the `model_file` argument of
[`prepare_model()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_model.md).
See also the [models
article](https://bbsBayes.github.io/bbsBayes2/articles/models.html) for
more details.

## Usage

``` r
bbs_models
```

## Format

### `bbs_models`

A data frame with 9 rows and 3 columns:

- `model` - Model type

  - `first_diff` - First difference models

  - `gam` - General Additive Models (GAM)

  - `gamye` - General Additive Models (GAM) with Year Effect

  - `slope` - Slope models

- `variant` - Variant of the model to run

  - `nonhier` - Non-hierarchical models (only available for first
    difference models)

  - `hier` - Hierarchical models

  - `spatial` - Spatial models

- `file` - Stan model file name

## Examples

``` r
bbs_models
#> # A tibble: 9 × 3
#>   model      variant file                          
#>   <chr>      <chr>   <chr>                         
#> 1 first_diff nonhier first_diff_nonhier_bbs_CV.stan
#> 2 first_diff hier    first_diff_hier_bbs_CV.stan   
#> 3 first_diff spatial first_diff_spatial_bbs_CV.stan
#> 4 gam        hier    gam_hier_bbs_CV.stan          
#> 5 gam        spatial gam_spatial_bbs_CV.stan       
#> 6 gamye      hier    gamye_hier_bbs_CV.stan        
#> 7 gamye      spatial gamye_spatial_bbs_CV.stan     
#> 8 slope      hier    slope_hier_bbs_CV.stan        
#> 9 slope      spatial slope_spatial_bbs_CV.stan     
```
