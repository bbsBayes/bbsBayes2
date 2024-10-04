#' Run Bayesian model
#'
#' Run Bayesian model with `cmdstandr::sample()`using prepare data and model
#' parameters specified in previous steps.
#'
#' @param refresh Numeric. Passed to `cmdstanr::sample()`. Number of iterations
#'   between screen updates. If 0, only errors are shown.
#' @param chains Numeric. Passed to `cmdstanr::sample()`. Number of Markov
#'   chains to run.
#' @param parallel_chains Numeric. Passed to `cmdstanr::sample()`. Maximum
#'   number of chains to run in parallel.
#' @param iter_warmup Numeric. Passed to `cmdstanr::sample()`. Number of warmup
#'   iterations per chain.
#' @param iter_sampling Numeric. Passed to `cmdstanr::sample()`. Number of
#'   sampling (post-warmup) iterations per chain.
#' @param adapt_delta Numeric. Passed to `cmdstanr::sample()`. The adaptation
#'   target acceptance statistic.
#' @param max_treedepth Numeric. Passed to `cmdstanr::sample()`. The maximum
#'   allowed tree depth for the NUTS engine. See `?cmdstanr::sample`.
#' @param k Numeric. The K-fold group to run for cross-validation. Only relevant
#'   if folds defined by `prepare_model(calculate_cv = TRUE)` or custom
#'   definition. See `?prepare_model` or the [models
#'   article](https://bbsBayes.github.io/bbsBayes2/articles/models.html) for more
#'   details.
#' @param output_basename Character. Name of the files created as part of the
#'   Stan model run and the final model output RDS file if `save_model = TRUE`.
#'   Defaults to a character string that is unique to the species, model,
#'   model_variant, and system time of `model_run()` call (nearest minute).
#' @param output_dir Character. Directory in which all model files will be
#'   created. Defaults to the working directory, but recommend that the user
#'   sets this to a particular existing directory for better file organization.
#' @param overwrite Logical. Whether to overwrite an existing model output file
#'   when saving.
#' @param save_model Logical. Whether or not to save the model output to file
#'   as an RDS object with all required data. Defaults to `TRUE`.
#' @param retain_csv Logical. Whether to retain the Stan csv files after the
#'   model has finished running and the fitted object has been saved.
#'   Defaults to `FALSE` because csv files duplicate information saved in
#'   the model output file save object, when `save_model = TRUE`, and so for
#'   file organization and efficient use of memory, these are deleted
#'   by default.
#' @param show_exceptions Logical.  Passed to `cmdstanr::sample()`.
#'   Defaults to FALSE. When TRUE, prints all informational messages from Stan,
#'   for example rejection of the current proposal. Disabled by default in
#'   bbsBayes2, because of the copious informational messages during the
#'   initialization period that have no bearing on model fit. If fitting a
#'   custom model, recommend setting this to TRUE.
#' @param init_alternate Passed to `init` argument in `cmdstanr::sample()`.
#'   Replaces the initial values in the `model_data[["init_values"]]` created
#'   by prepare_model. Should accept any of the acceptable approaches to setting
#'   inits argment in `?cmdstanr::sample`.
#' @param ... Other arguments passed on to `cmdstanr::sample()`.
#'
#' @inheritParams common_docs
#' @family modelling functions
#'
#' @details The model is set up in `prepare_model()`. The `run_model()` function
#' does the final (and often long-running) step of actually running the model.
#' Here is where you can tweak how the model will be run (iterations etc.).
#'
#' See the [models
#' article](https://bbsBayes.github.io/bbsBayes2/articles/models.html) for more
#' advanced examples and explanations.
#'
#' @return List model fit and other (meta) data.
#'   - `model_fit` - cmdstanr model output
#'   - `model_data` - list of data formatted for use in Stan modelling
#'   - `meta_data` - meta data defining the analysis
#'   - `meta_strata` - data frame listing strata meta data
#'   - `raw_data` - data frame of summarized counts
#'
#' @export
#'
#' @examplesIf have_cmdstan()
#' s <- stratify(by = "bbs_cws", sample_data = TRUE)
#' p <- prepare_data(s)
#' pm <- prepare_model(p, model = "first_diff", model_variant = "hier")
#'
#' # Run model (quick and dirty)
#' m <- run_model(pm, iter_warmup = 20, iter_sampling = 20, chains = 2)
#'

