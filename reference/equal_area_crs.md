# equal_area_crs

Introduced in version 1.1.2. The specific coordinate reference system
(crs) used for the included strata maps.
North_America_Albers_Equal_Area_Conic, projection that provides good
visualisation of the main areas covered by the North American Breeding
Bird Survey

## Usage

``` r
equal_area_crs
```

## Format

### `equal_area_crs`

An object of class `crs`

## Examples

``` r
equal_area_crs
#> Coordinate Reference System:
#>   User input: North_America_Albers_Equal_Area_Conic 
#>   wkt:
#> PROJCRS["North_America_Albers_Equal_Area_Conic",
#>     BASEGEOGCRS["NAD83",
#>         DATUM["North American Datum 1983",
#>             ELLIPSOID["GRS 1980",6378137,298.257222101,
#>                 LENGTHUNIT["metre",1]]],
#>         PRIMEM["Greenwich",0,
#>             ANGLEUNIT["Degree",0.0174532925199433]]],
#>     CONVERSION["unnamed",
#>         METHOD["Albers Equal Area",
#>             ID["EPSG",9822]],
#>         PARAMETER["Latitude of false origin",40,
#>             ANGLEUNIT["Degree",0.0174532925199433],
#>             ID["EPSG",8821]],
#>         PARAMETER["Longitude of false origin",-96,
#>             ANGLEUNIT["Degree",0.0174532925199433],
#>             ID["EPSG",8822]],
#>         PARAMETER["Latitude of 1st standard parallel",20,
#>             ANGLEUNIT["Degree",0.0174532925199433],
#>             ID["EPSG",8823]],
#>         PARAMETER["Latitude of 2nd standard parallel",60,
#>             ANGLEUNIT["Degree",0.0174532925199433],
#>             ID["EPSG",8824]],
#>         PARAMETER["Easting at false origin",0,
#>             LENGTHUNIT["metre",1],
#>             ID["EPSG",8826]],
#>         PARAMETER["Northing at false origin",0,
#>             LENGTHUNIT["metre",1],
#>             ID["EPSG",8827]]],
#>     CS[Cartesian,2],
#>         AXIS["easting",east,
#>             ORDER[1],
#>             LENGTHUNIT["metre",1]],
#>         AXIS["northing",north,
#>             ORDER[2],
#>             LENGTHUNIT["metre",1]],
#>     ID["ESRI",102008]]
```
