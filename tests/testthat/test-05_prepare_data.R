test_that("prepare_data() - sample", {

  strat_samp <- stratify(by = "bbs_usgs", sample_data = TRUE, quiet = TRUE,
                         use_map = FALSE)

  expect_silent(p <- prepare_data(strat_samp, min_max_route_years = 2)) %>%
    expect_type("list") %>%
    expect_named(c("model_data", "meta_data", "meta_strata", "raw_data"))


  # By run (i.e. single value)
  expect_equal(p$model_data$n_sites, 387)
  expect_equal(p$model_data$n_strata, 19)
  expect_equal(p$model_data$n_counts, 5472)
  expect_equal(p$model_data$n_years, 57)
  expect_equal(p$model_data$n_observers, 677)
  expect_equal(p$model_data$max_n_obs_sites_strata, 118)

  # By strata
  expect_equal(
    p$model_data$n_obs_sites_strata,
    c(16, 99, 6, 114, 59, 8, 4, 86, 49, 21, 87, 49, 44, 35, 118, 7, 29, 100, 56))

  expect_equal(
    p$model_data$non_zero_weight,
    c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))

  # Meta data
  expect_equal(p$meta_data$species, "Pacific Wren")
  expect_equal(p$meta_data$stratify_by, "bbs_usgs")
  expect_equal(p$meta_data$stratify_type, "standard")



  # Snap shots (can't be run interactively)
  # By Observation
  expect_snapshot_value_safe(
    p$model_data[c("count", "strat", "year", "site", "observer", "first_year")],
    style = "json2")

  # Matrix
  expect_snapshot_value_safe(p$model_data[c("ste_mat", "obs_mat")], style = "json2")

  # Data
  expect_snapshot_value_safe(p$raw_data, style = "json2")

})


test_that("prepare_data() - other", {

  strat_samp <- stratify(by = "bbs", species = "Common Loon", quiet = TRUE,
                         use_map = TRUE,
                         distance_to_strata = 3000)

  expect_silent(p <- prepare_data(strat_samp, min_max_route_years = 2)) %>%
    expect_type("list") %>%
    expect_named(c("model_data", "meta_data", "meta_strata", "raw_data"))



  # Meta data
  expect_equal(p$meta_data$species, "Common Loon")
  expect_equal(p$meta_data$stratify_by, "bbs")
  expect_equal(p$meta_data$stratify_type, "standard")


  # Snap shots (can't be run interactively)
  # By Observation
  expect_snapshot_value_safe(
    p$model_data[c("count", "strat", "year", "site", "observer", "first_year")],
    style = "json2")

  # Matrix
  expect_snapshot_value_safe(p$model_data[c("ste_mat", "obs_mat")], style = "json2")

  # Data
  expect_snapshot_value_safe(p$raw_data, style = "json2")

})


test_that("prepare_data() - minimums", {

  strat_samp <- stratify(by = "bbs", species = "Common Loon", quiet = TRUE,
                         use_map = TRUE,
                         distance_to_strata = 6000)

  # test error where span is longer than available years
  expect_error(p <- prepare_data(strat_samp, min_max_route_years = 2,
                                  min_span = 40,
                                 min_year = 2000))

})


