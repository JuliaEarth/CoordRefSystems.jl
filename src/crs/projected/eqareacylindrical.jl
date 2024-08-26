# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EqualAreaCylindrical{Datum,Hyper,Shift}

Equal Area Cylindrical CRS with latitude of true scale `latₜₛ` and longitude origin `lonₒ`
in degrees and a given `Datum`.
"""
struct EqualAreaCylindrical{Datum,Hyper,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

struct EACHyper{D}
  latₜₛ::D
end

EACHyper(; latₜₛ=0.0°) = EACHyper(asdeg(latₜₛ))

EqualAreaCylindrical{Datum,Hyper,Shift}(x::M, y::M) where {Datum,Hyper,Shift,M<:Met} =
  EqualAreaCylindrical{Datum,Hyper,Shift,float(M)}(x, y)
EqualAreaCylindrical{Datum,Hyper,Shift}(x::Met, y::Met) where {Datum,Hyper,Shift} =
  EqualAreaCylindrical{Datum,Hyper,Shift}(promote(x, y)...)
EqualAreaCylindrical{Datum,Hyper,Shift}(x::Len, y::Len) where {Datum,Hyper,Shift} =
  EqualAreaCylindrical{Datum,Hyper,Shift}(uconvert(m, x), uconvert(m, y))
EqualAreaCylindrical{Datum,Hyper,Shift}(x::Number, y::Number) where {Datum,Hyper,Shift} =
  EqualAreaCylindrical{Datum,Hyper,Shift}(addunit(x, m), addunit(y, m))

EqualAreaCylindrical{Datum,Hyper}(args...) where {Datum,Hyper} = EqualAreaCylindrical{Datum,Hyper,Shift()}(args...)

Base.convert(
  ::Type{EqualAreaCylindrical{Datum,Hyper,Shift,M}},
  coords::EqualAreaCylindrical{Datum,Hyper,Shift}
) where {Datum,Hyper,Shift,M} = EqualAreaCylindrical{Datum,Hyper,Shift,M}(coords.x, coords.y)

constructor(::Type{<:EqualAreaCylindrical{Datum,Hyper,Shift}}) where {Datum,Hyper,Shift} =
  EqualAreaCylindrical{Datum,Hyper,Shift}

lentype(::Type{<:EqualAreaCylindrical{Datum,Hyper,Shift,M}}) where {Datum,Hyper,Shift,M} = M

==(
  coords₁::EqualAreaCylindrical{Datum,Hyper,Shift},
  coords₂::EqualAreaCylindrical{Datum,Hyper,Shift}
) where {Datum,Hyper,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

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
const Lambert{Datum} = EqualAreaCylindrical{Datum,EACHyper(latₜₛ=0.0°)}

Lambert(args...) = Lambert{WGS84Latest}(args...)

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
const Behrmann{Datum} = EqualAreaCylindrical{Datum,EACHyper(latₜₛ=30.0°)}

Behrmann(args...) = Behrmann{WGS84Latest}(args...)

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
const GallPeters{Datum} = EqualAreaCylindrical{Datum,EACHyper(latₜₛ=45.0°)}

GallPeters(args...) = GallPeters{WGS84Latest}(args...)

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/cea.cpp
# reference formula: https://neacsu.net/docs/geodesy/snyder/3-cylindrical/sect_10/

function formulas(::Type{<:EqualAreaCylindrical{Datum,Hyper}}, ::Type{T}) where {Datum,Hyper,T}
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

function backward(::Type{<:EqualAreaCylindrical{Datum,Hyper}}, x, y) where {Datum,Hyper}
  🌎 = ellipsoid(Datum)
  e = convert(numtype(x), eccentricity(🌎))
  e² = convert(numtype(x), eccentricity²(🌎))
  ϕₜₛ = numconvert(numtype(x), deg2rad(latₜₛ))

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

Base.convert(::Type{EqualAreaCylindrical{Datum,Hyper}}, coords::CRS{Datum}) where {Datum,Hyper} =
  convert(EqualAreaCylindrical{Datum,Hyper,Shift()}, coords)
