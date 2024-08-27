# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    OrthographicParams(; latₒ=0.0°)

Orthographic parameters with a given latitude origin `latₒ`.
"""
struct OrthographicParams{D<:Deg}
  latₒ::D
end

OrthographicParams(; latₒ=0.0°) = OrthographicParams(asdeg(latₒ))

"""
    Orthographic{S,Datum,Params,Shift}

Orthographic CRS with spherical mode `S` enabled or not, `Datum`, `Params` and `Shift`.
"""
struct Orthographic{S,Datum,Params,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Orthographic{S,Datum,Params,Shift}(x::M, y::M) where {S,Datum,Params,Shift,M<:Met} =
  Orthographic{S,Datum,Params,Shift,float(M)}(x, y)
Orthographic{S,Datum,Params,Shift}(x::Met, y::Met) where {S,Datum,Params,Shift} =
  Orthographic{S,Datum,Params,Shift}(promote(x, y)...)
Orthographic{S,Datum,Params,Shift}(x::Len, y::Len) where {S,Datum,Params,Shift} =
  Orthographic{S,Datum,Params,Shift}(uconvert(m, x), uconvert(m, y))
Orthographic{S,Datum,Params,Shift}(x::Number, y::Number) where {S,Datum,Params,Shift} =
  Orthographic{S,Datum,Params,Shift}(addunit(x, m), addunit(y, m))

Orthographic{S,Datum,Params}(args...) where {S,Datum,Params} = Orthographic{S,Datum,Params,Shift()}(args...)

Base.convert(
  ::Type{Orthographic{S,Datum,Params,Shift,M}},
  coords::Orthographic{S,Datum,Params,Shift}
) where {S,Datum,Params,Shift,M} = Orthographic{S,Datum,Params,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Orthographic{S,Datum,Params,Shift}}) where {S,Datum,Params,Shift} = Orthographic{S,Datum,Params,Shift}

lentype(::Type{<:Orthographic{S,Datum,Params,Shift,M}}) where {S,Datum,Params,Shift,M} = M

==(coords₁::Orthographic{S,Datum,Params,Shift}, coords₂::Orthographic{S,Datum,Params,Shift}) where {S,Datum,Params,Shift} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

"""
    OrthoNorth(x, y)
    OrthoNorth{Datum}(x, y)

