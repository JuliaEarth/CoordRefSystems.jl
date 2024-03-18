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

### Basic coordinates

Conversions between basic CSR are defined by Cartography.jl:

Cartesian <> Polar:
```
julia> cartesian = Cartesian(1, 1)
Cartesian{NoDatum} coordinates
├─ x: 1.0 m
└─ y: 1.0 m

julia> polar = convert(Polar, cartesian)
Polar{NoDatum} coordinates
├─ ρ: 1.4142135623730951 m
└─ ϕ: 0.7853981633974483 rad

julia> convert(Cartesian, polar)
Cartesian{NoDatum} coordinates
├─ x: 1.0000000000000002 m
└─ y: 1.0 m
```

Cartesian <> Cylindrical:
```
julia> cartesian = Cartesian(1, 1, 1)
Cartesian{NoDatum} coordinates
├─ x: 1.0 m
├─ y: 1.0 m
└─ z: 1.0 m

julia> cylindrical = convert(Cylindrical, cartesian)
Cylindrical{NoDatum} coordinates
├─ ρ: 1.4142135623730951 m
├─ ϕ: 0.7853981633974483 rad
└─ z: 1.0 m

julia> convert(Cartesian, cylindrical)
Cartesian{NoDatum} coordinates
├─ x: 1.0000000000000002 m
├─ y: 1.0 m
└─ z: 1.0 m
```

Cartesian <> Spherical:
```
julia> cartesian = Cartesian(1, 1, 1)
Cartesian{NoDatum} coordinates
├─ x: 1.0 m
├─ y: 1.0 m
└─ z: 1.0 m

julia> spherical = convert(Spherical, cartesian)
Spherical{NoDatum} coordinates
├─ r: 1.7320508075688772 m
├─ θ: 0.9553166181245093 rad
└─ ϕ: 0.7853981633974483 rad

julia> convert(Cartesian, spherical)
Cartesian{NoDatum} coordinates
├─ x: 1.0 m
├─ y: 0.9999999999999998 m
└─ z: 0.9999999999999999 m
```

### GIS coordinates

The most common use of Cartography.jl is to convert geographic coordinates into projected coordinates:

```
julia> latlon = LatLon(30, 60)
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: 30.0°
└─ lon: 60.0°

julia> convert(Mercator{WGS84Latest}, latlon)
Mercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.482189085408618e6 m

julia> convert(WebMercator{WGS84Latest}, latlon)
WebMercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.5035498435043753e6 m

julia> convert(Robinson{WGS84Latest}, latlon)
Robinson{WGS84Latest} coordinates
├─ x: 5.441866544132874e6 m
└─ y: 3.2085576115038935e6 m
```

It is also possible to convert the projected coordinates back into geographic coordinates:

```
julia> latlon = LatLon(30, 60)
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: 30.0°
└─ lon: 60.0°

julia> mercator = convert(Mercator{WGS84Latest}, latlon)
Mercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.482189085408618e6 m

julia> convert(LatLon{WGS84Latest}, mercator)
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: 29.999999999999996°
└─ lon: 59.99999999999999°
```

Conversions between geographic coordinates and projected coordinates with the same or different Datums can be done in the same way:

```
julia> latlon = LatLon{WGS84Latest}(30, 60)
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: 30.0°
└─ lon: 60.0°

julia> convert(LatLon{ITRF{2008}}, latlon)
GeodeticLatLon{ITRF{2008}} coordinates
├─ lat: 30.00000000081754°
└─ lon: 59.99999999999999°

julia> mercator = convert(Mercator{WGS84Latest}, latlon)
Mercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.482189085408618e6 m

julia> convert(WebMercator{WGS84Latest}, mercator)
WebMercator{WGS84Latest} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.5035498435043753e6 m

julia> convert(WebMercator{ITRF{2008}}, mercator)
WebMercator{ITRF{2008}} coordinates
├─ x: 6.679169447596414e6 m
└─ y: 3.5035498436094625e6 m
```

## Credits

Most implementations of this package are adaptations from [PROJ - Cartographic Projections and Coordinate Transformations Library](https://github.com/OSGeo/PROJ), which is also under the [MIT license](https://github.com/OSGeo/PROJ/blob/master/COPYING).
