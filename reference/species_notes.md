# Species notes

Introduced in version 1.1.2. List of species and comments returned as
warning messages if the time-span of an analysis is not appropriate: A
collection of species and species-complexes where observations are not
consistently recorded through time. List intended to help flag
particular species where some trend analyses may be inappropriate.

## Usage

``` r
species_notes
```

## Format

### `species_notes`

A data frame with 6 rows and 5 columns

- `english` - The English name of the species

- `french` - Le nom francais, de l'espece

- `aou` - The unique numerical identification of the species in the BBS
  database

- `minimum_year` - The suggested first year by which the species
  observations are consistent

- `warning` - The text warning and explanation delivered by the
  prepare_data function

## Examples

``` r
species_notes
#>                  english                  french   aou minimum_year
#> 1       Alder Flycatcher  Moucherolle des aulnes  4661         1978
#> 2      Willow Flycatcher  Moucherolle des saules  4660         1978
#> 3          Clark's Grebe    Grèbe à face blanche    11         1990
#> 4          Western Grebe           Grèbe élégant    10         1990
#> 5 Eurasian Collared-Dove      Tourterelle turque 22860         1990
#> 6           Cave Swallow Hirondelle à front brun  6121         1985
#>                                                                                                                                                                                     warning
#> 1 Alder and Willow Flycatcher were considered a single species until 1973. It is likely that they are not accurately separated by BBS observers until at least some years after that split.
#> 2 Alder and Willow Flycatcher were considered a single species until 1973. It is likely that they are not accurately separated by BBS observers until at least some years after that split.
#> 3   Clark's and Western Grebe were considered a single species until 1985. It is likely that they are not accurately separated by BBS observers until at least some years after that split.
#> 4   Clark's and Western Grebe were considered a single species until 1985. It is likely that they are not accurately separated by BBS observers until at least some years after that split.
#> 5                                     Eurasian Collared Dove was introduced into North America in the 1980s. 1990 is the first year that the species was observed on at least 3 BBS routes.
#> 6                                                      Cave Swallows were relatively rare in the areas surveyed by BBS before 1980. There are only two observations during BBS before 1980.
```
