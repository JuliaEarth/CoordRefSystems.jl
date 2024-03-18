# Cartography.jl

[![Build Status](https://github.com/JuliaEarth/Cartography.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaEarth/Cartography.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaEarth/Cartography.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/Cartography.jl)

Cartography.jl is a package for defining and converting coordinates Coordinate Reference Systems (CRS), in a "Julian" way with full support for units from [Unitful.jl](https://github.com/PainterQubits/Unitful.jl).

## Installation

Get the latest stable release with Julia's package manager:

```
] add Cartography
```

## Usage

The most common use of Cartography.jl is to convert geographic coordinates into projected coordinates:

```
julia> gcoord = LatLon(30, 60)
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: 30.0°
└─ lon: 60.0°

julia> pcoord1 = convert(Mercator{WGS84Latest}, gcoord)
Mercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.482189085408618e6 m

julia> pcoord2 = convert(WebMercator{WGS84Latest}, gcoord)
WebMercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.5035498435043753e6 m

julia> pcoord3 = convert(Robinson{WGS84Latest}, gcoord)
Robinson{WGS84Latest} coordinates
├─ x: 5.441866544132874e6 m
└─ y: 3.2085576115038935e6 m
```

It is also possible to convert the projected coordinates back into geographic coordinates:

```
julia> gcoord = LatLon(30, 60)
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: 30.0°
└─ lon: 60.0°

julia> pcoord = convert(Mercator{WGS84Latest}, gcoord)
Mercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.482189085408618e6 m

julia> convert(LatLon{WGS84Latest}, pcoord)
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: 29.999999999999996°
└─ lon: 59.99999999999999°
```

## Credits

Most implementations of this package are adaptations from [PROJ - Cartographic Projections and Coordinate Transformations Library](https://github.com/OSGeo/PROJ), which is also under the MIT license.
