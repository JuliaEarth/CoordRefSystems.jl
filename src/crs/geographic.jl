# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Geographic{Datum}

Geographic CRS with a given `Datum`.
"""
abstract type Geographic{Datum} <: CRS{Datum} end

"""
    LatLon(lat, lon)
    LatLon{Datum}(lat, lon)
    GeodeticLatLon(lat, lon)
    GeodeticLatLon{Datum}(lat, lon)

Geodetic latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
with a given `Datum` (default to `WGS84`).

`LatLon` is an alias to `GeodeticLatLon`.

## Examples

```julia
LatLon(45, 45) # add default units
LatLon(45u"°", 45u"°") # integers are converted converted to floats
LatLon((π/4)u"rad", (π/4)u"rad") # radians are converted to degrees
LatLon(45.0u"°", 45.0u"°")
LatLon{WGS84}(45.0u"°", 45.0u"°")
```

See [EPSG:4326](https://epsg.io/4326).
"""
struct GeodeticLatLon{Datum,D<:Deg} <: Geographic{Datum}
  lat::D
  lon::D
  GeodeticLatLon{Datum}(lat::D, lon::D) where {Datum,D<:Deg} = new{Datum,float(D)}(lat, lon)
end

GeodeticLatLon{Datum}(lat::Deg, lon::Deg) where {Datum} = GeodeticLatLon{Datum}(promote(lat, lon)...)
GeodeticLatLon{Datum}(lat::Rad, lon::Rad) where {Datum} = GeodeticLatLon{Datum}(rad2deg(lat), rad2deg(lon))
GeodeticLatLon{Datum}(lat::Number, lon::Number) where {Datum} =
  GeodeticLatLon{Datum}(addunit(lat, u"°"), addunit(lon, u"°"))

GeodeticLatLon(args...) = GeodeticLatLon{WGS84}(args...)

const LatLon = GeodeticLatLon

"""
    LatLonAlt(lat, lon, alt)
    LatLonAlt{Datum}(lat, lon, alt)
    GeodeticLatLonAlt(lat, lon, alt)
    GeodeticLatLonAlt{Datum}(lat, lon, alt)

Geodetic latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
and altitude in length units (default to meter) with a given `Datum` (default to `WGS84`).

`LatLonAlt` is an alias to `GeodeticLatLonAlt`.

## Examples

```julia
LatLonAlt(45, 45, 1) # add default units
LatLonAlt(45u"°", 45u"°", 1u"m") # integers are converted converted to floats
LatLonAlt((π/4)u"rad", (π/4)u"rad") # radians are converted to degrees
LatLonAlt(45.0u"°", 45.0u"°", 1.0u"km") # length quantities are converted to meters
LatLonAlt(45.0u"°", 45.0u"°", 1.0u"m")
LatLonAlt{WGS84}(45.0u"°", 45.0u"°", 1.0u"m")
```
"""
struct GeodeticLatLonAlt{Datum,D<:Deg,M<:Met} <: Geographic{Datum}
  lat::D
  lon::D
  alt::M
  GeodeticLatLonAlt{Datum}(lat::D, lon::D, alt::M) where {Datum,D<:Deg,M<:Met} =
    new{Datum,float(D),float(M)}(lat, lon, alt)
end

GeodeticLatLonAlt{Datum}(lat::Deg, lon::Deg, alt::Met) where {Datum} =
  GeodeticLatLonAlt{Datum}(promote(lat, lon)..., alt)
GeodeticLatLonAlt{Datum}(lat::Deg, lon::Deg, alt::Len) where {Datum} =
  GeodeticLatLonAlt{Datum}(lat, lon, uconvert(u"m", alt))
GeodeticLatLonAlt{Datum}(lat::Rad, lon::Rad, alt::Len) where {Datum} =
  GeodeticLatLonAlt{Datum}(rad2deg(lat), rad2deg(lon), alt)
GeodeticLatLonAlt{Datum}(lat::Number, lon::Number, alt::Number) where {Datum} =
  GeodeticLatLonAlt{Datum}(addunit(lat, u"°"), addunit(lon, u"°"), addunit(alt, u"m"))

GeodeticLatLonAlt(args...) = GeodeticLatLonAlt{WGS84}(args...)

const LatLonAlt = GeodeticLatLonAlt

"""
    GeocentricLatLon(lat, lon)
    GeocentricLatLon{Datum}(lat, lon)

Geocentric latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
GeocentricLatLon(45, 45) # add default units
GeocentricLatLon(45u"°", 45u"°") # integers are converted converted to floats
GeocentricLatLon((π/4)u"rad", (π/4)u"rad") # radians are converted to degrees
GeocentricLatLon(45.0u"°", 45.0u"°")
GeocentricLatLon{WGS84}(45.0u"°", 45.0u"°")
```
"""
struct GeocentricLatLon{Datum,D<:Deg} <: Geographic{Datum}
  lat::D
  lon::D
  GeocentricLatLon{Datum}(lat::D, lon::D) where {Datum,D<:Deg} = new{Datum,float(D)}(lat, lon)
end

GeocentricLatLon{Datum}(lat::Deg, lon::Deg) where {Datum} = GeocentricLatLon{Datum}(promote(lat, lon)...)
GeocentricLatLon{Datum}(lat::Rad, lon::Rad) where {Datum} = GeocentricLatLon{Datum}(rad2deg(lat), rad2deg(lon))
GeocentricLatLon{Datum}(lat::Number, lon::Number) where {Datum} =
  GeocentricLatLon{Datum}(addunit(lat, u"°"), addunit(lon, u"°"))

GeocentricLatLon(args...) = GeocentricLatLon{WGS84}(args...)

"""
    AuthalicLatLon(lat, lon)
    AuthalicLatLon{Datum}(lat, lon)

Authalic latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
AuthalicLatLon(45, 45) # add default units
AuthalicLatLon(45u"°", 45u"°") # integers are converted converted to floats
AuthalicLatLon((π/4)u"rad", (π/4)u"rad") # radians are converted to degrees
AuthalicLatLon(45.0u"°", 45.0u"°")
AuthalicLatLon{WGS84}(45.0u"°", 45.0u"°")
```
"""
struct AuthalicLatLon{Datum,D<:Deg} <: Geographic{Datum}
  lat::D
  lon::D
  AuthalicLatLon{Datum}(lat::D, lon::D) where {Datum,D<:Deg} = new{Datum,float(D)}(lat, lon)
end

AuthalicLatLon{Datum}(lat::Deg, lon::Deg) where {Datum} = AuthalicLatLon{Datum}(promote(lat, lon)...)
AuthalicLatLon{Datum}(lat::Rad, lon::Rad) where {Datum} = AuthalicLatLon{Datum}(rad2deg(lat), rad2deg(lon))
AuthalicLatLon{Datum}(lat::Number, lon::Number) where {Datum} =
  AuthalicLatLon{Datum}(addunit(lat, u"°"), addunit(lon, u"°"))

AuthalicLatLon(args...) = AuthalicLatLon{WGS84}(args...)

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
  GeocentricLatLon{Datum}(rad2deg(ϕ′) * u"°", coords.lon)
end

function Base.convert(::Type{LatLon{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  ϕ′ = ustrip(deg2rad(coords.lat))
  e² = oftype(ϕ′, eccentricity²(ellipsoid(Datum)))
  ϕ = atan(1 / (1 - e²) * tan(ϕ′))
  LatLon{Datum}(rad2deg(ϕ) * u"°", coords.lon)
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
  AuthalicLatLon{Datum}(rad2deg(β) * u"°", coords.lon)
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
  LatLon{Datum}(rad2deg(ϕ) * u"°", coords.lon)
end

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/conversions/cart.cpp
# reference formula: https://en.wikipedia.org/wiki/Geographic_coordinate_conversion#From_geodetic_to_ECEF_coordinates

function Base.convert(::Type{Cartesian{Datum}}, coords::LatLon{Datum}) where {Datum}
  T = numtype(coords.lon)
  lla = LatLonAlt(coords.lat, coords.lon, zero(T) * u"m")
  convert(Cartesian{Datum}, lla)
end

function Base.convert(::Type{LatLon{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  lla = convert(LatLonAlt{Datum}, coords)
  LatLon{Datum}(lla.lat, lla.lon)
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
  k = N + h

  x = k * cosϕ * cos(λ)
  y = k * cosϕ * sin(λ)
  z = k * (1 - e²) * sinϕ

  Cartesian{Datum}(x * u"m", y * u"m", z * u"m")
end

function Base.convert(::Type{LatLonAlt{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  T = numtype(coords.x)
  🌎 = ellipsoid(Datum)
  x = ustrip(coords.x)
  y = ustrip(coords.y)
  z = ustrip(coords.z)
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

  LatLonAlt{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°", h * u"m")
end
