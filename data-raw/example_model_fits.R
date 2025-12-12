
library(bbsBayes2)
library(tidyverse)

species <- "Scissor-tailed Flycatcher"
#species <- "Arctic Warbler"

# extract the unique numerical identifier for this species in the BBS database
species_number <- search_species(species) %>%
  select(aou) %>%
  unlist()

s <- stratify("bbs_usgs",
              species = species) %>%
  prepare_data()

for(j in 1:nrow(bbs_models)){

  mod <- as.character(bbs_models[j,"model"])
  var <- as.character(bbs_models[j,"variant"])

  if(var == "spatial"){
  p <- prepare_spatial(s, strata_map = load_map("bbs_usgs")) %>%
    prepare_model(model = mod, model_variant = var)
  }else{
  p <- prepare_model(s,model = mod,
                     model_variant = var)
}

  m <- paste0("output/",
                      species_number,
                      "_",
                      mod,
                      "_",
                      var)
  m2 <- run_model(p,
                 output_basename = m,
                 output_dir = "vignettes/articles")

}





s <- stratify("latlong",
              species = species) %>%
  prepare_data(min_n_routes = 1)

for(mod in c("first_diff","gamye")){

  var <- "spatial"


    p <- prepare_spatial(s, strata_map = load_map("latlong")) %>%
      prepare_model(model = mod, model_variant = var)


  m <- paste0("output/",
              species_number,
              "_latlong_",
              mod,
              "_",
              var)
  m2 <- run_model(p,
                  output_basename = m,
                  output_dir = "vignettes/articles")

}




species <- "Barn Swallow"
#species <- "Arctic Warbler"

# extract the unique numerical identifier for this species in the BBS database
species_number <- search_species(species) %>%
  select(aou) %>%
  unlist()


s <- stratify("bbs_cws",
              species = species) %>%
  prepare_data()

model = "gamye"
var = "spatial"

p <- prepare_spatial(s, strata_map = load_map("bbs_cws")) %>%
  prepare_model(model = mod, model_variant = var)


m <- paste0("output/",
            species_number,
            "_",
            mod,
            "_",
            var)
m2 <- run_model(p,
                output_basename = m,
                output_dir = "vignettes/articles")









library(patchwork)
i <- generate_indices(m2)

igam <- generate_indices(m2, gam_smooths = TRUE)

t <- generate_trends(i, min_year = 2000)
tgam <- generate_trends(igam,gam = TRUE, min_year = 2000)
map <- plot_map(t)
mapgam <- plot_map(tgam)
map+mapgam

tt <- t$trends
ttgam <- tgam$trends