run_model <- function(model_data,
                      refresh = 100,
                      chains = 4,
                      parallel_chains = 4,
                      iter_warmup = 1000,
                      iter_sampling = 1000,
                      adapt_delta = 0.8,
                      max_treedepth = 11,
                      k = NULL,
                      output_basename = NULL,
                      output_dir = ".",
                      save_model = TRUE,
                      overwrite = FALSE,
                      retain_csv = FALSE,
                      set_seed = NULL,
                      quiet = FALSE,
                      show_exceptions = FALSE,
                      init_alternate = NULL,
                      ...) {

  # Check inputs
  check_data(model_data)
  check_logical(save_model, retain_csv, overwrite, quiet)
  check_numeric(refresh, chains, parallel_chains, iter_sampling, iter_warmup,
                adapt_delta, max_treedepth)

  meta_data <- model_data[["meta_data"]]
  raw_data <- model_data[["raw_data"]]
  meta_strata <- model_data[["meta_strata"]]

  if(!is.null(init_alternate)){
    init_values <- init_alternate
  }else{
  init_values <- model_data[["init_values"]]
  }
  folds <- model_data[["folds"]]
  model_data <- model_data[["model_data"]]

  if(model_data$n_strata < 2){
    stop("The data have only 1 stratum. bbsBayes2 models require multiple strata.
         If there are sufficient routes with data, you can try an alternate stratification
         (e.g., latlong) where the routes may be redistributed among > 1 strata.")
  }

  species <- stringr::str_remove_all(meta_data[["species"]],
                                      "[^[[:alpha:]]]")

  # Files and directory
  check_dir(output_dir)
  output_basename <- check_file(output_basename,
                                species,
                                meta_data[["model"]],
                                meta_data[["model_variant"]])

  # Keep track of data
  meta_data <- append(
    meta_data,
    list("run_date" = Sys.time(),
         "bbsBayes2_version" = as.character(utils::packageVersion("bbsBayes2")),
         "cmdstan_path" = cmdstanr::cmdstan_path(),
         "cmdstan_version" = cmdstanr::cmdstan_version()))

  # Check init values
  init_values <- check_init(init_values, chains)

  # Setup cross validation
  if(!is.null(k)) {
    check_cv(folds, k)

    model_data[["test"]] <- which(folds == k)
    model_data[["train"]] <- which(folds != k)
    model_data[["n_test"]] <- length(model_data[["test"]])
    model_data[["n_train"]] <- length(model_data[["train"]])
    model_data[["calc_CV"]] <- 1

    meta_data <- append(meta_data, list("k" = k))
    output_basename <- paste0(output_basename, "_k", k)

  } else {
    model_data[["test"]] <- 1L
    model_data[["train"]] <- as.integer(1:model_data[["n_counts"]])
    model_data[["n_test"]] <- 1L
    model_data[["n_train"]] <- model_data[["n_counts"]]
    model_data[["calc_CV"]] <- 0
  }

  # Check if overwriting and warn if overwriting existing csv files
  if(save_model & !overwrite & file.exists(paste0(output_basename, ".rds"))){
    stop("File ", output_basename, ".rds already exists. Either choose a new ",
         "basename, or specify `overwrite = TRUE`", call. = FALSE)
  }
  if(!overwrite & file.exists(paste0(output_basename, "-1.csv"))){
    stop("CSV files ", output_basename, " already exist. Either choose a new ",
         "basename, or specify `overwrite = TRUE` ",
         "Never run two models with the same output_basename at the same time. ",
         "Doing so will cause both models to fail when they try to write output ",
         "to the same csv files.", call. = FALSE)
  }
  if(file.exists(paste0(output_basename, "-1.csv"))){
    warning("CSV files ", output_basename, " already exist. `overwrite = TRUE`",
            " so previous files have been overwritten.",
         "Never run two models with the same output_basename at the same time. ",
         "Doing so will cause both models to fail when they try to write output ",
         "to the same csv files.", call. = FALSE)
  }

  # Compile model
  model <- cmdstanr::cmdstan_model(meta_data[["model_file"]], dir = bbs_dir())


  # Run model
  if(!is.null(set_seed)) withr::local_seed(set_seed)
  model_fit <- model$sample(
    data = model_data,
    refresh = refresh,
    chains = chains,
    iter_sampling = iter_sampling,
    iter_warmup = iter_warmup,
    parallel_chains = parallel_chains,
    adapt_delta = adapt_delta,
    max_treedepth = max_treedepth,
    init = init_values,
    output_dir = output_dir,
    output_basename = output_basename,
    show_exceptions = show_exceptions,
    ...)

  model_output <- list("model_fit" = model_fit,
                       "model_data" = model_data,
                       "meta_data" = meta_data,
                       "meta_strata" = meta_strata,
                       "raw_data" = raw_data)

  if(save_model) save_model_run(model_output, retain_csv)

  model_output
}

#' Save output of run_model()
#'
#' This function closely imitates `cmdstanr::save_object()` but saves the
#' entire model output object from `run_model()` which contains more details
#' regarding data preparation (stratification etc.).
#'
#' Files are saved to `path`, or if not provided, to the original location of
#' the Stan model run files (if the original files exist).
#'
#' @param path Character. Optional file path to use for saved data. Defaults to
#' the file path used for the original run.
#' @param retain_csv Logical Should the Stan csv files be retained. Defaults to
#' TRUE if user calls function directly. However, when this function is called
#' internally by `run_model` this is set to FALSE.
#'
#' @inheritParams common_docs
#' @family modelling functions
#'
#' @return Nothing. Creates an `.rds` file at `path`.
#' @export
#'
#' @examples
#' # By default, the model is saved as an RDS file during `run_model()`
#'
#' # But you can also deliberately save the file (here with an example model)
#' save_model_run(pacific_wren_model, path = "my_model.rds")
#'
#' # Clean up
#' unlink("my_model.rds")

save_model_run <- function(model_output,
                           retain_csv = TRUE, path = NULL, quiet = FALSE,
                           save_file_path = NULL) {

  check_data(model_output)
  check_logical(retain_csv,quiet)

  model_fit <- model_output$model_fit

  if(is.null(path)) {
    #if(!retain_csv){
    csv_path <- model_fit$output_files()
    if(any(!file.exists(csv_path))) {
      stop("Cannot find original model file location, please specify `path`",
           call. = FALSE)
    }
    #}

    path <- csv_path %>%
      normalizePath() %>%
      stringr::str_remove("-[0-9]{1,3}.csv$") %>%
      unique() %>%
      paste0(".rds")

    if(is.null(save_file_path)){
      save_file_path <- path
    }else{
      check_dir(dirname(save_file_path))
      if(ext(path) != "rds") {
        stop("save_file_path must have a .rds extension", call. = FALSE)
      }
    }

    if(!quiet) message("Saving model output to ", save_file_path)
  } else {

    check_dir(dirname(save_file_path))
    if(ext(path) != "rds") {
      stop("save_file_path must have a .rds extension", call. = FALSE)
    }
  }

  # Ensure all lazy data loaded (see ?cmdstanr::save_object)
  model_fit$draws()
  try(model_fit$sampler_diagnostics(), silent = TRUE)
  try(model_fit$init(), silent = TRUE)
  try(model_fit$profiles(), silent = TRUE)

  # Update entire model output object and save
  model_output[["model_fit"]] <- model_fit
  readr::write_rds(model_output, path)

  if(!retain_csv){
  unlink(csv_path) # deleting the csv files
  }
  invisible(model_output)
}


#' Copy model file
#'
#' Save a predefined Stan model file to a local text file for editing. These
#' files can then be used in `prepare_model()` by specifying the `model_file`
#' argument.
#'
#' @param dir Character. Directory where file should be saved.
#' @param overwrite Logical. Whether to overwrite an existing copy of the model
#'   file.
#'
#' @inheritParams common_docs
#' @family modelling functions
#'
#' @return File path to copy of the new model file.
#'
#' @examples
#' # Save the Slope model in temp directory
#' copy_model_file(model = "slope", model_variant = "spatial", dir = tempdir())
#'
#' # Overwrite an existing copy
#' copy_model_file(model = "slope", model_variant = "spatial", dir = tempdir(),
#'                 overwrite = TRUE)
#'
#' # Clean up
#' unlink(file.path(tempdir(), "slope_spatial_bbs_CV_COPY.stan"))
#'
#' @export

copy_model_file <- function(model, model_variant, dir, overwrite = FALSE) {

  check_model(model, model_variant)
  check_dir(dir)

  f <- check_model_file(model, model_variant)

  f_new <- stringr::str_replace(basename(f), ".stan", "_COPY.stan") %>%
    file.path(dir, .)

  if(file.exists(f_new) & !overwrite) {
    stop("An existing copy of this file (", f_new, ")\nalready exists. ",
         "Either use `overwrite = TRUE` or rename the existing file",
         call. = FALSE)
  }

  message("Copying model file ", basename(f), " to ", f_new)
  file.copy(f, f_new, overwrite = overwrite)
  f_new
}
