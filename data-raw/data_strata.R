# Using maps to create strata information
#
# This script pulls map data from inst/maps calculates area as well as adding
# other relevant metadata. If the map data are updated and the columns change,
# then this will need to be updated, but shouldn't be problematic.
#
# The standardized maps are also saved to overwrite the existing maps to users
# can have access to the standard set of columns when they use `load_map()`.

library(dplyr)
library(tidyr)
library(sf)
library(stringr)
library(assertr) # Checks to make sure data is as it should be in the end
library(rmapshaper) # allows simplification of the polygon boudnaries in a way
        # that preserves adjacency among polygons.

# See
# https://stringr.tidyverse.org/articles/regular-expressions.html#look-arounds
# for more complex regular expressions

# For all maps, only require `strata_name` (or equivalent), then all other
# details are calculated from that.

# Updated BCR stratification ----------------------------------------------
# updated BCR definitions that includes changes to Northern BCRS
# circa 2025

bcr_new <- "data-raw/maps_orig/bcr_2025_lakes12_statprov3.gpkg" %>%
  read_sf() %>%
  filter(!is_lake,
         country_code %in% c("CA","US","MX"), #  removing France, and Hawaii
         statprov_code != "HI") %>%
  sf::st_transform(crs = bbsBayes2::equal_area_crs) %>%
  rmapshaper::ms_simplify(keep = 0.05,
                          keep_shapes = TRUE) %>%
  sf::st_make_valid() %>%
  mutate(strata_name = paste0("BCR",bcr_label))   %>%
  group_by(strata_name) %>%
  summarise(.groups = "drop") %>%
  #st_cast("POLYGON") %>%
  mutate(area_sq_km = as.numeric(units::set_units(st_area(.), "km^2"))) %>%
  filter(area_sq_km > 1) %>%
  st_cast("MULTIPOLYGON")

st_write(bcr_new,
         file.path("inst/maps/",
                   "bcr_strata.gpkg"), append = FALSE)
st_write(bcr_new,
         file.path(system.file("maps", package = "bbsBayes2"),
                   "bcr_strata.gpkg"), append = FALSE)


# New BCR bbs stratification ----------------------------------------------


bbs_new <- "data-raw/maps_orig/bcr_2025_lakes12_statprov3.gpkg" %>%
  read_sf() %>%
  sf::st_transform(crs = bbsBayes2::equal_area_crs)

bbs_new <- rmapshaper::ms_simplify(bbs_new, keep = 0.05,
                                keep_shapes = TRUE) %>%
mutate(strata_name = paste0(country_code,"-",statprov_code,"-",bcr_label)) %>%
  st_make_valid() %>% # As needed when st_is_valid() fails
  filter(!is_lake,
         country_code %in% c("CA","US"), #  removing Mexico, France, and Hawaii
         statprov_code != "HI") %>%
  group_by(strata_name,bcr_label) %>%
  summarise(.groups = "drop") %>%
  mutate(area_sq_km = as.numeric(units::set_units(st_area(.), "km^2"))) %>%
  mutate(country_code = str_extract(strata_name, "^(CA)|(US)|(MX)"),
         bcr = bcr_label,
         prov_state = str_extract(strata_name, "(?<=-)[A-Z]{2}"),
         country = case_when(country_code == "CA" ~ "Canada",
                             country_code == "US" ~ "United States of America",
                             country_code == "MX" ~ "Mexico"),
         bcr_by_country = paste0(country, "-BCR_", bcr)) %>%
  select(strata_name, area_sq_km, country, country_code, prov_state, bcr,
         bcr_by_country) %>%
  st_cast("MULTIPOLYGON")

st_write(bbs_new,
         file.path("inst/maps/",
                   "bbs_strata.gpkg"), append = FALSE)
st_write(bbs_new,
file.path(system.file("maps", package = "bbsBayes2"),
          "bbs_strata.gpkg"), append = FALSE)


# tst <- ggplot()+
#   geom_sf(data = bbs_new,
#           aes(fill = strata_name))+
#   theme(legend.position = "none")
#
# tst


# USGS --------------------------------------------------
strata_bbs_usgs <- "data-raw/maps_orig/BBS_USGS_strata.shp" %>%
  read_sf() %>%
  st_make_valid() %>% # As needed when st_is_valid() fails
  rename_with(.fn = ~"strata_name",
              .cols = dplyr::any_of(c("strata_name", "ST_12"))) %>%
  select(strata_name) %>%
  mutate(area_sq_km = as.numeric(units::set_units(st_area(.), "km^2"))) %>%
  mutate(country_code = str_extract(strata_name, "^(CA)|(US)|(MX)"),
         bcr = as.numeric(str_extract(strata_name, "[0-9]+$")),
         prov_state = str_extract(strata_name, "(?<=-)[A-Z]{2}"),
         country = case_when(country_code == "CA" ~ "Canada",
                             country_code == "US" ~ "United States of America",
                             country_code == "MX" ~ "Mexico"),
         bcr_by_country = paste0(country, "-BCR_", bcr)) %>%
  select(strata_name, area_sq_km, country, country_code, prov_state, bcr,
         bcr_by_country) %>%
  filter(bcr != 0) %>%
  verify(nrow(.) == 215)

