# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EqualAreaCylindrical{latₜₛ,lonₒ,Datum}

Equal Area Cylindrical CRS with latitude of true scale `latₜₛ` and longitude origin `lonₒ`
in degrees and a given `Datum`.
"""
struct EqualAreaCylindrical{latₜₛ,lonₒ,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
end

EqualAreaCylindrical{latₜₛ,lonₒ,Datum}(x::M, y::M) where {latₜₛ,lonₒ,Datum,M<:Met} =
  EqualAreaCylindrical{latₜₛ,lonₒ,Datum,float(M)}(x, y)
EqualAreaCylindrical{latₜₛ,lonₒ,Datum}(x::Met, y::Met) where {latₜₛ,lonₒ,Datum} =
  EqualAreaCylindrical{latₜₛ,lonₒ,Datum}(promote(x, y)...)
EqualAreaCylindrical{latₜₛ,lonₒ,Datum}(x::Len, y::Len) where {latₜₛ,lonₒ,Datum} =
  EqualAreaCylindrical{latₜₛ,lonₒ,Datum}(uconvert(m, x), uconvert(m, y))
EqualAreaCylindrical{latₜₛ,lonₒ,Datum}(x::Number, y::Number) where {latₜₛ,lonₒ,Datum} =
  EqualAreaCylindrical{latₜₛ,lonₒ,Datum}(addunit(x, m), addunit(y, m))

EqualAreaCylindrical{latₜₛ,lonₒ}(args...) where {latₜₛ,lonₒ} = EqualAreaCylindrical{latₜₛ,lonₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{EqualAreaCylindrical{latₜₛ,lonₒ,Datum,M}},
  coords::EqualAreaCylindrical{latₜₛ,lonₒ,Datum}
) where {latₜₛ,lonₒ,Datum,M} = EqualAreaCylindrical{latₜₛ,lonₒ,Datum,M}(coords.x, coords.y)

constructor(::Type{<:EqualAreaCylindrical{latₜₛ,lonₒ,Datum}}) where {latₜₛ,lonₒ,Datum} =
  EqualAreaCylindrical{latₜₛ,lonₒ,Datum}

lentype(::Type{<:EqualAreaCylindrical{latₜₛ,lonₒ,Datum,M}}) where {latₜₛ,lonₒ,Datum,M} = M

==(
  coords₁::EqualAreaCylindrical{latₜₛ,lonₒ,Datum},
  coords₂::EqualAreaCylindrical{latₜₛ,lonₒ,Datum}
) where {latₜₛ,lonₒ,Datum} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

"""
    Lambert(x, y)
    Lambert{Datum}(x, y)

Lambert cylindrical equal-area coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
Lambert(1, 1) # add default units
Lambert(1m, 1m) # integers are converted converted to floats
Lambert(1.0km, 1.0km) # length quantities are converted to meters
Lambert(1.0m, 1.0m)
Lambert{WGS84Latest}(1.0m, 1.0m)
```

See [ESRI:54034](https://epsg.io/54034).
"""
const Lambert{Datum} = EqualAreaCylindrical{0.0°,0.0°,Datum}

"""
    Behrmann(x, y)
    Behrmann{Datum}(x, y)

Behrmann coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
Behrmann(1, 1) # add default units
Behrmann(1m, 1m) # integers are converted converted to floats
Behrmann(1.0km, 1.0km) # length quantities are converted to meters
Behrmann(1.0m, 1.0m)
Behrmann{WGS84Latest}(1.0m, 1.0m)
```

See [ESRI:54017](https://epsg.io/54017).
"""
const Behrmann{Datum} = EqualAreaCylindrical{30.0°,0.0°,Datum}

"""
    GallPeters(x, y)
    GallPeters{Datum}(x, y)

Gall-Peters coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
GallPeters(1, 1) # add default units
GallPeters(1m, 1m) # integers are converted converted to floats
GallPeters(1.0km, 1.0km) # length quantities are converted to meters
GallPeters(1.0m, 1.0m)
GallPeters{WGS84Latest}(1.0m, 1.0m)
```
"""
const GallPeters{Datum} = EqualAreaCylindrical{45.0°,0.0°,Datum}

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/cea.cpp
# reference formula: https://neacsu.net/docs/geodesy/snyder/3-cylindrical/sect_10/

function formulas(::Type{<:EqualAreaCylindrical{latₜₛ,lonₒ,Datum}}, ::Type{T}) where {latₜₛ,lonₒ,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₜₛ = T(ustrip(deg2rad(latₜₛ)))

  k₀ = cos(ϕₜₛ) / sqrt(1 - e² * sin(ϕₜₛ)^2)

  fx(λ, ϕ) = k₀ * (λ - λₒ)

  function fy(λ, ϕ)
    sinϕ = sin(ϕ)
    esinϕ = e * sinϕ
    q = (1 - e²) * (sinϕ / (1 - esinϕ^2) - (1 / 2e) * log((1 - esinϕ) / (1 + esinϕ)))
    q / 2k₀
  end

  fx, fy
end

function Base.convert(::Type{LatLon{Datum}}, coords::EqualAreaCylindrical{latₜₛ,lonₒ,Datum}) where {latₜₛ,lonₒ,Datum}
  🌎 = ellipsoid(Datum)
  x = coords.x
  y = coords.y
  a = oftype(x, majoraxis(🌎))
  e = convert(numtype(x), eccentricity(🌎))
  e² = convert(numtype(x), eccentricity²(🌎))
  λₒ = numconvert(numtype(x), deg2rad(lonₒ))
  ϕₜₛ = numconvert(numtype(x), deg2rad(latₜₛ))

  ome² = 1 - e²
  k₀ = cos(ϕₜₛ) / sqrt(1 - e² * sin(ϕₜₛ)^2)
  # same formula as q, but ϕ = 90°
  qₚ = ome² * (1 / ome² - (1 / 2e) * log((1 - e) / (1 + e)))

  λ = λₒ + x / (a * k₀)
  q = 2y * k₀ / a
  β = asin(q / qₚ)
  ϕ = auth2geod(β, e²)

  LatLon{Datum}(rad2deg(ϕ) * °, rad2deg(λ) * °)
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{EqualAreaCylindrical{latₜₛ,lonₒ}}, coords::CRS{Datum}) where {latₜₛ,lonₒ,Datum} =
  convert(EqualAreaCylindrical{latₜₛ,lonₒ,Datum}, coords)
