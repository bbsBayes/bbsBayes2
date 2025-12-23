# List of included strata

List of strata included in bbsBayes2. Each list item contains a data
frame describing the strata for that stratification (name, area,
country, etc.)

## Usage

``` r
bbs_strata
```

## Format

### `bbs_strata`

A list of 5 data frames

Contains `bbs_usgs`, `bbs_cws`, `bcr`, `latlong` and `prov_state`

## Examples

``` r
bbs_strata[["bbs_cws"]]
#> # A tibble: 207 × 7
#>    strata_name area_sq_km country country_code prov_state   bcr bcr_by_country
#>  * <chr>            <dbl> <chr>   <chr>        <chr>      <dbl> <chr>         
#>  1 CA-AB-10        52565. Canada  CA           AB            10 Canada-BCR_10 
#>  2 CA-AB-11       149352. Canada  CA           AB            11 Canada-BCR_11 
#>  3 CA-AB-6        445135. Canada  CA           AB             6 Canada-BCR_6  
#>  4 CA-AB-8          6987. Canada  CA           AB             8 Canada-BCR_8  
#>  5 CA-BC-10       383006. Canada  CA           BC            10 Canada-BCR_10 
#>  6 CA-BC-4        193180. Canada  CA           BC             4 Canada-BCR_4  
#>  7 CA-BC-5        199820. Canada  CA           BC             5 Canada-BCR_5  
#>  8 CA-BC-6        106917. Canada  CA           BC             6 Canada-BCR_6  
#>  9 CA-BC-9         59939. Canada  CA           BC             9 Canada-BCR_9  
#> 10 CA-BCR7-7     1743744. Canada  CA           BCR7           7 Canada-BCR_7  
#> # ℹ 197 more rows
bbs_strata[["latlon"]]
#> NULL
```
