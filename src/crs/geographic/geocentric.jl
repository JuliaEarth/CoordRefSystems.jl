# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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

Base.isapprox(coords₁::GeocentricLatLon{D}, coords₂::GeocentricLatLon{D}; kwargs...) where {D<:Datum} =
  isapprox(coords₁.lat, coords₂.lat; kwargs...) && isapprox(coords₁.lon, coords₂.lon; kwargs...)

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

Base.isapprox(coords₁::GeocentricLatLonAlt{D}, coords₂::GeocentricLatLonAlt{D}; kwargs...) where {D<:Datum} =
  isapprox(coords₁.lat, coords₂.lat; kwargs...) &&
  isapprox(coords₁.lon, coords₂.lon; kwargs...) &&
  isapprox(coords₁.alt, coords₂.alt; kwargs...)

Random.rand(rng::Random.AbstractRNG, ::Type{GeocentricLatLonAlt{Datum}}) where {Datum} =
  GeocentricLatLonAlt{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng), rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{GeocentricLatLonAlt}) = rand(rng, GeocentricLatLonAlt{WGS84Latest})

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# GeocentricLatLon <> GeocentricLatLonAlt

Base.convert(::Type{GeocentricLatLon{Datum}}, coords::GeocentricLatLonAlt{Datum}) where {Datum} =
  GeocentricLatLon{Datum}(coords.lat, coords.lon)

function Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  T = numtype(coords.lon)
  GeocentricLatLonAlt{Datum}(coords.lat, coords.lon, zero(T) * m)
end

# GeocentricLatLon <> Cartesian

function Base.convert(::Type{Cartesian{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  lla = convert(GeocentricLatLonAlt{Datum}, coords)
  convert(Cartesian{Datum}, lla)
end

function Base.convert(::Type{GeocentricLatLon{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  lla = convert(GeocentricLatLonAlt{Datum}, coords)
  convert(GeocentricLatLon{Datum}, lla)
end

# GeocentricLatLonAlt <> Cartesian

function Base.convert(::Type{Cartesian{Datum}}, coords::GeocentricLatLonAlt{Datum}) where {Datum}
  lla = convert(LatLonAlt, coords)
  convert(Cartesian{Datum}, lla)
end

function Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::Cartesian{Datum,3}) where {Datum}
  lla = convert(LatLonAlt, coords)
  convert(GeocentricLatLonAlt{Datum}, lla)
end

# datum conversion
function Base.convert(::Type{GeocentricLatLon{Datumₜ}}, coords::GeocentricLatLon{Datumₛ}) where {Datumₜ,Datumₛ}
  cartₛ = convert(Cartesian{Datumₛ}, coords)
  cartₜ = convert(Cartesian{Datumₜ}, cartₛ)
  convert(GeocentricLatLon{Datumₜ}, cartₜ)
end

# avoid converting coordinates with the same datum as the first argument
Base.convert(::Type{GeocentricLatLon{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum} = coords

function Base.convert(::Type{GeocentricLatLonAlt{Datumₜ}}, coords::GeocentricLatLonAlt{Datumₛ}) where {Datumₜ,Datumₛ}
  cartₛ = convert(Cartesian{Datumₛ}, coords)
  cartₜ = convert(Cartesian{Datumₜ}, cartₛ)
  convert(GeocentricLatLonAlt{Datumₜ}, cartₜ)
end

# avoid converting coordinates with the same datum as the first argument
Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::GeocentricLatLonAlt{Datum}) where {Datum} = coords

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{GeocentricLatLon}, coords::CRS{Datum}) where {Datum} = convert(GeocentricLatLon{Datum}, coords)

Base.convert(::Type{GeocentricLatLonAlt}, coords::CRS{Datum}) where {Datum} =
  convert(GeocentricLatLonAlt{Datum}, coords)
