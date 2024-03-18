# Cartography.jl

[![Build Status](https://github.com/JuliaEarth/Cartography.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaEarth/Cartography.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaEarth/Cartography.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/Cartography.jl)

Cartography.jl provides conversions between Coordinate Reference Systems (CRS) for professional geographic mapping.
It was designed to work with units from [Unitful.jl](https://github.com/PainterQubits/Unitful.jl), respects the
projection bounds documented in [EPSG](https://epsg.io), and is very fast thanks to advanced parametrizations at
compile time.

This package addresses various design issues encountered in previous attempts such as
[Geodesy.jl](https://github.com/JuliaGeo/Geodesy.jl) and [MapMaths.jl](https://github.com/subnero1/MapMaths.jl).
Our benchmarks show that Cartography.jl is often faster than [PROJ](https://github.com/OSGeo/PROJ), which is the
most widely used software library for coordinate projections in the world (written in C/C++).

## Installation

Get the latest stable release with Julia's package manager:

```
] add Cartography
```

## Usage

### Basic CRS

Basic CRS include `Cartesian`, `Spherical`, `Cylindrical` and `Polar`.
We adopt Julia's conversion syntax to convert between them:

#### Cartesian <> Polar
```julia
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

#### Cartesian <> Cylindrical
```julia
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

#### Cartesian <> Spherical
```julia
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

### Advanced CRS

CRS are most useful to locate objets in the physical world.
Given an ellipsoid of revolution and a standardized origin,
a.k.a. "datum", we can locate points without ambiguity.

Cartography.jl provides all datums of the PROJ library in
pure Julia code, using type parameters for maximum performance.

Below is an example converting geodetic `LatLon` coordinates
on the `WGS84Latest` datum to `Mercator`, `WebMercator`, and
`Robinson` projected coordinates on the same datum:

```julia
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

It is also possible to convert between different datum, transparently:

```julia
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

Most implementations of this package are adaptations from
[PROJ](https://github.com/OSGeo/PROJ), which is also under
the [MIT license](https://github.com/OSGeo/PROJ/blob/master/COPYING).
