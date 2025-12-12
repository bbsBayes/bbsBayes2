#' Generate a map of trends by strata
#'
#' `plot_map()` allows you to generate a colour-coded map of the percent
#' change in species trends for each strata.
#'
#' @param slope Logical. Whether or not to map values of the alternative trend
#'   metric (slope of a log-linear regression) if `slope = TRUE` was used in
#'   `generate_trends()`,  through the annual indices. Default `FALSE`.
#' @param title Logical. Whether or not to include a title with species. Default
#'   `TRUE`.
#' @param alternate_column Character, Optional name of numerical column in
#'   trends dataframe to plot. If one of the columns with "trend" in the title,
#'   (e.g., trend_q_0.05 then the colour scheme and breaks will match those
#'   used in the default trend maps)
#' @param col_ebird Logical, Alternative colour palette for trend values, based
#'   on the colour palette used for eBird status and trend maps.
#' @param strata_custom (`sf`) Data Frame. Data frame
#'   of modified existing stratification, or a `sf` spatial data frame with
#'   polygons defining the custom stratifications. See details on strata_custom
#'   in `stratify()`.
#' @param zoom_range Logical. When TRUE (default) zooms into region of the map
#'   where trend data are available. If FALSE, map extends out to cover all of
#'   the stratification map. Zoom-in uses `ggplot2::coord_sf()`
#'
#' @inheritParams common_docs
#' @family indices and trends functions
#'
#' @return a ggplot2 plot
#'
#' @examples
#' # Using the example model for Pacific Wrens...
#'
#' # Generate the continental and stratum indices
#' i <- generate_indices(pacific_wren_model)
#'
#' # Now generate trends
#' t <- generate_trends(i, slope = TRUE)
#'
#' # Generate the map (without slope trends)
#' plot_map(t)
#'
#' # Generate the map (with slope trends)
#' plot_map(t, slope = TRUE)
#'
#' # Viridis
#' plot_map(t, col_viridis = TRUE)
#'
#' # Generate a map (with alternate column - lower 95% Credible limit)
#' plot_map(t, alternate_column = "trend_q_0.05")
#'
#' @export
#'

