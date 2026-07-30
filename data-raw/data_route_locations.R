# Creating route path information for more accurate route-strata allocation
#
#
# The standardized maps are also saved to overwrite the existing maps to users
# can have access to the standard set of columns when they use `load_map()`.

library(tidyverse)
library(sf)
library(stringr)
library(assertr) # Checks to make sure data is as it should be in the end

## function to separate province and route
route_n <- function(prov,rt){
  y <- vector("character",length(prov))
  for(i in 1:length(prov)){
    rr <- as.integer(substr(rt[i],(nchar(rt[i])-2),nchar(rt[i])))
    y[i] <- paste(prov[i],rr,sep = "-")
  }
  return(y)
}

## a shapefile currated by the Canadian national BBS office bbs@ec.gc.ca
routes_can <- st_read(dsn = "data-raw/maps_orig/ALLROUTES2024.shp") |>
  st_make_valid() #%>%

routes_can <- routes_can |>
  mutate(route_state_num = route_n(Province,ProvRoute),
         state_num = Province,
         route_name = str_sub(Nbr_FullNa,start = 8),
         country_num = 124) |>
  group_by(state_num,route,country_num) |>
  summarise(.groups = "drop")


## a partial collection of routes paths in the US
## NOT official
routes_us<- readRDS("data-raw/maps_orig/us_partial_route_paths.rds")

routes_us <- routes_us |>
  mutate(route = as.integer(str_sub(StateRoute,start = 3)),
         state_num = as.integer(str_sub(StateRoute,start = 1,end = 2)),
         country_num = CountryNum) |>
  group_by(state_num,route,country_num) |>
  summarise(.groups = "drop")




routes_us2 <- routes_us |>
  st_transform(crs = bbsBayes2::equal_area_crs)

routes_can2 <- routes_can |>
  st_transform(crs = bbsBayes2::equal_area_crs)


routes_all <- routes_us2 |>
  bind_rows(routes_can2)


tst <- ggplot()+
  geom_sf(data = routes_all,
           aes(colour = country_num))

tst

routes_simple <- st_simplify(routes_all,
                             preserveTopology = TRUE,
                             dTolerance = 200) |>
  mutate(spatial = TRUE)


rts_sz <- object.size(routes_simple)
format(rts_sz,units = "Mb")


tst <- ggplot()+
  geom_sf(data = routes_all,
          aes(colour = country_num))+
  geom_sf(data = routes_simple,
          colour = "red")

tst

## run fetch_bbs_data to include unacceptable surveys
## when finished be sure to run remove_cache()
#fetch_bbs_data(include_unacceptable = TRUE, force = TRUE)

tmp <- bbsBayes2::load_bbs_data()

tmp2 <- tmp$routes |>
  group_by(country_num,
         state_num,
         route,
         route_name,
         latitude,
         longitude) |>
  summarise(n = n(),
            firstyear = min(year))


routes_w_surveys <- routes_simple |>
  inner_join(tmp2,
             by = c("country_num",
                    "route",
                    "state_num"))

routes_surveys_no_path <- tmp2 |>
  left_join(routes_simple,
            by = c("country_num",
                   "route",
                   "state_num")) |>
  filter(is.na(spatial))


routes_surveys_no_path_sf <- routes_surveys_no_path |>
  st_drop_geometry() |>
  select(-c(spatial,n,firstyear)) |>
  st_as_sf(coords = c("longitude","latitude"),
           crs = 4326) |>
  st_transform(crs = bbsBayes2::equal_area_crs)


rts_spat_only <- routes_simple |>
  select(spatial)

  x <- sf::st_is_within_distance(routes_surveys_no_path_sf,
                                 rts_spat_only,
                                 dist = 1000,
                                 sparse = TRUE)

  miss_dist <- sf::st_distance(routes_surveys_no_path_sf,rts_spat_only)

  distance_to_route <- units::set_units(1000, "m")
  mtch <- vector(mode = "integer",length = nrow(x))
  for(j in 1:nrow(miss_dist)){
    tmp <- which.min(miss_dist[j,])
    mtch[j] <- ifelse(miss_dist[j,tmp] < distance_to_route, tmp,NA)
  }

  routes_surveys_no_path_drop_point <- sf::st_drop_geometry(routes_surveys_no_path_sf)
  route_details_join <- rts_spat_only[mtch,]
  outside_ret <- dplyr::bind_cols(routes_surveys_no_path_drop_point,
                                  route_details_join) |>
    filter(!is.na(spatial)) |>
    ungroup() |>
    select(-c(route_name))

routes_append <- routes_simple |>
  bind_rows(outside_ret)

routes_surveys_no_path2 <- tmp2 |>
  left_join(routes_append,
            by = c("country_num",
                   "route",
                   "state_num")) |>
  filter(is.na(spatial)) |>
  ungroup() |>
  select(-c(spatial,n,firstyear,route_name))



### generate fake ~100m lines for routes with no path information