Orthographic North Pole coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
OrthoNorth(1, 1) # add default units
OrthoNorth(1m, 1m) # integers are converted converted to floats
OrthoNorth(1.0km, 1.0km) # length quantities are converted to meters
OrthoNorth(1.0m, 1.0m)
OrthoNorth{WGS84Latest}(1.0m, 1.0m)
```
"""
const OrthoNorth{Datum,Shift} = Orthographic{false,Datum,OrthographicParams(latₒ = 90°),Shift}

OrthoNorth(args...) = OrthoNorth{WGS84Latest}(args...)

"""
    OrthoSouth(x, y)
    OrthoSouth{Datum}(x, y)

Orthographic South Pole coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
OrthoSouth(1, 1) # add default units
OrthoSouth(1m, 1m) # integers are converted converted to floats
OrthoSouth(1.0km, 1.0km) # length quantities are converted to meters
OrthoSouth(1.0m, 1.0m)
OrthoSouth{WGS84Latest}(1.0m, 1.0m)
```
"""
const OrthoSouth{Datum,Shift} = Orthographic{false,Datum,OrthographicParams(latₒ = -90°),Shift}

OrthoSouth(args...) = OrthoSouth{WGS84Latest}(args...)

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.
# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/robin.cpp
# reference formulas: https://neacsu.net/docs/geodesy/snyder/5-azimuthal/sect_20/
#                     https://mathworld.wolfram.com/OrthographicProjection.html
#                     https://epsg.org/guidance-notes.html

function inbounds(::Type{<:Orthographic{S,Datum,Params}}, λ, ϕ) where {S,Datum,Params}
  ϕₒ = ustrip(deg2rad(Params.latₒ))
  c = acos(sin(ϕₒ) * sin(ϕ) + cos(ϕₒ) * cos(ϕ) * cos(λ))
  -π / 2 < c < π / 2
end

inbounds(::Type{<:OrthoNorth}, λ, ϕ) = -π ≤ λ ≤ π && 0 ≤ ϕ ≤ π / 2

inbounds(::Type{<:OrthoSouth}, λ, ϕ) = -π ≤ λ ≤ π && -π / 2 ≤ ϕ ≤ 0

function formulas(::Type{<:Orthographic{false,Datum,Params}}, ::Type{T}) where {Datum,Params,T}
  ϕₒ = T(ustrip(deg2rad(Params.latₒ)))
  e² = T(eccentricity²(ellipsoid(Datum)))

  sinϕₒ = sin(ϕₒ)
  cosϕₒ = cos(ϕₒ)
  ν(ϕ) = 1 / sqrt(1 - e² * sin(ϕ)^2)
  νₒ = ν(ϕₒ)

  fx(λ, ϕ) = ν(ϕ) * cos(ϕ) * sin(λ)

  function fy(λ, ϕ)
    νϕ = ν(ϕ)
    sinϕ = sin(ϕ)
    cosϕ = cos(ϕ)
    νϕ * (sinϕ * cosϕₒ - cosϕ * sinϕₒ * cos(λ)) + e² * (νₒ * sinϕₒ - νϕ * sinϕ) * cosϕₒ
  end

  fx, fy
end

function formulas(::Type{<:Orthographic{true,Datum,Params}}, ::Type{T}) where {Datum,Params,T}
  ϕₒ = T(ustrip(deg2rad(Params.latₒ)))

  fx(λ, ϕ) = cos(ϕ) * sin(λ)

  fy(λ, ϕ) = sin(ϕ) * cos(ϕₒ) - cos(ϕ) * sin(ϕₒ) * cos(λ)

  fx, fy
end

function sphericalinv(x, y, λₒ, ϕₒ)
  fix(x) = clamp(x, -one(x), one(x))
  ρ = hypot(x, y)
  if ρ < atol(x)
    λₒ, ϕₒ
  else
    c = asin(fix(ρ))
    sinc = sin(c)
    cosc = cos(c)
    sinϕₒ = sin(ϕₒ)
    cosϕₒ = cos(ϕₒ)
    λ = atan(x * sinc, ρ * cosϕₒ * cosc - y * sinϕₒ * sinc)
    ϕ = asin(fix(cosc * sinϕₒ + (y * sinc * cosϕₒ / ρ)))
    λ, ϕ
  end
end

function backward(::Type{<:Orthographic{true,Datum,Params}}, x, y) where {Datum,Params}
  Shift = projshift(C)
  T = typeof(x)
  λₒ = T(ustrip(deg2rad(Shift.lonₒ)))
  ϕₒ = T(ustrip(deg2rad(Params.latₒ)))
  sphericalinv(x, y, λₒ, ϕₒ)
end

function backward(C::Type{<:Orthographic{false,Datum,Params}}, x, y) where {Datum,Params}
  Shift = projshift(C)
  T = typeof(x)
  λₒ = T(ustrip(deg2rad(Shift.lonₒ)))
  ϕₒ = T(ustrip(deg2rad(Params.latₒ)))
  λₛ, ϕₛ = sphericalinv(x, y, λₒ, ϕₒ)
  fx, fy = formulas(C, T)
  projinv(fx, fy, x, y, λₛ, ϕₛ)
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{OrthoNorth}, coords::CRS{Datum}) where {Datum} = convert(OrthoNorth{Datum}, coords)

Base.convert(::Type{OrthoSouth}, coords::CRS{Datum}) where {Datum} = convert(OrthoSouth{Datum}, coords)