plot_map <- function(trends,
                     slope = FALSE,
                     title = TRUE,
                     alternate_column = NULL,
                     col_viridis = FALSE,
                     col_ebird = FALSE,
                     strata_custom = NULL,
                     zoom_range = TRUE) {

  # Checks
  check_data(trends)
  check_logical(slope, title, col_viridis, col_ebird)
  alternate_trend_column <- NULL
  stratify_by <- trends[["meta_data"]]$stratify_by
  species <- trends[["meta_data"]]$species

  trends <- dplyr::filter(trends[["trends"]], .data$region_type == "stratum")
  start_year <- min(trends$start_year)
  end_year <- min(trends$end_year)

  stratify_by <- check_strata(stratify_by,custom = strata_custom)

  if(!is.null(strata_custom)){
    map <- strata_custom
    map <- dplyr::select(map, "strata_name") %>%
      dplyr::mutate(strata_name = as.character(.data$strata_name))
  }else{
    map <- load_map(stratify_by[1])
  }

  if(!is.null(alternate_column)){
    if(!alternate_column %in% names(trends)){
      stop("alternate_column is missing from trends.",
      "Specify a numerical column from the trends dataframe")
    }
    ## if the values in the alternate column are trends, then use the same
    ## colour scheme and breaks to match the defaul trend maps
    if(grepl("trend",alternate_column,ignore.case = TRUE)){
      alternate_trend_column <- alternate_column
      alternate_column <- NULL
    }
  }

  if(zoom_range){
    bb <- dplyr::inner_join(x = map, y = trends, by = c("strata_name" = "region")) %>%
      sf::st_bbox()
    xl <- bb[c("xmin","xmax")]
    yl <- bb[c("ymin","ymax")]
    zoom <- ggplot2::coord_sf(xlim = xl,ylim = yl)
  }


  if(is.null(alternate_column)){
  breaks <- c(-7, -4, -2, -1, -0.5, 0.5, 1, 2, 4, 7)
  labls <- c(paste0("< ", breaks[1]),
             paste0(breaks[-c(length(breaks))],":", breaks[-c(1)]),
             paste0("> ",breaks[length(breaks)]))
  labls <- paste0(labls, " %")

  check_slope(trends, slope)
  if(is.null(alternate_trend_column)){
  if(slope){ trend_col <- "slope_trend" }else{trend_col <- "trend"}
  }else{

    trend_col <- alternate_trend_column
  }

  trends$t_plot <- as.numeric(as.character(trends[[trend_col]]))
  trends$t_plot <- cut(trends$t_plot, breaks = c(-Inf, breaks, Inf),
                      labels = labls)

  if(title) {
    title <- paste(species, trend_col, start_year, "-", end_year)
  } else title <- NULL


  map <- dplyr::left_join(x = map, y = trends, by = c("strata_name" = "region"))


  m <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = map, ggplot2::aes(fill = .data$t_plot),
                     colour = "grey40", size = 0.1, show.legend = TRUE) +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = title,
                  fill = paste0(trend_col,"\n", start_year, "-", end_year)) +
    ggplot2::theme(legend.position = "right",
                   line = ggplot2::element_line(linewidth = 0.4),
                   rect = ggplot2::element_rect(linewidth = 0.1),
                   axis.text = ggplot2::element_blank(),
                   axis.line = ggplot2::element_blank(),
                   axis.title = ggplot2::element_blank()) +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE))
  if(!col_viridis) {
    if(!col_ebird){
    pal <- stats::setNames(
      c("#a50026", "#d73027", "#f46d43", "#fdae61", "#fee090", "#ffffbf",
        "#e0f3f8", "#abd9e9", "#74add1", "#4575b4", "#313695"),
      levels(map$t_plot))

    m <- m + ggplot2::scale_fill_manual(values = pal, na.value = "white",
                                        drop = FALSE)
    }else{
      pal <- stats::setNames(
        c("#A50F15", "#CB181D", "#EF3B2C", "#FB6A4A", "#FC9272", "#FFFFFF",
          "#9ECAE1", "#6BAED6", "#4292C6", "#2171B5", "#08519C"),
        levels(map$t_plot))

      m <- m + ggplot2::scale_fill_manual(values = pal, na.value = "#CCCCCC",
                                          drop = FALSE)
    }
  } else {
    m <- m + ggplot2::scale_fill_viridis_d(na.value = "white",
                                           drop = FALSE)
  }

  }else{ # if plotting alternate_column


    trend_col <- alternate_column
    trends$t_plot <- as.numeric(as.character(trends[[trend_col]]))

    if(grepl(x = alternate_column,pattern = "percent_change") & col_ebird){
      breaks <- c(-30, -20, -10, 0, 10, 20, 30)
      labls <- c(paste0("< ", breaks[1]),
                 paste0(breaks[-c(length(breaks))],":", breaks[-c(1)]),
                 paste0("> ",breaks[length(breaks)]))
      labls <- paste0(labls, " %")
      trends$t_plot <- cut(trends$t_plot, breaks = c(-Inf, breaks, Inf),
                           labels = labls)

      pal <- stats::setNames(
        c( "#CB181D", "#EF3B2C", "#FB6A4A", "#FC9272", # if col_ebird & percent_change match the scale and values of eBird's trend page
           "#9ECAE1", "#6BAED6", "#4292C6", "#2171B5"),
        levels(trends$t_plot))

    }
    if(!col_ebird & grepl(x = alternate_column,pattern = "percent_change")){
      breaks <- c(-75,-50,-33, -25, -10, 11, 33, 50,100,300)
      labls <- c(paste0("< ", breaks[1]),
                 paste0(breaks[-c(length(breaks))],":", breaks[-c(1)]),
                 paste0("> ",breaks[length(breaks)]))
      labls <- paste0(labls, " %")
      trends$t_plot <- cut(trends$t_plot, breaks = c(-Inf, breaks, Inf),
                           labels = labls)
      pal <- stats::setNames(
        c("#a50026", "#d73027", "#f46d43", "#fdae61", "#fee090", "#ffffbf",
          "#e0f3f8", "#abd9e9", "#74add1", "#4575b4", "#313695"),
        levels(trends$t_plot))


    }
  if(grepl(x = alternate_column,pattern = "trend")){

    breaks <- c(-7, -4, -2, -1, -0.5, 0.5, 1, 2, 4, 7)
    labls <- c(paste0("< ", breaks[1]),
               paste0(breaks[-c(length(breaks))],":", breaks[-c(1)]),
               paste0("> ",breaks[length(breaks)]))
    labls <- paste0(labls, " %")
    trends$t_plot <- cut(trends$t_plot, breaks = c(-Inf, breaks, Inf),
                         labels = labls)
    pal <- stats::setNames(
      c("#a50026", "#d73027", "#f46d43", "#fdae61", "#fee090", "#ffffbf",
        "#e0f3f8", "#abd9e9", "#74add1", "#4575b4", "#313695"),
      levels(trends$t_plot))


  }

    if(title) {
      title <- paste(species, alternate_column, start_year, "-", end_year)
    } else title <- NULL

    map <- dplyr::left_join(x = map, y = trends, by = c("strata_name" = "region"))



    m <- ggplot2::ggplot() +
      ggplot2::geom_sf(data = map, ggplot2::aes(fill = .data$t_plot),
                       colour = "grey40", size = 0.1, show.legend = TRUE) +
      ggplot2::theme_minimal() +
      ggplot2::labs(title = title,
                    fill = paste0(trend_col,"\n", start_year, "-", end_year)) +
      ggplot2::theme(legend.position = "right",
                     line = ggplot2::element_line(linewidth = 0.4),
                     rect = ggplot2::element_rect(linewidth = 0.1),
                     axis.text = ggplot2::element_blank(),
                     axis.line = ggplot2::element_blank(),
                     axis.title = ggplot2::element_blank()) +
      ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE))

    if(!col_viridis) {
      if(!col_ebird){

        m <- m + ggplot2::scale_fill_manual(values = pal, na.value = "white",
                                            drop = FALSE)
      }else{
         m <- m + ggplot2::scale_fill_manual(values = pal, na.value = "#CCCCCC",
                                             drop = FALSE)
      }
    } else {
      m <- m + ggplot2::scale_fill_viridis_d(na.value = "white",
                                             drop = FALSE)
    }

  }
  if(zoom_range){
    m <- m+zoom
    }
  m
}