routes_new_lines1 <- routes_surveys_no_path2 |>
  st_drop_geometry() |>
  st_as_sf(coords = c("longitude","latitude"),
           crs = 4326) |>
  st_transform(crs = bbsBayes2::equal_area_crs) |>
  mutate(ord = 1) #first point in order


routes_new_lines2 <- routes_surveys_no_path2 |>
  st_drop_geometry()|>
  mutate(latitude = latitude + 0.001 ) |>
  st_as_sf(coords = c("longitude","latitude"),
           crs = 4326) |>
  st_transform(crs = bbsBayes2::equal_area_crs) |>
  mutate(ord = 2) # second point

routes_new_lines <- routes_new_lines1 |>
  bind_rows(routes_new_lines2) |>
  arrange(country_num,state_num,route,
          ord)

routes_new_lines_f <- routes_new_lines |>
  group_by(country_num,state_num,route) |>
  summarize(do_union=FALSE,.groups = "drop") |>
  st_cast("LINESTRING") |>
  mutate(spatial = TRUE)

routes_append2 <- routes_append |>
  bind_rows(routes_new_lines_f)


routes_surveys_no_path3 <- tmp2 |>
  left_join(routes_append2,
            by = c("country_num",
                   "route",
                   "state_num")) |>
  filter(is.na(spatial))

if(nrow(routes_surveys_no_path3) != 0){
  stop("There are still routes with data missing")
}

.route_lines <- routes_append2 |>
  select(-spatial) |>
  st_cast("MULTILINESTRING")


st_write(.route_lines,
         file.path("inst/maps/",
                   "route_locations.gpkg"), append = FALSE)
st_write(.route_lines,
         file.path(system.file("maps", package = "bbsBayes2"),
                   "route_locations.gpkg"), append = FALSE)



###

# bbsBayes2::remove_cache()# removes the unacceptable data downloaded above
# fetch_bbs_data(force = TRUE)

#
#
#
#
#
# simple testing overplotting the routes and strata
base_prov <- load_map("bbs")

base_state <- rnaturalearth::ne_states(country = c("Canada","United States of America")) %>%
  st_transform(crs = st_crs(base_prov))


f <- system.file("maps", package = "bbsBayes2") %>%
  list.files(pattern = paste0("route_locations"), full.names = TRUE)

route_lines <- sf::read_sf(dsn = f, quiet = TRUE) |>
  sf::st_transform(sf::st_crs(base_prov)) |>
  mutate(st_rt = paste0(state_num,"-",route)) |>
  select(-route)

s <- stratify("bbs","American Robin",
              distance_to_strata = 5000)


routes <- s$routes_strata |>
  select(state_num,country_num,route,strata_name) |>
  distinct() |>
  rename(st_rt = route,
         strata_name_stratify = strata_name)

route_lines <- route_lines |>
  inner_join(routes,
            by = c("country_num","state_num","st_rt"))

pdf("strata_route_explore.pdf",
    height = 11,
    width = 8.5)

for(st in base_prov$strata_name){
  bs_tmp <- base_prov %>%
    filter(strata_name == st)

  bb <- st_bbox(bs_tmp)

  bb_sf <- st_as_sfc(bb) %>%
    st_as_sf()


  rt_tmp <- route_lines %>%
    sf::st_join(bb_sf,
                left = FALSE)

  rt_tmp2 <- route_lines |>
    filter(strata_name_stratify == st,
           !st_rt %in% rt_tmp$st_rt)

  if(nrow(rt_tmp2) > 0){
    rt_tmp <- rt_tmp |>
      bind_rows(rt_tmp2)
    bb <- st_bbox(rt_tmp)

  }

  rt_tmp <- rt_tmp |>
    mutate(strata_correct = ifelse(strata_name_stratify == st,
                                   TRUE,FALSE))


  base_tmp <- base_prov %>%
    sf::st_join(bb_sf,
                left = FALSE)


  if(nrow(rt_tmp) < 1){next}
  plot_tmp <- ggplot()+
    geom_sf(data = base_prov,
            colour = grey(0.5),
            aes(fill = strata_name),
            alpha = 0.3)+
    geom_sf(data = base_tmp,
            colour = "blue",
            fill = NA,
            alpha = 0.3)+
    geom_sf(data = bs_tmp,
            colour = "black",
            aes(fill = strata_name),
            alpha = 0.3)+
    geom_sf(data = rt_tmp,
            aes(colour = (strata_correct)),
            alpha = 0.7,
            linewidth = 1)+
    geom_sf_text(data = rt_tmp,
                 aes(label = st_rt),
                 size = 1.5)+
    coord_sf(ylim = bb[c("ymin","ymax")],
             xlim = bb[c("xmin","xmax")])+
    theme(legend.position = "none")+
    scale_fill_viridis_d(aesthetics = c("fill"))+
    scale_colour_viridis_d(begin = 0.1,end = 0.7)+
    labs(title = st)+
    ggspatial::annotation_scale()+
    ylab("")+
    xlab("")

  print(plot_tmp)

}

dev.off()

















