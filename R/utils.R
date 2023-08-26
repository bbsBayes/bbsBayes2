ext <- function(file) {
 stringr::str_extract(file, "(?<=\\.)[[:alnum:]]+$")
}

load_internal_file <- function(name, stratify_by = NULL) {
  system.file(name, paste0(stratify_by, ".csv"), package = "bbsBayes2") %>%
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

get_geo_types <- function(strata_map) {
  sf::st_geometry_type(strata_map) %>%
    stringr::str_remove("MULTI") %>%
    unique()
}


format_ne_states <- function() {
  check_rnaturalearth()

  rnaturalearth::ne_states(
    country = c("United States of America", "Canada"), returnclass = "sf") %>%
    dplyr::select("province_state" = "name", "code_hasc",
                  "country" = "admin") %>%
    tidyr::separate(.data$code_hasc, sep = "\\.",
                    into = c("country_code", "prov_state")) %>%
    dplyr::mutate(prov_state = dplyr::if_else(
      .data$prov_state == "NF", "NL", .data$prov_state))
}


# function to calculate the highest posterior density interval for the quantiles
# these intervals are often a better descriptor of skewed posterior distributions
interval_function_hpdi <- function(x,probs, names = TRUE){
  y <- vector("numeric",length = length(probs))
  if(names){
    names(y) <- paste0(probs*100,"%")
  }
  for(j in 1:length(probs)){
    prob <- probs[j]
    if(prob > 0.67 | prob < 0.33){
      if(prob < 0.33){
        q2 <- 1-(prob*2)
        i <- 1
      }else{
        q2 <- 1-((1-prob)*2)
        i <- 2
      }
      y[j] <- HDInterval::hdi(x,q2)[i]
    }else{
      y[j] <- stats::quantile(x,prob)
    }
  }
  return(y)
}
