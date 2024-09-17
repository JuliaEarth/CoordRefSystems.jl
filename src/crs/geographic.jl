# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Geographic{Datum}

Geographic CRS with a given `Datum`.
"""
abstract type Geographic{Datum} <: CRS{Datum} end

ndims(::Type{<:Geographic}) = 3

"""
    GeodeticLatLon(lat, lon)
    GeodeticLatLon{Datum}(lat, lon)

Geodetic latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
with a given `Datum` (default to `WGS84Latest`).

## Examples

```julia
GeodeticLatLon(45, 45) # add default units
GeodeticLatLon(45°, 45°) # integers are converted converted to floats
GeodeticLatLon((π/4)rad, (π/4)rad) # radians are converted to degrees
GeodeticLatLon(45.0°, 45.0°)
GeodeticLatLon{WGS84Latest}(45.0°, 45.0°)
```

See [EPSG:4326](https://epsg.io/4326).
"""
struct GeodeticLatLon{Datum,D<:Deg} <: Geographic{Datum}
  lat::D
  lon::D
end

GeodeticLatLon{Datum}(lat::D, lon::D) where {Datum,D<:Deg} = GeodeticLatLon{Datum,float(D)}(checklat(lat), fixlon(lon))
GeodeticLatLon{Datum}(lat::Deg, lon::Deg) where {Datum} = GeodeticLatLon{Datum}(promote(lat, lon)...)
GeodeticLatLon{Datum}(lat::Rad, lon::Rad) where {Datum} = GeodeticLatLon{Datum}(rad2deg(lat), rad2deg(lon))
GeodeticLatLon{Datum}(lat::Number, lon::Number) where {Datum} = GeodeticLatLon{Datum}(addunit(lat, °), addunit(lon, °))

GeodeticLatLon(args...) = GeodeticLatLon{WGS84Latest}(args...)

Base.convert(::Type{GeodeticLatLon{Datum,D}}, coords::GeodeticLatLon{Datum}) where {Datum,D} =
  GeodeticLatLon{Datum,D}(coords.lat, coords.lon)

raw(coords::GeodeticLatLon) = ustrip(coords.lon), ustrip(coords.lat) # reverse order

constructor(::Type{<:GeodeticLatLon{Datum}}) where {Datum} = GeodeticLatLon{Datum}

function reconstruct(C::Type{<:GeodeticLatLon}, raw)
  lon, lat = raw .* units(C)
  constructor(C)(lat, lon) # reverse order
end

lentype(::Type{<:GeodeticLatLon{Datum,D}}) where {Datum,D} = Met{numtype(D)}

==(coords₁::GeodeticLatLon{Datum}, coords₂::GeodeticLatLon{Datum}) where {Datum} =
  coords₁.lat == coords₂.lat && coords₁.lon == coords₂.lon

Random.rand(rng::Random.AbstractRNG, ::Type{GeodeticLatLon{Datum}}) where {Datum} =
  GeodeticLatLon{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{GeodeticLatLon}) = rand(rng, GeodeticLatLon{WGS84Latest})

"""
    LatLon(lat, lon)
    LatLon{Datum}(lat, lon)

Alias to [`GeodeticLatLon`](@ref).

## Examples

```julia
LatLon(45, 45) # add default units
LatLon(45°, 45°) # integers are converted converted to floats
LatLon((π/4)rad, (π/4)rad) # radians are converted to degrees
LatLon(45.0°, 45.0°)
LatLon{WGS84Latest}(45.0°, 45.0°)
```

See [EPSG:4326](https://epsg.io/4326).
"""
const LatLon = GeodeticLatLon

"""
    GeodeticLatLonAlt(lat, lon, alt)
    GeodeticLatLonAlt{Datum}(lat, lon, alt)

Geodetic latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
and altitude in length units (default to meter) with a given `Datum` (default to `WGS84Latest`).

## Examples

```julia
GeodeticLatLonAlt(45, 45, 1) # add default units
GeodeticLatLonAlt(45°, 45°, 1m) # integers are converted converted to floats
GeodeticLatLonAlt((π/4)rad, (π/4)rad) # radians are converted to degrees
GeodeticLatLonAlt(45.0°, 45.0°, 1.0km) # length quantities are converted to meters
GeodeticLatLonAlt(45.0°, 45.0°, 1.0m)
GeodeticLatLonAlt{WGS84Latest}(45.0°, 45.0°, 1.0m)
```
"""
struct GeodeticLatLonAlt{Datum,D<:Deg,M<:Met} <: Geographic{Datum}
  lat::D
  lon::D
  alt::M
end

GeodeticLatLonAlt{Datum}(lat::D, lon::D, alt::M) where {Datum,D<:Deg,M<:Met} =
  GeodeticLatLonAlt{Datum,float(D),float(M)}(checklat(lat), fixlon(lon), alt)
GeodeticLatLonAlt{Datum}(lat::Deg, lon::Deg, alt::Met) where {Datum} =
  GeodeticLatLonAlt{Datum}(promote(lat, lon)..., alt)
GeodeticLatLonAlt{Datum}(lat::Deg, lon::Deg, alt::Len) where {Datum} =
  GeodeticLatLonAlt{Datum}(lat, lon, uconvert(m, alt))
GeodeticLatLonAlt{Datum}(lat::Rad, lon::Rad, alt::Len) where {Datum} =
  GeodeticLatLonAlt{Datum}(rad2deg(lat), rad2deg(lon), alt)
GeodeticLatLonAlt{Datum}(lat::Number, lon::Number, alt::Number) where {Datum} =
  GeodeticLatLonAlt{Datum}(addunit(lat, °), addunit(lon, °), addunit(alt, m))

GeodeticLatLonAlt(args...) = GeodeticLatLonAlt{WGS84Latest}(args...)

Base.convert(::Type{GeodeticLatLonAlt{Datum,D,M}}, coords::GeodeticLatLonAlt{Datum}) where {Datum,D,M} =
  GeodeticLatLonAlt{Datum,D,M}(coords.lat, coords.lon, coords.alt)

raw(coords::GeodeticLatLonAlt) = ustrip(coords.lon), ustrip(coords.lat), ustrip(coords.alt) # reverse order

constructor(::Type{<:GeodeticLatLonAlt{Datum}}) where {Datum} = GeodeticLatLonAlt{Datum}

function reconstruct(C::Type{<:GeodeticLatLonAlt}, raw)
  lon, lat, alt = raw .* units(C)
  constructor(C)(lat, lon, alt) # reverse order
end

lentype(::Type{<:GeodeticLatLonAlt{Datum,D,M}}) where {Datum,D,M} = M

==(coords₁::GeodeticLatLonAlt{Datum}, coords₂::GeodeticLatLonAlt{Datum}) where {Datum} =
  coords₁.lat == coords₂.lat && coords₁.lon == coords₂.lon && coords₁.alt == coords₂.alt

Random.rand(rng::Random.AbstractRNG, ::Type{GeodeticLatLonAlt{Datum}}) where {Datum} =
  GeodeticLatLonAlt{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng), rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{GeodeticLatLonAlt}) = rand(rng, GeodeticLatLonAlt{WGS84Latest})

"""
    LatLonAlt(lat, lon, alt)
    LatLonAlt{Datum}(lat, lon, alt)

Alias to [`GeodeticLatLonAlt`](@ref).

## Examples

```julia
LatLonAlt(45, 45, 1) # add default units
LatLonAlt(45°, 45°, 1m) # integers are converted converted to floats
LatLonAlt((π/4)rad, (π/4)rad) # radians are converted to degrees
LatLonAlt(45.0°, 45.0°, 1.0km) # length quantities are converted to meters
LatLonAlt(45.0°, 45.0°, 1.0m)
LatLonAlt{WGS84Latest}(45.0°, 45.0°, 1.0m)
```
"""
const LatLonAlt = GeodeticLatLonAlt

"""
    GeocentricLatLon(lat, lon)
    GeocentricLatLon{Datum}(lat, lon)

Geocentric latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
GeocentricLatLon(45, 45) # add default units
GeocentricLatLon(45°, 45°) # integers are converted converted to floats
GeocentricLatLon((π/4)rad, (π/4)rad) # radians are converted to degrees
GeocentricLatLon(45.0°, 45.0°)
GeocentricLatLon{WGS84Latest}(45.0°, 45.0°)
```
"""
struct GeocentricLatLon{Datum,D<:Deg} <: Geographic{Datum}
  lat::D
  lon::D
end

GeocentricLatLon{Datum}(lat::D, lon::D) where {Datum,D<:Deg} =
  GeocentricLatLon{Datum,float(D)}(checklat(lat), fixlon(lon))
GeocentricLatLon{Datum}(lat::Deg, lon::Deg) where {Datum} = GeocentricLatLon{Datum}(promote(lat, lon)...)
GeocentricLatLon{Datum}(lat::Rad, lon::Rad) where {Datum} = GeocentricLatLon{Datum}(rad2deg(lat), rad2deg(lon))
GeocentricLatLon{Datum}(lat::Number, lon::Number) where {Datum} =
  GeocentricLatLon{Datum}(addunit(lat, °), addunit(lon, °))

GeocentricLatLon(args...) = GeocentricLatLon{WGS84Latest}(args...)

Base.convert(::Type{GeocentricLatLon{Datum,D}}, coords::GeocentricLatLon{Datum}) where {Datum,D} =
  GeocentricLatLon{Datum,D}(coords.lat, coords.lon)

raw(coords::GeocentricLatLon) = ustrip(coords.lon), ustrip(coords.lat) # reverse order

constructor(::Type{<:GeocentricLatLon{Datum}}) where {Datum} = GeocentricLatLon{Datum}

function reconstruct(C::Type{<:GeocentricLatLon}, raw)
  lon, lat = raw .* units(C)
  constructor(C)(lat, lon) # reverse order
end

lentype(::Type{<:GeocentricLatLon{Datum,D}}) where {Datum,D} = Met{numtype(D)}

==(coords₁::GeocentricLatLon{Datum}, coords₂::GeocentricLatLon{Datum}) where {Datum} =
  coords₁.lat == coords₂.lat && coords₁.lon == coords₂.lon

Random.rand(rng::Random.AbstractRNG, ::Type{GeocentricLatLon{Datum}}) where {Datum} =
  GeocentricLatLon{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{GeocentricLatLon}) = rand(rng, GeocentricLatLon{WGS84Latest})

"""
    GeocentricLatLonAlt(lat, lon, alt)
    GeocentricLatLonAlt{Datum}(lat, lon, alt)

Geocentric latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
and altitude in length units (default to meter) with a given `Datum` (default to `WGS84Latest`).
"""
struct GeocentricLatLonAlt{Datum,D<:Deg,M<:Met} <: Geographic{Datum}
  lat::D
  lon::D
  alt::M
end

GeocentricLatLonAlt{Datum}(lat::D, lon::D, alt::M) where {Datum,D<:Deg,M<:Met} =
  GeocentricLatLonAlt{Datum,float(D),float(M)}(checklat(lat), fixlon(lon), alt)
GeocentricLatLonAlt{Datum}(lat::Deg, lon::Deg, alt::Met) where {Datum} =
  GeocentricLatLonAlt{Datum}(promote(lat, lon)..., alt)
GeocentricLatLonAlt{Datum}(lat::Deg, lon::Deg, alt::Len) where {Datum} =
  GeocentricLatLonAlt{Datum}(lat, lon, uconvert(m, alt))
GeocentricLatLonAlt{Datum}(lat::Rad, lon::Rad, alt::Len) where {Datum} =
  GeocentricLatLonAlt{Datum}(rad2deg(lat), rad2deg(lon), alt)
GeocentricLatLonAlt{Datum}(lat::Number, lon::Number, alt::Number) where {Datum} =
  GeocentricLatLonAlt{Datum}(addunit(lat, °), addunit(lon, °), addunit(alt, m))

GeocentricLatLonAlt(args...) = GeocentricLatLonAlt{WGS84Latest}(args...)

Base.convert(::Type{GeocentricLatLonAlt{Datum,D,M}}, coords::GeocentricLatLonAlt{Datum}) where {Datum,D,M} =
  GeocentricLatLonAlt{Datum,D,M}(coords.lat, coords.lon, coords.alt)

raw(coords::GeocentricLatLonAlt) = ustrip(coords.lon), ustrip(coords.lat), ustrip(coords.alt) # reverse order

constructor(::Type{<:GeocentricLatLonAlt{Datum}}) where {Datum} = GeocentricLatLonAlt{Datum}

function reconstruct(C::Type{<:GeocentricLatLonAlt}, raw)
  lon, lat, alt = raw .* units(C)
  constructor(C)(lat, lon, alt) # reverse order
end

lentype(::Type{<:GeocentricLatLonAlt{Datum,D,M}}) where {Datum,D,M} = M

==(coords₁::GeocentricLatLonAlt{Datum}, coords₂::GeocentricLatLonAlt{Datum}) where {Datum} =
  coords₁.lat == coords₂.lat && coords₁.lon == coords₂.lon && coords₁.alt == coords₂.alt

Random.rand(rng::Random.AbstractRNG, ::Type{GeocentricLatLonAlt{Datum}}) where {Datum} =
  GeocentricLatLonAlt{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng), rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{GeocentricLatLonAlt}) = rand(rng, GeocentricLatLonAlt{WGS84Latest})

# ------------

"""
    AuthalicLatLon(lat, lon)
    AuthalicLatLon{Datum}(lat, lon)

Authalic latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
AuthalicLatLon(45, 45) # add default units
AuthalicLatLon(45°, 45°) # integers are converted converted to floats
AuthalicLatLon((π/4)rad, (π/4)rad) # radians are converted to degrees
AuthalicLatLon(45.0°, 45.0°)
AuthalicLatLon{WGS84Latest}(45.0°, 45.0°)
```
"""
struct AuthalicLatLon{Datum,D<:Deg} <: Geographic{Datum}
  lat::D
  lon::D
end

AuthalicLatLon{Datum}(lat::D, lon::D) where {Datum,D<:Deg} = AuthalicLatLon{Datum,float(D)}(checklat(lat), fixlon(lon))
AuthalicLatLon{Datum}(lat::Deg, lon::Deg) where {Datum} = AuthalicLatLon{Datum}(promote(lat, lon)...)
AuthalicLatLon{Datum}(lat::Rad, lon::Rad) where {Datum} = AuthalicLatLon{Datum}(rad2deg(lat), rad2deg(lon))
AuthalicLatLon{Datum}(lat::Number, lon::Number) where {Datum} = AuthalicLatLon{Datum}(addunit(lat, °), addunit(lon, °))

AuthalicLatLon(args...) = AuthalicLatLon{WGS84Latest}(args...)

Base.convert(::Type{AuthalicLatLon{Datum,D}}, coords::AuthalicLatLon{Datum}) where {Datum,D} =
  AuthalicLatLon{Datum,D}(coords.lat, coords.lon)

raw(coords::AuthalicLatLon) = ustrip(coords.lon), ustrip(coords.lat) # reverse order

constructor(::Type{<:AuthalicLatLon{Datum}}) where {Datum} = AuthalicLatLon{Datum}

function reconstruct(C::Type{<:AuthalicLatLon}, raw)
  lon, lat = raw .* units(C)
  constructor(C)(lat, lon) # reverse order
end

lentype(::Type{<:AuthalicLatLon{Datum,D}}) where {Datum,D} = Met{numtype(D)}

==(coords₁::AuthalicLatLon{Datum}, coords₂::AuthalicLatLon{Datum}) where {Datum} =
  coords₁.lat == coords₂.lat && coords₁.lon == coords₂.lon

Random.rand(rng::Random.AbstractRNG, ::Type{AuthalicLatLon{Datum}}) where {Datum} =
  AuthalicLatLon{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{AuthalicLatLon}) = rand(rng, AuthalicLatLon{WGS84Latest})

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/4D_api.cpp#L774

function Base.convert(::Type{GeocentricLatLon{Datum}}, coords::LatLon{Datum}) where {Datum}
  ϕ = ustrip(deg2rad(coords.lat))
  e² = oftype(ϕ, eccentricity²(ellipsoid(Datum)))
  ϕ′ = atan((1 - e²) * tan(ϕ))
  GeocentricLatLon{Datum}(rad2deg(ϕ′) * °, coords.lon)
end

function Base.convert(::Type{LatLon{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  ϕ′ = ustrip(deg2rad(coords.lat))
  e² = oftype(ϕ′, eccentricity²(ellipsoid(Datum)))
  ϕ = atan(1 / (1 - e²) * tan(ϕ′))
  LatLon{Datum}(phi2lat(ϕ), coords.lon)
end

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/healpix.cpp#L230
# reference formula: https://mathworld.wolfram.com/AuthalicLatitude.html

function Base.convert(::Type{AuthalicLatLon{Datum}}, coords::LatLon{Datum}) where {Datum}
  🌎 = ellipsoid(Datum)
  ϕ = ustrip(deg2rad(coords.lat))
  e = oftype(ϕ, eccentricity(🌎))
  e² = oftype(ϕ, eccentricity²(🌎))

  ome² = 1 - e²
  sinϕ = sin(ϕ)
  esinϕ = e * sinϕ
  q = ome² * (sinϕ / (1 - esinϕ^2) - (1 / 2e) * log((1 - esinϕ) / (1 + esinϕ)))
  # same formula as q, but ϕ = 90°
  qₚ = ome² * (1 / ome² - (1 / 2e) * log((1 - e) / (1 + e)))
  qqₚ⁻¹ = q / qₚ

  if abs(qqₚ⁻¹) > 1
    # rounding error
    qqₚ⁻¹ = sign(qqₚ⁻¹)
  end

  β = asin(qqₚ⁻¹)
  AuthalicLatLon{Datum}(rad2deg(β) * °, coords.lon)
end

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/auth.cpp
# reference formula: https://mathworld.wolfram.com/AuthalicLatitude.html

const _P₁₁ = 0.33333333333333333333 # 1 / 3
const _P₁₂ = 0.17222222222222222222 # 31 / 180
const _P₁₃ = 0.10257936507936507937 # 517 / 5040
const _P₂₁ = 0.06388888888888888888 # 23 / 360
const _P₂₂ = 0.06640211640211640212 # 251 / 3780
const _P₃₁ = 0.01677689594356261023 # 761 / 45360

# convert authalic latitude β to geodetic latitude ϕ
function auth2geod(β, e²)
  e⁴ = e²^2
  e⁶ = e²^3
  P₁₁ = oftype(β, _P₁₁)
  P₁₂ = oftype(β, _P₁₂)
  P₁₃ = oftype(β, _P₁₃)
  P₂₁ = oftype(β, _P₂₁)
  P₂₂ = oftype(β, _P₂₂)
  P₃₁ = oftype(β, _P₃₁)
  β + (P₁₁ * e² + P₁₂ * e⁴ + P₁₃ * e⁶) * sin(2β) + (P₂₁ * e⁴ + P₂₂ * e⁶) * sin(4β) + (P₃₁ * e⁶) * sin(6β)
end

function Base.convert(::Type{LatLon{Datum}}, coords::AuthalicLatLon{Datum}) where {Datum}
  β = ustrip(deg2rad(coords.lat))
  e² = oftype(β, eccentricity²(ellipsoid(Datum)))
  ϕ = auth2geod(β, e²)
  LatLon{Datum}(phi2lat(ϕ), coords.lon)
end

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/conversions/cart.cpp
# reference formulas:
# Wikipedia - Geographic coordinate conversion (https://en.wikipedia.org/wiki/Geographic_coordinate_conversion)
# Bowring, B.R, (1976). Transformation from Spatial to Geographical Coordinates (https://doi.org/10.1179/sre.1976.23.181.323)

Base.convert(::Type{LatLon{Datum}}, coords::LatLonAlt{Datum}) where {Datum} = LatLon{Datum}(coords.lat, coords.lon)

function Base.convert(::Type{LatLonAlt{Datum}}, coords::LatLon{Datum}) where {Datum}
  T = numtype(coords.lon)
  LatLonAlt{Datum}(coords.lat, coords.lon, zero(T) * m)
end

# Conversion from GeocentriLatLonAlt to GeocentriLatLonAlt
Base.convert(::Type{GeocentricLatLon{Datum}}, coords::GeocentricLatLonAlt{Datum}) where {Datum} =
  GeocentricLatLon{Datum}(coords.lat, coords.lon)

function Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  T = numtype(coords.lon)
  GeocentricLatLonAlt{Datum}(coords.lat, coords.lon, zero(T) * m)
end

# Cross conversion between LatLonAlt and GeocentricLatLonAlt
function Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::LatLonAlt{Datum}) where {Datum}
  geocentric = convert(GeocentricLatLon, LatLon{Datum}(coords.lat, coords.lon))
  GeocentricLatLonAlt{Datum}(geocentric.lat, geocentric.lon, coords.alt)
end

function Base.convert(::Type{LatLonAlt{Datum}}, coords::GeocentricLatLonAlt{Datum}) where {Datum}
  geodetic = convert(LatLon, GeocentricLatLon{Datum}(coords.lat, coords.lon))
  LatLonAlt{Datum}(geodetic.lat, geodetic.lon, coords.alt)
end
###################################################################

function Base.convert(::Type{Cartesian{Datum}}, coords::LatLon{Datum}) where {Datum}
  lla = convert(LatLonAlt{Datum}, coords)
  convert(Cartesian{Datum}, lla)
end

function Base.convert(::Type{LatLon{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  lla = convert(LatLonAlt{Datum}, coords)
  convert(LatLon{Datum}, lla)
end

function Base.convert(::Type{Cartesian{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  lla = convert(GeocentricLatLonAlt{Datum}, coords)
  convert(Cartesian{Datum}, lla)
end

function Base.convert(::Type{GeocentricLatLon{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  lla = convert(GeocentricLatLonAlt{Datum}, coords)
  convert(GeocentricLatLon{Datum}, lla)
end

function Base.convert(::Type{Cartesian{Datum}}, coords::GeocentricLatLonAlt{Datum}) where {Datum}
  _coords = convert(LatLonAlt, coords)
  convert(Cartesian{Datum}, _coords)
end

function Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  _coords = convert(LatLonAlt, coords)
  convert(GeocentricLatLonAlt{Datum}, _coords)
end

function Base.convert(::Type{Cartesian{Datum}}, coords::LatLonAlt{Datum}) where {Datum}
  T = numtype(coords.lon)
  🌎 = ellipsoid(Datum)
  λ = ustrip(deg2rad(coords.lon))
  ϕ = ustrip(deg2rad(coords.lat))
  h = ustrip(coords.alt)
  a = T(ustrip(majoraxis(🌎)))
  e² = T(eccentricity²(🌎))

  sinϕ = sin(ϕ)
  cosϕ = cos(ϕ)
  N = a / sqrt(1 - e² * sinϕ^2)
  Nph = N + h

  x = Nph * cosϕ * cos(λ)
  y = Nph * cosϕ * sin(λ)
  z = (N * (1 - e²) + h) * sinϕ

  Cartesian{Datum}(x * m, y * m, z * m)
end

function Base.convert(::Type{LatLonAlt{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  T = numtype(coords.x)
  🌎 = ellipsoid(Datum)
  x = ustrip(uconvert(m, coords.x))
  y = ustrip(uconvert(m, coords.y))
  z = ustrip(uconvert(m, coords.z))
  a = T(ustrip(majoraxis(🌎)))
  b = T(ustrip(minoraxis(🌎)))
  e² = T(eccentricity²(🌎))
  e′² = e² / (1 - e²)

  p = hypot(x, y)
  ψ = atan(a * z, b * p)

  λ = atan(y, x)
  ϕ = atan(z + b * e′² * sin(ψ)^3, p - a * e² * cos(ψ)^3)
  N = a / sqrt(1 - e² * sin(ϕ)^2)
  h = p / cos(ϕ) - N

  LatLonAlt{Datum}(phi2lat(ϕ), lam2lon(λ), h * m)
end

# datum conversion
function Base.convert(::Type{LatLon{Datumₜ}}, coords::LatLon{Datumₛ}) where {Datumₜ,Datumₛ}
  cartₛ = convert(Cartesian{Datumₛ}, coords)
  cartₜ = convert(Cartesian{Datumₜ}, cartₛ)
  convert(LatLon{Datumₜ}, cartₜ)
end

# avoid converting coordinates with the same datum as the first argument
Base.convert(::Type{LatLon{Datum}}, coords::LatLon{Datum}) where {Datum} = coords

function Base.convert(::Type{GeocentricLatLon{Datumₜ}}, coords::GeocentricLatLon{Datumₛ}) where {Datumₜ,Datumₛ}
  cartₛ = convert(Cartesian{Datumₛ}, coords)
  cartₜ = convert(Cartesian{Datumₜ}, cartₛ)
  convert(GeocentricLatLon{Datumₜ}, cartₜ)
end
# avoid converting coordinates with the same datum as the first argument
Base.convert(::Type{GeocentricLatLon{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum} = coords

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{LatLon}, coords::CRS{Datum}) where {Datum} = convert(LatLon{Datum}, coords)

Base.convert(::Type{LatLonAlt}, coords::CRS{Datum}) where {Datum} = convert(LatLonAlt{Datum}, coords)

Base.convert(::Type{GeocentricLatLon}, coords::CRS{Datum}) where {Datum} = convert(GeocentricLatLon{Datum}, coords)

Base.convert(::Type{GeocentricLatLonAlt}, coords::CRS{Datum}) where {Datum} =
  convert(GeocentricLatLonAlt{Datum}, coords)

Base.convert(::Type{AuthalicLatLon}, coords::CRS{Datum}) where {Datum} = convert(AuthalicLatLon{Datum}, coords)
