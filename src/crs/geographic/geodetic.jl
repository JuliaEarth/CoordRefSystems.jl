# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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
struct GeodeticLatLon{Datum,D<:Deg} <: Geographic{Datum,2}
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

constructor(::Type{<:GeodeticLatLon}) = GeodeticLatLon

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
struct GeodeticLatLonAlt{Datum,D<:Deg,M<:Met} <: Geographic{Datum,3}
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

constructor(::Type{<:GeodeticLatLonAlt}) = GeodeticLatLonAlt

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

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# LatLon <> LatLonAlt

Base.convert(::Type{LatLon{Datum}}, coords::LatLonAlt{Datum}) where {Datum} = LatLon{Datum}(coords.lat, coords.lon)

function Base.convert(::Type{LatLonAlt{Datum}}, coords::LatLon{Datum}) where {Datum}
  T = numtype(coords.lon)
  LatLonAlt{Datum}(coords.lat, coords.lon, zero(T) * m)
end

# LatLon <> Cartesian

function Base.convert(::Type{Cartesian{Datum}}, coords::LatLon{Datum}) where {Datum}
  lla = convert(LatLonAlt{Datum}, coords)
  convert(Cartesian{Datum}, lla)
end

function Base.convert(::Type{LatLon{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  lla = convert(LatLonAlt{Datum}, coords)
  convert(LatLon{Datum}, lla)
end

# LatLonAlt <> Cartesian

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/conversions/cart.cpp
# reference formulas:
# Wikipedia - Geographic coordinate conversion (https://en.wikipedia.org/wiki/Geographic_coordinate_conversion)
# Bowring, B.R, (1976). Transformation from Spatial to Geographical Coordinates (https://doi.org/10.1179/sre.1976.23.181.323)

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

function Base.convert(::Type{LatLonAlt{Datumₜ}}, coords::LatLonAlt{Datumₛ}) where {Datumₜ,Datumₛ}
  cartₛ = convert(Cartesian{Datumₛ}, coords)
  cartₜ = convert(Cartesian{Datumₜ}, cartₛ)
  convert(LatLonAlt{Datumₜ}, cartₜ)
end

# avoid converting coordinates with the same datum as the first argument
Base.convert(::Type{LatLonAlt{Datum}}, coords::LatLonAlt{Datum}) where {Datum} = coords

Base.convert(C::Type{LatLonAlt{Datumₜ}}, coords::LatLon{Datumₛ}) where {Datumₜ,Datumₛ} =
  convert(C, convert(LatLonAlt, coords))

Base.convert(C::Type{LatLon{Datumₜ}}, coords::LatLonAlt{Datumₛ}) where {Datumₜ,Datumₛ} =
  convert(C, convert(LatLon, coords))

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{LatLon}, coords::CRS{Datum}) where {Datum} = convert(LatLon{Datum}, coords)

Base.convert(::Type{LatLonAlt}, coords::CRS{Datum}) where {Datum} = convert(LatLonAlt{Datum}, coords)
