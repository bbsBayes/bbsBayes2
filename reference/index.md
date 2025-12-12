# Package index

## BBS Data

Functions for downloading and managing BBS data

- [`fetch_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/fetch_bbs_data.md)
  : Fetch Breeding Bird Survey dataset
- [`have_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/have_bbs_data.md)
  : Check whether BBS data exists locally
- [`load_bbs_data()`](https://bbsbayes.github.io/bbsBayes2/reference/load_bbs_data.md)
  : Load Breeding Bird Survey data
- [`remove_cache()`](https://bbsbayes.github.io/bbsBayes2/reference/remove_cache.md)
  : Remove bbsBayes2 cache

## Processing data

Functions for processing BBS data according to the type of models to be
run

- [`stratify()`](https://bbsbayes.github.io/bbsBayes2/reference/stratify.md)
  : Stratify and filter Breeding Bird Survey data
- [`prepare_data()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_data.md)
  : Filter for data quality
- [`prepare_spatial()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_spatial.md)
  : Define neighbouring strata for spatial analyses
- [`prepare_model()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_model.md)
  : Prepare model parameters

## Stan models

Functions for running Stan models via cmdstanr, as well as for saving
and evaluating convergence

- [`run_model()`](https://bbsbayes.github.io/bbsBayes2/reference/run_model.md)
  : Run Bayesian model

- [`save_model_run()`](https://bbsbayes.github.io/bbsBayes2/reference/save_model_run.md)
  : Save output of run_model()

- [`copy_model_file()`](https://bbsbayes.github.io/bbsBayes2/reference/copy_model_file.md)
  : Copy model file

- [`get_convergence()`](https://bbsbayes.github.io/bbsBayes2/reference/get_convergence.md)
  : Convergence metrics

- [`get_model_vars()`](https://bbsbayes.github.io/bbsBayes2/reference/get_model_vars.md)
  : Get model variables

- [`get_summary()`](https://bbsbayes.github.io/bbsBayes2/reference/get_summary.md)
  :

  Return the `cmdstanr` summary

- [`have_cmdstan()`](https://bbsbayes.github.io/bbsBayes2/reference/have_cmdstan.md)
  : Check if cmdstan is installed

## Indices and trends

Functions for generating indices and trends from models

- [`generate_indices()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_indices.md)
  : Regional annual indices of abundance
- [`generate_trends()`](https://bbsbayes.github.io/bbsBayes2/reference/generate_trends.md)
  : Generate regional trends

## Plots

Functions for plotting indices and trends

- [`plot_map()`](https://bbsbayes.github.io/bbsBayes2/reference/plot_map.md)
  : Generate a map of trends by strata
- [`plot_indices()`](https://bbsbayes.github.io/bbsBayes2/reference/plot_indices.md)
  : Generate plots of index trajectories by stratum
- [`plot_geofacet()`](https://bbsbayes.github.io/bbsBayes2/reference/plot_geofacet.md)
  : Create geofacet plot of population trajectories by province/state

## Helper functions

- [`search_species()`](https://bbsbayes.github.io/bbsBayes2/reference/search_species.md)
  : Search for species
- [`load_map()`](https://bbsbayes.github.io/bbsBayes2/reference/load_map.md)
  : Load a geographic strata map
- [`assign_prov_state()`](https://bbsbayes.github.io/bbsBayes2/reference/assign_prov_state.md)
  : Categorize polygon by Province/State

## Included data

- [`bbs_data_sample`](https://bbsbayes.github.io/bbsBayes2/reference/bbs_data_sample.md)
  : Sample BBS data
- [`bbs_strata`](https://bbsbayes.github.io/bbsBayes2/reference/bbs_strata.md)
  : List of included strata
- [`bbs_models`](https://bbsbayes.github.io/bbsBayes2/reference/bbs_models.md)
  : Stan models included in bbsBayes2
- [`pacific_wren_model`](https://bbsbayes.github.io/bbsBayes2/reference/pacific_wren_model.md)
  : Example model output
- [`species_forms`](https://bbsbayes.github.io/bbsBayes2/reference/species_forms.md)
  : Species forms
- [`species_notes`](https://bbsbayes.github.io/bbsBayes2/reference/species_notes.md)
  : Species notes
- [`equal_area_crs`](https://bbsbayes.github.io/bbsBayes2/reference/equal_area_crs.md)
  : equal_area_crs

## Deprecated/Defunct functions

- [`bbsBayes2-defunct`](https://bbsbayes.github.io/bbsBayes2/reference/bbsBayes2-defunct.md)
  : bbsBayes2 defunct functions
- [`bbsBayes2-deprecated`](https://bbsbayes.github.io/bbsBayes2/reference/bbsBayes2-deprecated.md)
  : bbsBayes2 deprecated functions
