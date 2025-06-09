# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EqualAreaCylindrical{latₜₛ,Datum,Shift}

Equal Area Cylindrical CRS with latitude of true scale `latₜₛ` in degrees, `Datum` and `Shift`.
"""
struct EqualAreaCylindrical{latₜₛ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

EqualAreaCylindrical{latₜₛ,Datum,Shift}(x::M, y::M) where {latₜₛ,Datum,Shift,M<:Met} =
  EqualAreaCylindrical{latₜₛ,Datum,Shift,float(M)}(x, y)
EqualAreaCylindrical{latₜₛ,Datum,Shift}(x::Met, y::Met) where {latₜₛ,Datum,Shift} =
  EqualAreaCylindrical{latₜₛ,Datum,Shift}(promote(x, y)...)
EqualAreaCylindrical{latₜₛ,Datum,Shift}(x::Len, y::Len) where {latₜₛ,Datum,Shift} =
  EqualAreaCylindrical{latₜₛ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
EqualAreaCylindrical{latₜₛ,Datum,Shift}(x::Number, y::Number) where {latₜₛ,Datum,Shift} =
  EqualAreaCylindrical{latₜₛ,Datum,Shift}(addunit(x, m), addunit(y, m))

EqualAreaCylindrical{latₜₛ,Datum}(args...) where {latₜₛ,Datum} = EqualAreaCylindrical{latₜₛ,Datum,Shift()}(args...)

EqualAreaCylindrical{latₜₛ}(args...) where {latₜₛ} = EqualAreaCylindrical{latₜₛ,WGS84Latest}(args...)

Base.convert(
  ::Type{EqualAreaCylindrical{latₜₛ,Datum,Shift,M}},
  coords::EqualAreaCylindrical{latₜₛ,Datum,Shift}
) where {latₜₛ,Datum,Shift,M} = EqualAreaCylindrical{latₜₛ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:EqualAreaCylindrical{latₜₛ,Datum,Shift}}) where {latₜₛ,Datum,Shift} =
  EqualAreaCylindrical{latₜₛ,Datum,Shift}

lentype(::Type{<:EqualAreaCylindrical{latₜₛ,Datum,Shift,M}}) where {latₜₛ,Datum,Shift,M} = M

==(
  coords₁::EqualAreaCylindrical{latₜₛ,Datum,Shift},
  coords₂::EqualAreaCylindrical{latₜₛ,Datum,Shift}
) where {latₜₛ,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

isequalarea(::Type{<:EqualAreaCylindrical}) = true

"""
    LambertCylindrical(x, y)
    LambertCylindrical{Datum}(x, y)

Lambert cylindrical coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
LambertCylindrical(1, 1) # add default units
LambertCylindrical(1m, 1m) # integers are converted converted to floats
LambertCylindrical(1.0km, 1.0km) # length quantities are converted to meters
LambertCylindrical(1.0m, 1.0m)
LambertCylindrical{WGS84Latest}(1.0m, 1.0m)
```

See [ESRI:54034](https://epsg.io/54034).
"""
const LambertCylindrical{Datum,Shift} = EqualAreaCylindrical{0.0°,Datum,Shift}

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
const Behrmann{Datum,Shift} = EqualAreaCylindrical{30.0°,Datum,Shift}

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
const GallPeters{Datum,Shift} = EqualAreaCylindrical{45.0°,Datum,Shift}

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/cea.cpp
# reference formula: https://neacsu.net/docs/geodesy/snyder/3-cylindrical/sect_10/

function formulas(::Type{<:EqualAreaCylindrical{latₜₛ,Datum}}, ::Type{T}) where {latₜₛ,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₜₛ = T(ustrip(deg2rad(latₜₛ)))

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

function backward(::Type{<:EqualAreaCylindrical{latₜₛ,Datum}}, x, y) where {latₜₛ,Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ϕₜₛ = oftype(x, ustrip(deg2rad(latₜₛ)))

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

indomain(::Type{EqualAreaCylindrical{latₜₛ}}, coords::CRS{Datum}) where {latₜₛ,Datum} =
  indomain(EqualAreaCylindrical{latₜₛ,Datum}, coords)

Base.convert(::Type{EqualAreaCylindrical{latₜₛ}}, coords::CRS{Datum}) where {latₜₛ,Datum} =
  convert(EqualAreaCylindrical{latₜₛ,Datum}, coords)
