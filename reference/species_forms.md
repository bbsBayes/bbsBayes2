# Species forms

Species forms which will be combined if `combine_species_forms` is
`TRUE` in
[`stratify()`](https://bbsbayes.github.io/bbsBayes2/reference/stratify.md).

## Usage

``` r
species_forms
```

## Format

### `species_forms`

A data frame with 13 rows and 5 columns

- `aou_unid` - The AOU id number which will identify the combined
  unidentified form

- `ensligh_original` - The English name of the original 'unidentified'
  form

- `english_combined` - The English name of the new 'combined' forms

- `french_combined` - The French name of the new 'combined' forms

- `aou_id` - The AOU id numbers of all the forms which will be combined

## Examples

``` r
species_forms
#>    aou_unid                               english_original
#> 1      2973              unid. Dusky Grouse / Sooty Grouse
#> 2      5677                   (unid. race) Dark-eyed Junco
#> 3      4123    (unid. Red/Yellow Shafted) Northern Flicker
#> 4      5077      unid. Bullock's Oriole / Baltimore Oriole
#> 5      3370                                Red-tailed Hawk
#> 6      4022                                unid. sapsucker
#> 7      1690                                     Snow Goose
#> 8      6295       unid. Cassin's Vireo / Blue-headed Vireo
#> 9      4665     unid. Alder Flycatcher / Willow Flycatcher
#> 10     4642   unid. Cordilleran / Pacific-slope Flycatcher
#> 11       12            unid. Western Grebe / Clark's Grebe
#> 12     6556 (unid. Myrtle/Audubon's) Yellow-rumped Warbler
#> 13     5275           unid. Common Redpoll / Hoary Redpoll
#> 14     5012                               unid. Meadowlark
#>                                                   english_combined
#> 1                                        Blue Grouse (Dusky/Sooty)
#> 2                                      Dark-eyed Junco (all forms)
#> 3                                     Northern Flicker (all forms)
#> 4                            Northern Oriole (Bullock's/Baltimore)
#> 5                                      Red-tailed Hawk (all forms)
#> 6  Sapsuckers (Yellow-bellied/Red-naped/Red-breasted/Williamson's)
#> 7                                           Snow Goose (all forms)
#> 8                            Solitary Vireo (Blue-headed/Cassin's)
#> 9                               Traill's Flycatcher (Alder/Willow)
#> 10                  Western Flycatcher (Cordilleran/Pacific-slope)
#> 11                                 Western Grebe (Clark's/Western)
#> 12                               Yellow-rumped Warbler (all forms)
#> 13                                          Redpoll (Common/Hoary)
#> 14                         Meadowlark (Eastern/Western/Chihuahuan)
#>                                                french_combined
#> 1                            Tétras sombre (sombre/fuligineux)
#> 2                            Junco ardoisé (toutes les formes)
#> 3                           Pic flamboyant (toutes les formes)
#> 4                     Oriole du Nord (de Bullock/de Baltimore)
#> 5                      Buse à queue rousse (toutes les formes)
#> 6  Pics buveur de sève (maculé/à nuque rouge/à poitrine rouge)
#> 7                           Oie des neiges (toutes les formes)
#> 8                  Viréo à tête bleue (à tête bleue/de Cassin)
#> 9               Moucherolle de Traill (des aulnes/ des saules)
#> 10                     Moucherolle côtier (des ravins/ côtier)
#> 11                      Grèbe élégant (à face blanche/élégant)
#> 12               Paruline à croupion jaune (toutes les formes)
#> 13                                 Sizerin (flammé/blanchâtre)
#> 14                               Sturnelle (prés/Ouest/Lilian)
#>                          aou_id
#> 1                    2970, 2971
#> 2  5671, 5670, 5680, 5660, 5690
#> 3              4125, 4120, 4130
#> 4              5080, 5070, 5078
#> 5                          3380
#> 6        4020, 4021, 4031, 4032
#> 7                          1691
#> 8              6292, 6291, 6290
#> 9                    4661, 4660
#> 10                   4641, 4640
#> 11                       10, 11
#> 12                   6550, 6560
#> 13                   5270, 5280
#> 14             5009, 5010, 5011
```