# # No differences!
# s <- st_drop_geometry(strata_bbs_usgs)
# waldo::compare(arrange(load_internal_file("bbs_strata", "bbs_usgs"),
#                        strata_name) %>%
#                  select(names(s)),
#                arrange(s, strata_name), tolerance = 0.1)

st_write(strata_bbs_usgs,
         file.path("inst/maps/",
                   "bbs_usgs_strata.gpkg"), append = FALSE)
st_write(strata_bbs_usgs,
         file.path(system.file("maps", package = "bbsBayes2"),
                   "bbs_usgs_strata.gpkg"), append = FALSE)

# CWS ----------------------------------------------------

strata_bbs_cws <- strata_bbs_usgs %>%
  mutate(prov_state = if_else(prov_state %in% c("PE", "NS"),
                              "NSPE", prov_state),
         prov_state = if_else(bcr == 7, "BCR7", prov_state),
         strata_name = paste0(country_code, "-", prov_state, "-", bcr),
         bcr_by_country = paste0(country, "-BCR_", bcr)) %>%
  group_by(strata_name, country, country_code, prov_state, bcr,
           bcr_by_country) %>%
  summarize(.groups = "drop") %>%
  mutate(area_sq_km = as.numeric(units::set_units(st_area(.), "km^2"))) %>%
  filter(bcr != 0) %>%
  relocate(area_sq_km, .after = "strata_name") %>%
  verify(nrow(.) == 207)

# # No differences!
# s <- st_drop_geometry(strata_bbs_cws)
# waldo::compare(arrange(load_internal_file("bbs_strata", "bbs_cws"),
#                        strata_name) %>%
#                  select(names(s)),
#                arrange(s, strata_name), tolerance = 0.1)

st_write(strata_bbs_cws,
         file.path(system.file("maps", package = "bbsBayes2"),
                   "bbs_cws_strata.gpkg"), append = FALSE)


st_write(strata_bbs_cws,
         file.path("inst/maps/",
                   "bbs_cws_strata.gpkg"), append = FALSE)
# BCR Old ----------------------------------------------------
# Old BCR stratification
strata_bcr_old <- "data-raw/maps_orig/BBS_BCR_strata.shp" %>%
  sf::read_sf() %>%
  sf::st_make_valid() %>%
  rename_with(.fn = ~"strata_name",
              .cols = dplyr::any_of(c("strata_name", "ST_12"))) %>%
  select(strata_name) %>%
  mutate(area_sq_km = as.numeric(units::set_units(st_area(.), "km^2"))) %>%
  filter(strata_name != "BCR0") %>%
  verify(nrow(.) == 37)

# # No differences!
# s <- st_drop_geometry(strata_bcr)
# waldo::compare(arrange(load_internal_file("bbs_strata", "bcr"), strata_name),
#                arrange(s, strata_name), tolerance = 0.1)

st_write(strata_bcr_old, file.path(system.file("maps", package = "bbsBayes2"),
                               "bcr_old_strata.gpkg"), append = FALSE)

st_write(strata_bcr_old,
         file.path("inst/maps/",
                   "bcr_old_strata.gpkg"), append = FALSE)
# #



# Latitude/Longitude -------------------------------------------------
# updated to include the land area included in "bbs" stratification


bbs_boundary <- bcr_new %>%
  summarise()%>%
  st_transform(crs = 4326)%>%
  st_make_valid()

bb <- st_bbox(bbs_boundary)


grid <- sf::st_make_grid(bbs_boundary,
                         cellsize = c(1,1),
                         offset = c(floor(bb["xmin"]),floor(bb["ymin"])))%>%
  st_make_valid()%>%
  st_cast("POLYGON")

coords <- st_coordinates(grid) %>%
  as_tibble() %>%
  group_by(L2) %>%
  summarise(X = min(X),  # named by bottom left corner
            Y = min(Y)) %>% # bottom left corner
  mutate(strata_name = paste0(Y,"_",
                              X))

grid <- grid %>%
  st_as_sf() %>%
  bind_cols(coords)%>%
  st_make_valid()%>%
  st_cast("POLYGON")

#put both boundary and grid into the equal area projection before intersection
grid2 <- grid %>% st_transform(crs = st_crs(bbs_new))
bbs_boundary2 <- bbs_boundary %>% st_transform(crs = st_crs(bbs_new))

