# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct EqualAreaCylindricalParams{D<:Deg}
  latₜₛ::D
end

EqualAreaCylindricalParams(; latₜₛ=0.0°) = EqualAreaCylindricalParams(asdeg(latₜₛ))

"""
    EqualAreaCylindrical{Datum,Params,Shift}

Equal Area Cylindrical CRS with latitude of true scale `latₜₛ` and longitude origin `lonₒ`
in degrees and a given `Datum`.
"""
struct EqualAreaCylindrical{Datum,Params,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

EqualAreaCylindrical{Datum,Params,Shift}(x::M, y::M) where {Datum,Params,Shift,M<:Met} =
  EqualAreaCylindrical{Datum,Params,Shift,float(M)}(x, y)
EqualAreaCylindrical{Datum,Params,Shift}(x::Met, y::Met) where {Datum,Params,Shift} =
  EqualAreaCylindrical{Datum,Params,Shift}(promote(x, y)...)
EqualAreaCylindrical{Datum,Params,Shift}(x::Len, y::Len) where {Datum,Params,Shift} =
  EqualAreaCylindrical{Datum,Params,Shift}(uconvert(m, x), uconvert(m, y))
EqualAreaCylindrical{Datum,Params,Shift}(x::Number, y::Number) where {Datum,Params,Shift} =
  EqualAreaCylindrical{Datum,Params,Shift}(addunit(x, m), addunit(y, m))

EqualAreaCylindrical{Datum,Params}(args...) where {Datum,Params} = EqualAreaCylindrical{Datum,Params,Shift()}(args...)

Base.convert(
  ::Type{EqualAreaCylindrical{Datum,Params,Shift,M}},
  coords::EqualAreaCylindrical{Datum,Params,Shift}
) where {Datum,Params,Shift,M} = EqualAreaCylindrical{Datum,Params,Shift,M}(coords.x, coords.y)

constructor(::Type{<:EqualAreaCylindrical{Datum,Params,Shift}}) where {Datum,Params,Shift} =
  EqualAreaCylindrical{Datum,Params,Shift}

lentype(::Type{<:EqualAreaCylindrical{Datum,Params,Shift,M}}) where {Datum,Params,Shift,M} = M

==(
  coords₁::EqualAreaCylindrical{Datum,Params,Shift},
  coords₂::EqualAreaCylindrical{Datum,Params,Shift}
) where {Datum,Params,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

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
const Lambert{Datum,Shift} = EqualAreaCylindrical{Datum,EqualAreaCylindricalParams(latₜₛ = 0.0°),Shift}

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
const Behrmann{Datum,Shift} = EqualAreaCylindrical{Datum,EqualAreaCylindricalParams(latₜₛ = 30.0°),Shift}

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
const GallPeters{Datum,Shift} = EqualAreaCylindrical{Datum,EqualAreaCylindricalParams(latₜₛ = 45.0°),Shift}

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

function formulas(::Type{<:EqualAreaCylindrical{Datum,Params}}, ::Type{T}) where {Datum,Params,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₜₛ = T(ustrip(deg2rad(Params.latₜₛ)))

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

function backward(::Type{<:EqualAreaCylindrical{Datum,Params}}, x, y) where {Datum,Params}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ϕₜₛ = oftype(x, ustrip(deg2rad(Params.latₜₛ)))

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

Base.convert(::Type{Lambert}, coords::CRS{Datum}) where {Datum} = convert(Lambert{Datum}, coords)

Base.convert(::Type{Behrmann}, coords::CRS{Datum}) where {Datum} = convert(Behrmann{Datum}, coords)

Base.convert(::Type{GallPeters}, coords::CRS{Datum}) where {Datum} = convert(GallPeters{Datum}, coords)
