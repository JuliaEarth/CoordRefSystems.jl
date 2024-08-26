# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct OrthoHyper{D<:Deg}
  latₒ::D
end

OrthoHyper(; latₒ=0.0°) = OrthoHyper(asdeg(latₒ))

"""
    Orthographic{S,Hyper,Shift,Datum}

Orthographic CRS with latitude origin `latₒ` and longitude origin `lonₒ` in degrees,
spherical mode `S` enabled or not and a given `Datum`.
"""
struct Orthographic{S,Hyper,Shift,Datum,M<:Met} <: Projected{Shift,Datum}
  x::M
  y::M
end

Orthographic{S,Hyper,Shift,Datum}(x::M, y::M) where {S,Hyper,Shift,Datum,M<:Met} =
  Orthographic{S,Hyper,Shift,Datum,float(M)}(x, y)
Orthographic{S,Hyper,Shift,Datum}(x::Met, y::Met) where {S,Hyper,Shift,Datum} =
  Orthographic{S,Hyper,Shift,Datum}(promote(x, y)...)
Orthographic{S,Hyper,Shift,Datum}(x::Len, y::Len) where {S,Hyper,Shift,Datum} =
  Orthographic{S,Hyper,Shift,Datum}(uconvert(m, x), uconvert(m, y))
Orthographic{S,Hyper,Shift,Datum}(x::Number, y::Number) where {S,Hyper,Shift,Datum} =
  Orthographic{S,Hyper,Shift,Datum}(addunit(x, m), addunit(y, m))

Orthographic{S,Hyper,Shift}(args...) where {S,Hyper,Shift} = Orthographic{S,Hyper,Shift,WGS84Latest}(args...)

Orthographic{S,Hyper}(args...) where {S,Hyper} = Orthographic{S,Hyper,Shift(),WGS84Latest}(args...)

Base.convert(
  ::Type{Orthographic{S,Hyper,Shift,Datum,M}},
  coords::Orthographic{S,Hyper,Shift,Datum}
) where {S,Hyper,Shift,Datum,M} = Orthographic{S,Hyper,Shift,Datum,M}(coords.x, coords.y)

constructor(::Type{<:Orthographic{S,Hyper,Shift,Datum}}) where {S,Hyper,Shift,Datum} = Orthographic{S,Hyper,Shift,Datum}

lentype(::Type{<:Orthographic{S,Hyper,Shift,Datum,M}}) where {S,Hyper,Shift,Datum,M} = M

==(coords₁::Orthographic{S,Hyper,Shift,Datum}, coords₂::Orthographic{S,Hyper,Shift,Datum}) where {S,Hyper,Shift,Datum} =
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
const OrthoNorth{Shift,Datum} = Orthographic{false,OrthoHyper(latₒ = 90°),Shift,Datum}

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
const OrthoSouth{Shift,Datum} = Orthographic{false,OrthoHyper(latₒ = -90°),Shift,Datum}

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

function inbounds(::Type{<:Orthographic{S,Hyper}}, λ, ϕ) where {S,Hyper}
  ϕₒ = ustrip(deg2rad(Hyper.latₒ))
  c = acos(sin(ϕₒ) * sin(ϕ) + cos(ϕₒ) * cos(ϕ) * cos(λ))
  -π / 2 < c < π / 2
end

inbounds(::Type{<:OrthoNorth}, λ, ϕ) = -π ≤ λ ≤ π && 0 ≤ ϕ ≤ π / 2

inbounds(::Type{<:OrthoSouth}, λ, ϕ) = -π ≤ λ ≤ π && -π / 2 ≤ ϕ ≤ 0

function formulas(::Type{<:Orthographic{false,Hyper,Shift,Datum}}, ::Type{T}) where {Hyper,Shift,Datum,T}
  ϕₒ = T(ustrip(deg2rad(Hyper.latₒ)))
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

function formulas(::Type{<:Orthographic{true,Hyper,Shift,Datum}}, ::Type{T}) where {Hyper,Shift,Datum,T}
  ϕₒ = T(ustrip(deg2rad(Hyper.latₒ)))

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

function backward(::Type{<:Orthographic{true,Hyper,Shift,Datum}}, x, y)
  λₒ = oftype(x, ustrip(deg2rad(Shift.lonₒ)))
  ϕₒ = oftype(x, ustrip(deg2rad(Hyper.latₒ)))
  sphericalinv(x, y, λₒ, ϕₒ)
end

function backward(::Type{<:Orthographic{true,Hyper,Shift,Datum}}, x, y)
  λₒ = oftype(x, ustrip(deg2rad(Shift.lonₒ)))
  ϕₒ = oftype(x, ustrip(deg2rad(Hyper.latₒ)))
  λₛ, ϕₛ = sphericalinv(x, y, λₒ, ϕₒ)
  fx, fy = formulas(C, T)
  projinv(fx, fy, x, y, λₛ, ϕₛ)
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Orthographic{S,Hyper,Shift}}, coords::CRS{Datum}) where {S,Hyper,Shift,Datum} =
  convert(Orthographic{S,Hyper,Shift,Datum}, coords)

Base.convert(::Type{Orthographic{S,Hyper}}, coords::CRS) where {S,Hyper} =
  convert(Orthographic{S,Hyper,Shift()}, coords)
