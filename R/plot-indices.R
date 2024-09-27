#' Generate plots of index trajectories by stratum
#'
#' Generates the indices plot for each stratum modelled.
#'
#' @param min_year Numeric. Minimum year to plot.
#' @param max_year Numeric. Maximum year to plot.
#' @param title Logical. Whether to include a title on the plot.
#' @param title_size Numeric. Font size of plot title. Defaults to 20
#' @param axis_title_size Numeric. Font size of axis titles. Defaults to 18
#' @param axis_text_size Numeric. Font size of axis text. Defaults to 16
#' @param line_width Numeric. Size of the trajectory line. Defaults to 1
#' @param add_number_routes Logical. Whether to superimpose dotplot
#'   showing the number of BBS routes included in each year. This is useful as a
#'   visual check on the relative data-density through time because in most
#'   cases the number of observations increases over time.
#' @param spaghetti Logical. False by default. Plotting option to visualise the
#'   uncertainty in the estimated population trajectories. Instead of plotting
#'   the trajectory as a single line with an uncertainty bound, if TRUE, then
#'   the plot shows a sample of the posterior distribution of the estimated
#'   population trajectories. E.g., 100 semi-transparent lines, each representing
#'   one posterior draw of the population trajectory.
#' @param n_spaghetti Integer. 100 by default. Number of posterior draws of the
#'   population trajectory to include in the plot. Ignored if spaghetti = FALSE.
#' @param alpha_spaghetti Numeric [0,1], 0.2 by default. Alpha value - transparency
#'   of each individual population trajectory line in the spaghetti plot.
#'   Ignored if spaghetti = FALSE.
#' @inheritParams common_docs
#' @family indices and trends functions
#'
#' @return List of ggplot2 plots, each item being a plot of a stratum's indices.
#'
#' @examples
#' # Using the example model for Pacific Wrens...
#'
#' # Generate country, continent, and stratum indices
#' i <- generate_indices(model_output = pacific_wren_model,
#'                       regions = c("country", "continent", "stratum"))
#'
#' # Now, plot_indices() will generate a list of plots for all regions
#' plots <- plot_indices(i)
#'
#' # To view any plot, use [[i]]
#' plots[[1]]
#'
#' names(plots)
#'
#' # Suppose we wanted to access the continental plot. We could do so with
#' plots[["continent"]]
#'
#' # You can specify to only plot a subset of years using min_year and max_year
#'
#' # Plots indices from 2015 onward
#' p_2015_min <- plot_indices(i, min_year = 2015)
#' p_2015_min[["continent"]]
#'
#' #Plot up indices up to the year 2017
#' p_2017_max <- plot_indices(i, max_year = 2017)
#' p_2017_max[["continent"]]
#'
#' #Plot indices between 2011 and 2016
#' p_2011_2016 <- plot_indices(i, min_year = 2011, max_year = 2016)
#' p_2011_2016[["continent"]]
#'
#' @export
#'

