# Stratify and filter Breeding Bird Survey data

Assign count data to strata and filter by species of interest. Routes
are assigned to strata based on their geographic location and the
stratification specified by the user. Species are filtered by matching
English, French or Scientific names to those in the BBS species data
(see
[`search_species()`](https://bbsbayes.github.io/bbsBayes2/reference/search_species.md)
for a flexible search to identify correct species names).

## Usage

``` r
stratify(
  by,
  species,
  strata_custom = NULL,
  combine_species_forms = TRUE,
  release = 2025,
  sample_data = FALSE,
  return_omitted = FALSE,
  quiet = FALSE,
  use_map = TRUE,
  distance_to_strata = NULL
)
```

## Arguments

- by:

  Character. Stratification type. Either an established type, one of
  "bbs", prov_state", "bcr", "latlong", "bbs_cws", "bbs_usgs", or a
  custom name (see `strata_custom` for details).

- species:

  Character. Bird species of interest. Can be specified by English,
  French, or Scientific names, or AOU code. Use
  [`search_species()`](https://bbsbayes.github.io/bbsBayes2/reference/search_species.md)
  for loose matching to find the exact name/code needed.

- strata_custom:

  (`sf`) Data Frame. Data frame of modified existing stratification, or
  a `sf` spatial data frame with polygons defining the custom
  stratifications. See Details.

- combine_species_forms:

  Logical. Whether to combine ambiguous species forms. Default `TRUE`.
  See Details.

- release:

  Numeric. Which yearly release to use, 2022 (including data through
  2021 field season) or 2020 (including data through 2019). Default
  2022.

- sample_data:

  Logical. Use sample data (just Pacific Wrens). Default `FALSE`.

- return_omitted:

  Logical. Whether or not to return a data frame of route-years which
  were omitted during stratification as they did not overlap with any
  stratum. For checking and troubleshooting. Default `FALSE`.

- quiet:

  Logical. Suppress progress messages? Default `FALSE`.

- use_map:

  Logical. Whether to stratify the BBS counts and routes based on the
  spatial location of route starting points relative to the polygons in
  the strata map. If one of the `bcr_old`, `prov_state`, `bbs_cws`,
  `latlong`, or `bbs_usgs` is supplied to the `by` argument, the FALSE
  option allows for the routes to be stratified based on the
  route-specific regional allocation in the BBS database. Ignored if the
  user supplies a custom stratification, or the `bcr` or `bbs`
  stratifications are supplied to the `by` argument. Default, `TRUE`

- distance_to_strata:

  numerical. Maximum distance (in meters), within which routes with
  starting locations that do not intersect any strata will be joined to
  the nearest stratum. This is `NULL` by default, indicating that BBS
  routes with starting locations that do not overlap a stratum will be
  omitted. If supplied, any route with a starting location that falls
  outside of the supplied strata polygons, but less than
  `distance_to_strata` meters from the boundary of at least one of the
  strata polygons, will be treated as if they overlap the nearest
  stratum. This argument is particularly useful to include routes with
  starting locations on or near the coast or shoreline of large lakes,
  which may be otherwise excluded due to plotting errors. For example,
  the map associated with the standard `bbs` stratification excludes
  3,877 surveys on 72 routes when this argument is NULL. All of these 72
  routes have starting locations on the coasts. Setting this argument to
  3000 (any route within 3 km of a polygon) ensures all of these coastal
  routes are included. Default `NULL`. Caution: Users should be cautious
  of using this argument if the strata map does not represent the full
  landmass of Canada and the United States. For example using a subset
  of an existing strata map, such as all of the bbs strata within one
  country will link routes within the set distance of the national
  border (e.g., some routes in the US will be joined to strata in
  Canada) the same way it treats routes that happen to fall just off the
  coast of the supplied strata map.

## Value

List of (meta) data.

- `meta_data` - meta data defining the analysis

- `meta_strata` - data frame listing strata names and area for all
  strata relevant to the data (i.e. some may have been removed due to
  lack of count data). Contains at least `strata_name` (the label of the
  stratum), and `area_sq_km` (area of the stratum).

- `birds_strata` - data frame of stratified count-level data filtered by
  species

- `routes_strata` - data frame of stratified route-level data filtered
  by species

## Details

To define a custom subset of an existing stratification, specify the
stratification in `by` (e.g., "bbs_cws") and then supply a subset of
`bbs_strata[["bbc_cws"]]` to `strata_custom` (see examples).

To define a completely new custom stratification, specify the name you
would like use in `by` (e.g., "east_west_divide") and then supply a
spatial data frame with polygons identifying the different strata to
`strata_custom`. Note that this data must have a column called exactly
`strata_name` which names all the strata contained (see examples). This
column must also be of class character not numeric or factor.

If `combine_species_forms` is `TRUE` (default), species with multiple
forms (e.g., "unid. Dusky Grouse / Sooty Grouse") are included in
overall species groupings (i.e., "unid." are combined with "Dusky
Grouse" and "Sooty Grouse" into "Blue Grouse (Dusky/Sooty)"). If the
user wishes to keep the forms separate, `combine_species_forms` can be
set to `FALSE`. See the data frame `species_forms`, for which species
are set to be combined with which other species.

See `vignette("stratification", package = "bbsBayes2")` and the article
[custom
stratification](https://bbsBayes.github.io/bbsBayes2/articles/custom_stratification.html)
for more details.

## See also

Other Data prep functions:
[`prepare_data()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_data.md),
[`prepare_model()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_model.md),
[`prepare_spatial()`](https://bbsbayes.github.io/bbsBayes2/reference/prepare_spatial.md)

## Examples

``` r
# Sample Data - BBS strata updated (2025) BBS strata with new BCRs
s <- stratify(by = "bbs", sample_data = TRUE)
#> Using 'bbs' (standard) stratification
#> Using sample BBS data...
#> Using species Pacific Wren (sample data)
#> Filtering to species Pacific Wren (7221)
#> Stratifying data...
#> Preparing strata (ESRI:102008; North_America_Albers_Equal_Area_Conic)...
#>   Calculating area weights...
#>   Joining routes to spatial layer...
#>   Renaming routes...
#>   Omitting 316/5,366 surveys, on 14 unique routes that do not match a stratum.
#>     To see omitted routes use `return_omitted = TRUE` (see ?stratify)
# omits some routes so using distance_to_strata to capture coastal routes
s <- stratify(by = "bbs", sample_data = TRUE, distance_to_strata = 2000)
#> Using 'bbs' (standard) stratification
#> Using sample BBS data...
#> Using species Pacific Wren (sample data)
#> Filtering to species Pacific Wren (7221)
#> Stratifying data...
#> Preparing strata (ESRI:102008; North_America_Albers_Equal_Area_Conic)...
#>   Calculating area weights...
#>   Joining routes to spatial layer...
#> Joining routes within 2000 m of strata boundaries
#>   Renaming routes...

# Full data - species and stratification
# Use `search_species()` to get correct species name

# Stratify by CWS BBS strata
s <- stratify(by = "bbs_cws", species = "Common Loon",
              use_map = FALSE)
#> Using 'bbs_cws' (standard) stratification
#> Loading BBS data...
#> Filtering to species Common Loon (70)
#> Stratifying data...
#>   Combining BCR 7 and NS and PEI...
#>   Renaming routes...

# Use use English, French, Scientific, or AOU codes for species names
s <- stratify(by = "bbs_cws", species = "Plongeon huard",
              use_map = FALSE)
#> Using 'bbs_cws' (standard) stratification
#> Loading BBS data...
#> Filtering to species Common Loon (70)
#> Stratifying data...
#>   Combining BCR 7 and NS and PEI...
#>   Renaming routes...
s <- stratify(by = "bbs_cws", species = 70,
              use_map = FALSE)
#> Using 'bbs_cws' (standard) stratification
#> Loading BBS data...
#> Filtering to species Common Loon (70)
#> Stratifying data...
#>   Combining BCR 7 and NS and PEI...
#>   Renaming routes...
s <- stratify(by = "bbs_cws", species = "Gavia immer",
              use_map = FALSE)
#> Using 'bbs_cws' (standard) stratification
#> Loading BBS data...
#> Filtering to species Common Loon (70)
#> Stratifying data...
#>   Combining BCR 7 and NS and PEI...
#>   Renaming routes...

# Stratify by updated (2025) Bird Conservation Regions
s <- stratify(by = "bcr", species = "Great Horned Owl",
              distance_to_strata = 4000)
#> Using 'bcr' (standard) stratification
#> Loading BBS data...
#> Filtering to species Great Horned Owl (3750)
#> Stratifying data...
#> Preparing strata (ESRI:102008; North_America_Albers_Equal_Area_Conic)...
#>   Calculating area weights...
#>   Joining routes to spatial layer...
#> Joining routes within 4000 m of strata boundaries
#>   Renaming routes...

# Stratify by former CWS BBS strata
s <- stratify(by = "bbs_cws", species = "Canada Jay",
              use_map = FALSE)
#> Using 'bbs_cws' (standard) stratification
#> Loading BBS data...
#> Filtering to species Canada Jay (4840)
#> Stratifying data...
#>   Combining BCR 7 and NS and PEI...
#>   Renaming routes...

# Stratify by State/Province/Territory only
s <- stratify(by = "prov_state", species = "Common Loon",
              use_map = FALSE)
#> Using 'prov_state' (standard) stratification
#> Loading BBS data...
#> Filtering to species Common Loon (70)
#> Stratifying data...
#>   Renaming routes...


# Stratify by blocks of 1 degree of latitude X 1 degree of longitude
s <- stratify(by = "latlong", species = "Snowy Owl",
              use_map = FALSE)
#> Using 'latlong' (standard) stratification
#> Loading BBS data...
#> Filtering to species Snowy Owl (3760)
#> Stratifying data...
#>   Renaming routes...
#>   Omitting 115/127,482 surveys, on 7 unique routes that do not match a stratum.
#>     To see omitted routes use `return_omitted = TRUE` (see ?stratify)

# Check routes omitted by stratification
s <- stratify(by = "latlong", species = "Snowy Owl", return_omitted = TRUE)
#> Using 'latlong' (standard) stratification
#> Loading BBS data...
#> Filtering to species Snowy Owl (3760)
#> Stratifying data...
#> Preparing strata (ESRI:102008; North_America_Albers_Equal_Area_Conic)...
#>   Calculating area weights...
#>   Joining routes to spatial layer...
#>   Renaming routes...
#>   Omitting 2,436/127,482 surveys, on 111 unique routes that do not match a stratum.
#>     Returning omitted routes.
s[["routes_omitted"]]
#> # A tibble: 2,436 × 11
#>     year strata_name country state   route route_name latitude longitude   bcr
#>    <dbl> <chr>       <chr>   <chr>   <chr> <chr>         <dbl>     <dbl> <dbl>
#>  1  1966 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  2  1967 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  3  1969 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  4  1970 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  5  1971 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  6  1972 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  7  1973 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  8  1974 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#>  9  1975 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#> 10  1976 NA          US      ALABAMA 2-40  DAUPHIN IS     30.2     -88.1    27
#> # ℹ 2,426 more rows
#> # ℹ 2 more variables: obs_n <dbl>, total_spp <dbl>

# Use combined or non-combined species forms

search_species("Sooty grouse")
#> # A tibble: 2 × 8
#>     aou english                  french order family genus species unid_combined
#>   <dbl> <chr>                    <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  2971 Sooty Grouse             Tétra… Gall… Phasi… Dend… fuligi… TRUE         
#> 2  2973 Blue Grouse (Dusky/Soot… Tétra… Gall… Phasi… Dend… obscur… TRUE         
s <- stratify(by = "bbs_usgs", species = "Blue Grouse (Dusky/Sooty)",
              use_map = FALSE)
#> Using 'bbs_usgs' (standard) stratification
#> Loading BBS data...
#> Filtering to species Blue Grouse (Dusky/Sooty) (2973)
#> Stratifying data...
#>   Renaming routes...
nrow(s$birds_strata) # Contains all Dusky, Sooty and unidentified
#> [1] 1612

search_species("Sooty grouse", combine_species_forms = FALSE)
#> # A tibble: 2 × 8
#>     aou english                  french order family genus species unid_combined
#>   <dbl> <chr>                    <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  2971 Sooty Grouse             Tétra… Gall… Phasi… Dend… fuligi… FALSE        
#> 2  2973 unid. Dusky Grouse / So… unid … Gall… Phasi… Dend… obscur… FALSE        
s <- stratify(by = "bbs_usgs", species = "unid. Dusky Grouse / Sooty Grouse",
              combine_species_forms = FALSE,
              use_map = FALSE)
#> Using 'bbs_usgs' (standard) stratification
#> Loading BBS data...
#> Filtering to species unid. Dusky Grouse / Sooty Grouse (2973)
#> Stratifying data...
#>   Renaming routes...
nrow(s$birds_strata) # Contains *only* unidentified
#> [1] 92


# Stratify by a subset of an existing stratification
library(dplyr)
my_cws <- filter(bbs_strata[["bbs_cws"]], country_code == "CA")
s <- stratify(by = "bbs_cws", strata_custom = my_cws, species = "Snowy Owl",
              use_map = FALSE)
#> Using 'bbs_cws' (subset) stratification
#> Loading BBS data...
#> Filtering to species Snowy Owl (3760)
#> Stratifying data...
#>   Combining BCR 7 and NS and PEI...
#>   Renaming routes...
#>   Omitting 107,926/127,482 surveys, on 3,681 unique routes that do not match a stratum.
#>     To see omitted routes use `return_omitted = TRUE` (see ?stratify)

my_bcr <- filter(bbs_strata[["bcr_old"]], strata_name == "BCR8")
s <- stratify(by = "bcr_old", strata_custom = my_bcr,
              species = "Yellow-rumped Warbler (all forms)",
              use_map = FALSE)
#> Using 'bcr_old' (subset) stratification
#> Loading BBS data...
#> Filtering to species Yellow-rumped Warbler (all forms) (6556)
#> Stratifying data...
#>   Renaming routes...
#>   Omitting 125,934/127,482 surveys, on 4,678 unique routes that do not match a stratum.
#>     To see omitted routes use `return_omitted = TRUE` (see ?stratify)

# Stratify by Custom stratification, using sf map object
# e.g. with WBPHS stratum boundaries 2019
# available: https://ecos.fws.gov/ServCat/Reference/Profile/142628

if (FALSE) { # \dontrun{
map <- sf::read_sf("../WBPHS_Stratum_Boundaries_2019") %>%
  rename(strata_name = STRAT) # stratify expects this column

s <- stratify(by = "WBPHS_2019", strata_map = map)
} # }

```
