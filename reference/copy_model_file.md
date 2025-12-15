# Copy model file

Save a predefined Stan model file to a local text file for editing.
These files can then be used in
[`prepare_model()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_model.md)
by specifying the `model_file` argument.

## Usage

``` r
copy_model_file(model, model_variant, dir, overwrite = FALSE)
```

## Arguments

- model:

  Character. Type of model to use, must be one of "first_diff" (First
  Differences), "gam" (General Additive Model), "gamye" (General
  Additive Model with Year Effect), or "slope" (Slope model).

- model_variant:

  Character. Model variant to use, must be one of "nonhier"
  (Non-hierarchical), "hier" (Hierarchical; default), or "spatial"
  (Spatially explicit).

- dir:

  Character. Directory where file should be saved.

- overwrite:

  Logical. Whether to overwrite an existing copy of the model file.

## Value

File path to copy of the new model file.

## See also

Other modelling functions:
[`run_model()`](https://bbsbayes.github.io/bbsBayes2/reference/run_model.md),
[`save_model_run()`](https://bbsbayes.github.io/bbsBayes2/reference/save_model_run.md)

## Examples

``` r
# Save the Slope model in temp directory
copy_model_file(model = "slope", model_variant = "spatial", dir = tempdir())
#> Copying model file slope_spatial_bbs_CV.stan to /tmp/RtmpmYARGU/slope_spatial_bbs_CV_COPY.stan
#> [1] "/tmp/RtmpmYARGU/slope_spatial_bbs_CV_COPY.stan"

# Overwrite an existing copy
copy_model_file(model = "slope", model_variant = "spatial", dir = tempdir(),
                overwrite = TRUE)
#> Copying model file slope_spatial_bbs_CV.stan to /tmp/RtmpmYARGU/slope_spatial_bbs_CV_COPY.stan
#> [1] "/tmp/RtmpmYARGU/slope_spatial_bbs_CV_COPY.stan"

# Clean up
unlink(file.path(tempdir(), "slope_spatial_bbs_CV_COPY.stan"))
```