plot_indices <- function(indices = NULL,
                         ci_width = 0.95,
                         min_year = NULL,
                         max_year = NULL,
                         title = TRUE,
                         title_size = 20,
                         axis_title_size = 18,
                         axis_text_size = 16,
                         line_width = 1,
                         spaghetti = FALSE,
                         n_spaghetti = 100,
                         alpha_spaghetti = 0.2,
                         add_observed_means = FALSE,
                         add_number_routes = FALSE) {

  # Checks
  check_data(indices)
  check_logical(title, add_observed_means, add_number_routes)
  check_numeric(ci_width, title_size, axis_title_size, axis_text_size, line_width)
  check_numeric(alpha_spaghetti,n_spaghetti)

  check_numeric(min_year, max_year, allow_null = TRUE)
  check_range(ci_width, c(0.001, 0.999))

  if(spaghetti){line_width = line_width*0.1}

  species <- indices$meta_data$species

  indices_samples <- indices$samples

  indices <- indices$indices %>%
    calc_luq(ci_width)



  cl <- "#39568c"

  plot_list <- list()

  if(!is.null(min_year)) indices <- indices[indices$year >= min_year, ]
  if(!is.null(max_year)) indices <- indices[indices$year <= max_year, ]

  for (i in unique(indices$region)) {
    to_plot <- indices[which(indices$region == i), ]

    samples_name <- to_plot %>%
      dplyr::select(region_type,region) %>%
      dplyr::distinct() %>%
      as.character() %>%
      paste(collapse = "_")

    to_plot_spaghetti <- indices_samples[[samples_name]] %>%
      as.data.frame() %>%
      dplyr::mutate(iteration = dplyr::row_number()) %>%
      dplyr::sample_n(size = n_spaghetti) %>%
      tidyr::pivot_longer(cols = !dplyr::matches("iteration"),
                          values_to = "index",
                          names_to = "year") %>%
      dplyr::mutate(year = as.integer(.data$year))


    if(title) t <- paste0(species, " - ", i) else t <- ""

    if(add_number_routes){
      if(max(to_plot$n_routes) > 200) {
        ncby_y <- ceiling(to_plot$n_routes/50)
        annot <- c("1 dot ~ 50 routes")
      } else {
        if(max(to_plot$n_routes) > 100) {
          ncby_y <- ceiling(to_plot$n_routes/10)
          annot <- c("1 dot ~ 10 routes")
        } else {
          ncby_y <- to_plot$n_routes
          annot <- c("1 dot = 1 route")
        }
      }

      names(ncby_y) <- to_plot$year
      dattc <- data.frame(year = rep(as.integer(names(ncby_y)), times = ncby_y))
    }

    p <- ggplot2::ggplot() +
      ggplot2::theme(panel.grid.major = ggplot2::element_blank(),
                     panel.grid.minor = ggplot2::element_blank(),
                     panel.background = ggplot2::element_blank(),
                     axis.line = ggplot2::element_line(colour = "black"),
                     plot.title = ggplot2::element_text(size = title_size),
                     axis.title = ggplot2::element_text(size = axis_title_size),
                     axis.text = ggplot2::element_text(size = axis_text_size)) +
      ggplot2::labs(title = t,
                    x = "Year",
                    y = "Annual index of abundance\n(mean count)") +
      ggplot2::scale_x_continuous(breaks = ~floor(pretty(.x))) +
      ggplot2::scale_y_continuous(limits = c(0, NA))



    if(add_observed_means) {
      p <- p +
        ggplot2::geom_point(data = to_plot,
                            ggplot2::aes(x = as.integer(.data$year),
                                         y = .data$obs_mean),
                            colour = "grey60", na.rm = TRUE)
    }

    if(spaghetti){
    p <- p +
      ggplot2::geom_line(
        data = to_plot_spaghetti, ggplot2::aes(x = .data$year, y = .data$index,
                                               group = .data$iteration),
        colour = cl, linewidth = line_width,
        alpha = alpha_spaghetti)
    }else{
      p <- p +
        ggplot2::geom_line(
          data = to_plot, ggplot2::aes(x = .data$year, y = .data$index),
          colour = cl, linewidth = line_width, ) +
        ggplot2::geom_ribbon(
          data = to_plot,
          ggplot2::aes(x = .data$year, ymin = .data$lci, ymax = .data$uci),
          fill = cl, alpha = 0.3)
    }
    if(add_number_routes) {
      p <- p +
        ggplot2::geom_dotplot(
          data = dattc, mapping = ggplot2::aes(x = .data$year), drop = TRUE,
          binaxis = "x", stackdir = "up", method = "histodot", binwidth = 1,
          width = 0.2, inherit.aes = FALSE, fill = "grey60",
          colour = "grey60", alpha = 0.2, dotsize = 0.3) +
        ggplot2::annotate(
          geom = "text", x = min(dattc$year) + 5, y = 0, label = annot,
          alpha = 0.4, colour = "grey60")
    }

    plot_list[[stringr::str_replace_all(paste(i), "[[:punct:]\\s]+", "_")]] <- p
  }

  plot_list
}

calc_luq <- function(data, ci_width) {
  lq <- (1 - ci_width) / 2
  uq <- ci_width + lq

  n <- stringr::str_detect(names(data), paste0("index_q_(", lq, "|", uq, ")"))
  if(sum(n) < 2) {
    stop("A confidence interval of ", ci_width, " needs quantiles ",
         lq, " and ", uq, ". Re-run `generate_indices()` with the required ",
         "`quantiles`.", call. = FALSE)
  }

  data[["lci"]] <- data[[paste0("index_q_", lq)]]
  data[["uci"]] <- data[[paste0("index_q_", uq)]]

  data
}
