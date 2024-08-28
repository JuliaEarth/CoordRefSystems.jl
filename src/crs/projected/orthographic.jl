# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Orthographic{S,latₒ,Datum,Shift}

Orthographic CRS with spherical mode `S` enabled or not, latitude origin `latₒ`, `Datum` and `Shift`.
"""
struct Orthographic{S,latₒ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Orthographic{S,latₒ,Datum,Shift}(x::M, y::M) where {S,latₒ,Datum,Shift,M<:Met} =
  Orthographic{S,latₒ,Datum,Shift,float(M)}(x, y)
Orthographic{S,latₒ,Datum,Shift}(x::Met, y::Met) where {S,latₒ,Datum,Shift} =
  Orthographic{S,latₒ,Datum,Shift}(promote(x, y)...)
Orthographic{S,latₒ,Datum,Shift}(x::Len, y::Len) where {S,latₒ,Datum,Shift} =
  Orthographic{S,latₒ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
Orthographic{S,latₒ,Datum,Shift}(x::Number, y::Number) where {S,latₒ,Datum,Shift} =
  Orthographic{S,latₒ,Datum,Shift}(addunit(x, m), addunit(y, m))

Orthographic{S,latₒ,Datum}(args...) where {S,latₒ,Datum} = Orthographic{S,latₒ,Datum,Shift()}(args...)

Orthographic{S,latₒ}(args...) where {S,latₒ} = Orthographic{S,latₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{Orthographic{S,latₒ,Datum,Shift,M}},
  coords::Orthographic{S,latₒ,Datum,Shift}
) where {S,latₒ,Datum,Shift,M} = Orthographic{S,latₒ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Orthographic{S,latₒ,Datum,Shift}}) where {S,latₒ,Datum,Shift} = Orthographic{S,latₒ,Datum,Shift}

lentype(::Type{<:Orthographic{S,latₒ,Datum,Shift,M}}) where {S,latₒ,Datum,Shift,M} = M

==(coords₁::Orthographic{S,latₒ,Datum,Shift}, coords₂::Orthographic{S,latₒ,Datum,Shift}) where {S,latₒ,Datum,Shift} =
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
const OrthoNorth{Datum,Shift} = Orthographic{false,90°,Datum,Shift}

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
const OrthoSouth{Datum,Shift} = Orthographic{false,-90°,Datum,Shift}

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

function inbounds(::Type{<:Orthographic{S,latₒ}}, λ, ϕ) where {S,latₒ}
  ϕₒ = ustrip(deg2rad(latₒ))
  c = acos(sin(ϕₒ) * sin(ϕ) + cos(ϕₒ) * cos(ϕ) * cos(λ))
  -π / 2 < c < π / 2
end

inbounds(::Type{<:OrthoNorth}, λ, ϕ) = -π ≤ λ ≤ π && 0 ≤ ϕ ≤ π / 2

inbounds(::Type{<:OrthoSouth}, λ, ϕ) = -π ≤ λ ≤ π && -π / 2 ≤ ϕ ≤ 0

function formulas(::Type{<:Orthographic{false,latₒ,Datum}}, ::Type{T}) where {latₒ,Datum,T}
  ϕₒ = T(ustrip(deg2rad(latₒ)))
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

function formulas(::Type{<:Orthographic{true,latₒ,Datum}}, ::Type{T}) where {latₒ,Datum,T}
  ϕₒ = T(ustrip(deg2rad(latₒ)))

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

function backward(C::Type{<:Orthographic{true,latₒ}}, x, y) where {latₒ}
  T = typeof(x)
  λₒ = T(ustrip(deg2rad(projshift(C).lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  sphericalinv(x, y, λₒ, ϕₒ)
end

function backward(C::Type{<:Orthographic{false,latₒ}}, x, y) where {latₒ}
  T = typeof(x)
  λₒ = T(ustrip(deg2rad(projshift(C).lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  λₛ, ϕₛ = sphericalinv(x, y, λₒ, ϕₒ)
  fx, fy = formulas(C, T)
  projinv(fx, fy, x, y, λₛ, ϕₛ)
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Orthographic{S,latₒ}}, coords::CRS{Datum}) where {S,latₒ,Datum} =
  convert(Orthographic{S,latₒ,Datum}, coords)
