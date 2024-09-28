
library(bbsBayes2)
library(tidyverse)

species <- "Scissor-tailed Flycatcher"
species <- "Arctic Warbler"

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


# latlong fits ------------------------------------------------------------



s <- stratify("latlong",
              species = species) %>%
  prepare_data(min_n_routes = 1)

for(j in 3){

  mod <- as.character(bbs_models[j,"model"])
  var <- as.character(bbs_models[j,"variant"])

  if(var == "spatial"){
    p <- prepare_spatial(s, strata_map = load_map("latlong")) %>%
      prepare_model(model = mod, model_variant = var)
  }else{
    p <- prepare_model(s,model = mod,
                       model_variant = var)
  }

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

