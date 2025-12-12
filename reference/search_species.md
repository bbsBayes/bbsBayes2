# Search for species

A helper function for finding the appropriate species name for use in
[`stratify()`](https://bbsbayes.github.io/bbsBayes2/reference/stratify.md).

## Usage

``` r
search_species(species, combine_species_forms = TRUE)
```

## Arguments

- species:

  Character/Numeric. Search term, either name in English or French, AOU
  code, or scientific genus or species. Matches by regular expression
  but ignores case.

- combine_species_forms:

  Logical. Whether or not to search the combined species data or the
  uncombined species. Note that this results in different species names.

## Value

Subset of the BBS species data frame matching the species pattern.

## See also

Other helper functions:
[`assign_prov_state()`](https://bbsbayes.github.io/bbsBayes2/reference/assign_prov_state.md),
[`load_map()`](https://bbsbayes.github.io/bbsBayes2/reference/load_map.md)

## Examples

``` r
# Search for various terms
search_species("Paridae")
#> # A tibble: 17 × 8
#>      aou english                 french order family genus species unid_combined
#>    <dbl> <chr>                   <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#>  1  7360 Carolina Chickadee      Mésan… Pass… Parid… Poec… caroli… TRUE         
#>  2  7350 Black-capped Chickadee  Mésan… Pass… Parid… Poec… atrica… TRUE         
#>  3  7380 Mountain Chickadee      Mésan… Pass… Parid… Poec… gambeli TRUE         
#>  4  7370 Mexican Chickadee       Mésan… Pass… Parid… Poec… sclate… TRUE         
#>  5  7410 Chestnut-backed Chicka… Mésan… Pass… Parid… Poec… rufesc… TRUE         
#>  6  7400 Boreal Chickadee        Mésan… Pass… Parid… Poec… hudson… TRUE         
#>  7  7352 unid. Carolina Chickad… unid … Pass… Parid… Poec… caroli… TRUE         
#>  8  7353 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#>  9  7354 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#> 10  7351 unid. western chickade… unid … Pass… Parid… Poec… sp.     TRUE         
#> 11  7340 Bridled Titmouse        Mésan… Pass… Parid… Baeo… wollwe… TRUE         
#> 12  7330 Oak Titmouse            Mésan… Pass… Parid… Baeo… inorna… TRUE         
#> 13  7331 Juniper Titmouse        Mésan… Pass… Parid… Baeo… ridgwa… TRUE         
#> 14  7332 unid. Oak Titmouse / J… unid … Pass… Parid… Baeo… inorna… TRUE         
#> 15  7310 Tufted Titmouse         Mésan… Pass… Parid… Baeo… bicolor TRUE         
#> 16  7320 Black-crested Titmouse  Mésan… Pass… Parid… Baeo… atricr… TRUE         
#> 17  7315 unid. Tufted Titmouse … unid … Pass… Parid… Baeo… bicolo… TRUE         
search_species("chickadee")
#> # A tibble: 10 × 8
#>      aou english                 french order family genus species unid_combined
#>    <dbl> <chr>                   <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#>  1  7360 Carolina Chickadee      Mésan… Pass… Parid… Poec… caroli… TRUE         
#>  2  7350 Black-capped Chickadee  Mésan… Pass… Parid… Poec… atrica… TRUE         
#>  3  7380 Mountain Chickadee      Mésan… Pass… Parid… Poec… gambeli TRUE         
#>  4  7370 Mexican Chickadee       Mésan… Pass… Parid… Poec… sclate… TRUE         
#>  5  7410 Chestnut-backed Chicka… Mésan… Pass… Parid… Poec… rufesc… TRUE         
#>  6  7400 Boreal Chickadee        Mésan… Pass… Parid… Poec… hudson… TRUE         
#>  7  7352 unid. Carolina Chickad… unid … Pass… Parid… Poec… caroli… TRUE         
#>  8  7353 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#>  9  7354 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#> 10  7351 unid. western chickade… unid … Pass… Parid… Poec… sp.     TRUE         
search_species("mésang")
#> # A tibble: 18 × 8
#>      aou english                 french order family genus species unid_combined
#>    <dbl> <chr>                   <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#>  1  4840 Canada Jay              Mésan… Pass… Corvi… Peri… canade… TRUE         
#>  2  7360 Carolina Chickadee      Mésan… Pass… Parid… Poec… caroli… TRUE         
#>  3  7350 Black-capped Chickadee  Mésan… Pass… Parid… Poec… atrica… TRUE         
#>  4  7380 Mountain Chickadee      Mésan… Pass… Parid… Poec… gambeli TRUE         
#>  5  7370 Mexican Chickadee       Mésan… Pass… Parid… Poec… sclate… TRUE         
#>  6  7410 Chestnut-backed Chicka… Mésan… Pass… Parid… Poec… rufesc… TRUE         
#>  7  7400 Boreal Chickadee        Mésan… Pass… Parid… Poec… hudson… TRUE         
#>  8  7352 unid. Carolina Chickad… unid … Pass… Parid… Poec… caroli… TRUE         
#>  9  7353 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#> 10  7354 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#> 11  7351 unid. western chickade… unid … Pass… Parid… Poec… sp.     TRUE         
#> 12  7340 Bridled Titmouse        Mésan… Pass… Parid… Baeo… wollwe… TRUE         
#> 13  7330 Oak Titmouse            Mésan… Pass… Parid… Baeo… inorna… TRUE         
#> 14  7331 Juniper Titmouse        Mésan… Pass… Parid… Baeo… ridgwa… TRUE         
#> 15  7332 unid. Oak Titmouse / J… unid … Pass… Parid… Baeo… inorna… TRUE         
#> 16  7310 Tufted Titmouse         Mésan… Pass… Parid… Baeo… bicolor TRUE         
#> 17  7320 Black-crested Titmouse  Mésan… Pass… Parid… Baeo… atricr… TRUE         
#> 18  7315 unid. Tufted Titmouse … unid … Pass… Parid… Baeo… bicolo… TRUE         
search_species("Poecile")
#> # A tibble: 10 × 8
#>      aou english                 french order family genus species unid_combined
#>    <dbl> <chr>                   <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#>  1  7360 Carolina Chickadee      Mésan… Pass… Parid… Poec… caroli… TRUE         
#>  2  7350 Black-capped Chickadee  Mésan… Pass… Parid… Poec… atrica… TRUE         
#>  3  7380 Mountain Chickadee      Mésan… Pass… Parid… Poec… gambeli TRUE         
#>  4  7370 Mexican Chickadee       Mésan… Pass… Parid… Poec… sclate… TRUE         
#>  5  7410 Chestnut-backed Chicka… Mésan… Pass… Parid… Poec… rufesc… TRUE         
#>  6  7400 Boreal Chickadee        Mésan… Pass… Parid… Poec… hudson… TRUE         
#>  7  7352 unid. Carolina Chickad… unid … Pass… Parid… Poec… caroli… TRUE         
#>  8  7353 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#>  9  7354 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#> 10  7351 unid. western chickade… unid … Pass… Parid… Poec… sp.     TRUE         
search_species(7360)
#> # A tibble: 1 × 8
#>     aou english            french       order family genus species unid_combined
#>   <dbl> <chr>              <chr>        <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  7360 Carolina Chickadee Mésange de … Pass… Parid… Poec… caroli… TRUE         
search_species(73)
#> # A tibble: 28 × 8
#>      aou english                 french order family genus species unid_combined
#>    <dbl> <chr>                   <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#>  1  1730 Brant                   Berna… Anse… Anati… Bran… bernic… TRUE         
#>  2  2973 Blue Grouse (Dusky/Soo… Tétra… Gall… Phasi… Dend… obscur… TRUE         
#>  3  2730 Killdeer                Pluvi… Char… Chara… Char… vocife… TRUE         
#>  4   730 Aleutian Tern           Stern… Char… Larid… Onyc… aleuti… TRUE         
#>  5  3731 Whiskered Screech-Owl   Petit… Stri… Strig… Mega… tricho… TRUE         
#>  6  3732 Western Screech-Owl     Petit… Stri… Strig… Mega… kennic… TRUE         
#>  7  3730 Eastern Screech-Owl     Petit… Stri… Strig… Mega… asio    TRUE         
#>  8  7360 Carolina Chickadee      Mésan… Pass… Parid… Poec… caroli… TRUE         
#>  9  7350 Black-capped Chickadee  Mésan… Pass… Parid… Poec… atrica… TRUE         
#> 10  7380 Mountain Chickadee      Mésan… Pass… Parid… Poec… gambeli TRUE         
#> # ℹ 18 more rows
search_species("^73") # Use regex to match aou codes starting with 73
#> # A tibble: 17 × 8
#>      aou english                 french order family genus species unid_combined
#>    <dbl> <chr>                   <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#>  1   730 Aleutian Tern           Stern… Char… Larid… Onyc… aleuti… TRUE         
#>  2  7360 Carolina Chickadee      Mésan… Pass… Parid… Poec… caroli… TRUE         
#>  3  7350 Black-capped Chickadee  Mésan… Pass… Parid… Poec… atrica… TRUE         
#>  4  7380 Mountain Chickadee      Mésan… Pass… Parid… Poec… gambeli TRUE         
#>  5  7370 Mexican Chickadee       Mésan… Pass… Parid… Poec… sclate… TRUE         
#>  6  7352 unid. Carolina Chickad… unid … Pass… Parid… Poec… caroli… TRUE         
#>  7  7353 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#>  8  7354 unid. Black-capped Chi… unid … Pass… Parid… Poec… atrica… TRUE         
#>  9  7351 unid. western chickade… unid … Pass… Parid… Poec… sp.     TRUE         
#> 10  7340 Bridled Titmouse        Mésan… Pass… Parid… Baeo… wollwe… TRUE         
#> 11  7330 Oak Titmouse            Mésan… Pass… Parid… Baeo… inorna… TRUE         
#> 12  7331 Juniper Titmouse        Mésan… Pass… Parid… Baeo… ridgwa… TRUE         
#> 13  7332 unid. Oak Titmouse / J… unid … Pass… Parid… Baeo… inorna… TRUE         
#> 14  7310 Tufted Titmouse         Mésan… Pass… Parid… Baeo… bicolor TRUE         
#> 15  7320 Black-crested Titmouse  Mésan… Pass… Parid… Baeo… atricr… TRUE         
#> 16  7315 unid. Tufted Titmouse … unid … Pass… Parid… Baeo… bicolo… TRUE         
#> 17  7300 Pygmy Nuthatch          Sitte… Pass… Sitti… Sitta pygmaea TRUE         
search_species("blue grouse")
#> # A tibble: 1 × 8
#>     aou english                  french order family genus species unid_combined
#>   <dbl> <chr>                    <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  2973 Blue Grouse (Dusky/Soot… Tétra… Gall… Phasi… Dend… obscur… TRUE         
search_species("sooty grouse")
#> # A tibble: 2 × 8
#>     aou english                  french order family genus species unid_combined
#>   <dbl> <chr>                    <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  2971 Sooty Grouse             Tétra… Gall… Phasi… Dend… fuligi… TRUE         
#> 2  2973 Blue Grouse (Dusky/Soot… Tétra… Gall… Phasi… Dend… obscur… TRUE         

# To combine or not
search_species("blue grouse", combine_species_forms = FALSE)
#> # A tibble: 0 × 8
#> # ℹ 8 variables: aou <dbl>, english <chr>, french <chr>, order <chr>,
#> #   family <chr>, genus <chr>, species <chr>, unid_combined <lgl>
search_species("sooty grouse", combine_species_forms = FALSE)
#> # A tibble: 2 × 8
#>     aou english                  french order family genus species unid_combined
#>   <dbl> <chr>                    <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  2971 Sooty Grouse             Tétra… Gall… Phasi… Dend… fuligi… FALSE        
#> 2  2973 unid. Dusky Grouse / So… unid … Gall… Phasi… Dend… obscur… FALSE        
search_species("northern flicker")
#> # A tibble: 4 × 8
#>     aou english                  french order family genus species unid_combined
#>   <dbl> <chr>                    <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  4123 Northern Flicker (all f… Pic f… Pici… Picid… Cola… auratus TRUE         
#> 2  4120 (Yellow-shafted Flicker… Pic f… Pici… Picid… Cola… auratu… TRUE         
#> 3  4130 (Red-shafted Flicker) N… Pic f… Pici… Picid… Cola… auratu… TRUE         
#> 4  4125 hybrid Northern Flicker… hybri… Pici… Picid… Cola… auratu… TRUE         
search_species("northern flicker", combine_species_forms = FALSE)
#> # A tibble: 4 × 8
#>     aou english                  french order family genus species unid_combined
#>   <dbl> <chr>                    <chr>  <chr> <chr>  <chr> <chr>   <lgl>        
#> 1  4123 (unid. Red / Yellow Sha… Pic f… Pici… Picid… Cola… auratus FALSE        
#> 2  4120 (Yellow-shafted Flicker… Pic f… Pici… Picid… Cola… auratu… FALSE        
#> 3  4130 (Red-shafted Flicker) N… Pic f… Pici… Picid… Cola… auratu… FALSE        
#> 4  4125 hybrid Northern Flicker… hybri… Pici… Picid… Cola… auratu… FALSE        
```