strata_latlong <- st_intersection(grid2,bbs_boundary2) %>%
  st_make_valid() %>%
  select(strata_name) %>%
  group_by(strata_name) %>%
  summarise() %>%
  st_make_valid()%>%
  st_cast("MULTIPOLYGON")


aream <- strata_latlong %>%
  st_area() %>%
  as.numeric()

strata_latlong$area_sq_km <- aream/1e6

strata_latlong <- strata_latlong %>%
  select(strata_name,area_sq_km)%>%
  filter(area_sq_km > 1) %>%
  st_make_valid()

st_write(strata_latlong, file.path(system.file("maps", package = "bbsBayes2"),
                                   "latlong_strata.gpkg"), append = FALSE)
st_write(strata_latlong,
         file.path("inst/maps/",
                   "latlong_strata.gpkg"), append = FALSE)

# confirming that the routes fall in the correct strata based on floor(coordinate)
# s <- stratify("latlong","American Robin", distance_to_strata = 3000)
# tmp <- s$routes_strata
# rt_sum <- tmp %>%
#   select(route,latitude,longitude,strata_name) %>%
#   mutate(lat = as.integer(floor(latitude)),
#          long = as.integer(floor(longitude))) %>%
#   distinct() %>%
#   mutate(strat_alt = paste0(lat,"_",long),
#          check = ifelse(strat_alt == strata_name,TRUE,FALSE))
#


#
# strata_latlong <- "data-raw/maps_orig/BBS_LatLong_strata.shp" %>%
#   sf::read_sf() %>%
#   st_make_valid() %>% # As needed when st_is_valid() fails
#   rename_with(.fn = ~"strata_name",
#               .cols = dplyr::any_of(c("strata_name", "ST_12"))) %>%
#   select(strata_name) %>%
#   mutate(area_sq_km = as.numeric(units::set_units(st_area(.), "km^2"))) %>%
#   verify(nrow(.) == 2995)
#
# # # No differences!
# # s <- st_drop_geometry(strata_latlong)
# # waldo::compare(arrange(load_internal_file("bbs_strata", "latlong"),
# #                strata_name),
# #                arrange(s, strata_name), tolerance = 0.1)
#
# st_write(strata_latlong, file.path(system.file("maps", package = "bbsBayes2"),
#                                    "latlong_strata.gpkg"), append = FALSE)
#

# Province/State ------------------------

# Cannot include Mexico right now, as there is overlap between NL Canada and NL
# Mexico
prov_state_names <- bbsBayes2:::format_ne_states() %>%
  st_drop_geometry()

strata_prov_state <- "data-raw/maps_orig/BBS_ProvState_strata.shp" %>%
  read_sf() %>%
  st_make_valid() %>%
  rename_with(.fn = ~"strata_name",
              .cols = dplyr::any_of(c("strata_name", "ST_12"))) %>%
  select(strata_name) %>%
  mutate(area_sq_km = as.numeric(units::set_units(st_area(.), "km^2"))) %>%
  mutate(prov_state = strata_name) %>%
  left_join(prov_state_names, by = "prov_state") %>%
  # For simplicity, let's omit the accent in Quebec (sorry Quebec!)
  mutate(province_state =
           if_else(prov_state == "QC", "Quebec", province_state)) %>%
  select(strata_name, area_sq_km, country, country_code, prov_state,
         province_state) %>%
  arrange(country, prov_state) %>%
  verify(nrow(.) == 62)

# # No differences!
# s <- st_drop_geometry(strata_prov_state)
# waldo::compare(
#   arrange(load_internal_file("bbs_strata", "prov_state"), prov_state) %>%
#     mutate(province_state = tools::toTitleCase(tolower(province_state))) %>%
#     select(names(s)),
#   arrange(s, prov_state), tolerance = 0.1)


st_write(strata_prov_state, file.path(system.file("maps", package = "bbsBayes2"),
                                      "prov_state_strata.gpkg"), append = FALSE)

st_write(strata_prov_state,
         file.path("inst/maps/",
                   "prov_state_strata.gpkg"), append = FALSE)

# Save for use by users and functions -------------------
bbs_strata <- list("bbs" = st_drop_geometry(bbs_new),
                   "bbs_usgs" = st_drop_geometry(strata_bbs_usgs),
                   "bbs_cws" = st_drop_geometry(strata_bbs_cws),
                   "bcr" = st_drop_geometry(bcr_new),
                   "bcr_old" = st_drop_geometry(strata_bcr_old),
                   "latlong" = st_drop_geometry(strata_latlong),
                   "prov_state" = st_drop_geometry(strata_prov_state))


usethis::use_data(bbs_strata, overwrite = TRUE)
