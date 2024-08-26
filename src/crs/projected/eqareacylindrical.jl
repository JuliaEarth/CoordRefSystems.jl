# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct EACHyper{D<:Deg}
  latₜₛ::D
end

EACHyper(; latₜₛ=0.0°) = EACHyper(asdeg(latₜₛ))

"""
    EqualAreaCylindrical{Hyper,Shift,Datum}

Equal Area Cylindrical CRS with latitude of true scale `latₜₛ` and longitude origin `lonₒ`
in degrees and a given `Datum`.
"""
struct EqualAreaCylindrical{Hyper,Shift,Datum,M<:Met} <: Projected{Shift,Datum}
  x::M
  y::M
end

EqualAreaCylindrical{Hyper,Shift,Datum}(x::M, y::M) where {Hyper,Shift,Datum,M<:Met} =
  EqualAreaCylindrical{Hyper,Shift,Datum,float(M)}(x, y)
EqualAreaCylindrical{Hyper,Shift,Datum}(x::Met, y::Met) where {Hyper,Shift,Datum} =
  EqualAreaCylindrical{Hyper,Shift,Datum}(promote(x, y)...)
EqualAreaCylindrical{Hyper,Shift,Datum}(x::Len, y::Len) where {Hyper,Shift,Datum} =
  EqualAreaCylindrical{Hyper,Shift,Datum}(uconvert(m, x), uconvert(m, y))
EqualAreaCylindrical{Hyper,Shift,Datum}(x::Number, y::Number) where {Hyper,Shift,Datum} =
  EqualAreaCylindrical{Hyper,Shift,Datum}(addunit(x, m), addunit(y, m))

EqualAreaCylindrical{Hyper,Shift}(args...) where {Hyper,Shift} = EqualAreaCylindrical{Hyper,Shift,WGS84Latest}(args...)

EqualAreaCylindrical{Hyper}(args...) where {Hyper} = EqualAreaCylindrical{Hyper,Shift(),WGS84Latest}(args...)

Base.convert(
  ::Type{EqualAreaCylindrical{Hyper,Shift,Datum,M}},
  coords::EqualAreaCylindrical{Hyper,Shift,Datum}
) where {Hyper,Shift,Datum,M} = EqualAreaCylindrical{Hyper,Shift,Datum,M}(coords.x, coords.y)

constructor(::Type{<:EqualAreaCylindrical{Hyper,Shift,Datum}}) where {Hyper,Shift,Datum} =
  EqualAreaCylindrical{Hyper,Shift,Datum}

lentype(::Type{<:EqualAreaCylindrical{Hyper,Shift,Datum,M}}) where {Hyper,Shift,Datum,M} = M

==(
  coords₁::EqualAreaCylindrical{Hyper,Shift,Datum},
  coords₂::EqualAreaCylindrical{Hyper,Shift,Datum}
) where {Hyper,Shift,Datum} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

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
const Lambert{Shift,Datum} = EqualAreaCylindrical{EACHyper(latₜₛ = 0.0°),Shift,Datum}

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
const Behrmann{Shift,Datum} = EqualAreaCylindrical{EACHyper(latₜₛ = 30.0°),Shift,Datum}

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
const GallPeters{Shift,Datum} = EqualAreaCylindrical{EACHyper(latₜₛ = 45.0°),Shift,Datum}

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/cea.cpp
# reference formula: https://neacsu.net/docs/geodesy/snyder/3-cylindrical/sect_10/

function formulas(::Type{<:EqualAreaCylindrical{Hyper,Shift,Datum}}, ::Type{T}) where {Hyper,Shift,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₜₛ = T(ustrip(deg2rad(Hyper.latₜₛ)))

  k₀ = cos(ϕₜₛ) / sqrt(1 - e² * sin(ϕₜₛ)^2)

  fx(λ, ϕ) = k₀ * λ

  function fy(λ, ϕ)
    sinϕ = sin(ϕ)
    esinϕ = e * sinϕ
    q = (1 - e²) * (sinϕ / (1 - esinϕ^2) - (1 / 2e) * log((1 - esinϕ) / (1 + esinϕ)))
    q / 2k₀
  end

  fx, fy
end

function backward(::Type{<:EqualAreaCylindrical{Hyper,Shift,Datum}}, x, y) where {Hyper,Shift,Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ϕₜₛ = oftype(x, ustrip(deg2rad(Hyper.latₜₛ)))

  ome² = 1 - e²
  k₀ = cos(ϕₜₛ) / sqrt(1 - e² * sin(ϕₜₛ)^2)
  # same formula as q, but ϕ = 90°
  qₚ = ome² * (1 / ome² - (1 / 2e) * log((1 - e) / (1 + e)))

  λ = x / k₀
  q = 2y * k₀
  β = asin(q / qₚ)
  ϕ = auth2geod(β, e²)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{EqualAreaCylindrical{Hyper,Shift}}, coords::CRS{Datum}) where {Hyper,Shift,Datum} =
  convert(EqualAreaCylindrical{Hyper,Shift,Datum}, coords)

Base.convert(::Type{EqualAreaCylindrical{Hyper}}, coords::CRS) where {Hyper} =
  convert(EqualAreaCylindrical{Hyper,Shift()}, coords)
