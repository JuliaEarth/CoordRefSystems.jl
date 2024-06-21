# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Orthographic{latₒ,lonₒ,S,Datum}

Orthographic CRS with latitude origin `latₒ` and longitude origin `lonₒ` in degrees,
spherical mode `S` enabled or not and a given `Datum`.
"""
struct Orthographic{latₒ,lonₒ,S,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
end

Orthographic{latₒ,lonₒ,S,Datum}(x::M, y::M) where {latₒ,lonₒ,S,Datum,M<:Met} =
  Orthographic{latₒ,lonₒ,S,Datum,float(M)}(x, y)
Orthographic{latₒ,lonₒ,S,Datum}(x::Met, y::Met) where {latₒ,lonₒ,S,Datum} =
  Orthographic{latₒ,lonₒ,S,Datum}(promote(x, y)...)
Orthographic{latₒ,lonₒ,S,Datum}(x::Len, y::Len) where {latₒ,lonₒ,S,Datum} =
  Orthographic{latₒ,lonₒ,S,Datum}(uconvert(u"m", x), uconvert(u"m", y))
Orthographic{latₒ,lonₒ,S,Datum}(x::Number, y::Number) where {latₒ,lonₒ,S,Datum} =
  Orthographic{latₒ,lonₒ,S,Datum}(addunit(x, u"m"), addunit(y, u"m"))

Orthographic{latₒ,lonₒ,S}(args...) where {latₒ,lonₒ,S} = Orthographic{latₒ,lonₒ,S,WGS84Latest}(args...)

Base.convert(
  ::Type{Orthographic{latₒ,lonₒ,S,Datum,M}},
  coords::Orthographic{latₒ,lonₒ,S,Datum}
) where {latₒ,lonₒ,S,Datum,M} = Orthographic{latₒ,lonₒ,S,Datum,M}(coords.x, coords.y)

lentype(::Type{<:Orthographic{latₒ,lonₒ,S,Datum,M}}) where {latₒ,lonₒ,S,Datum,M} = M

constructor(::Type{<:Orthographic{latₒ,lonₒ,S,Datum}}) where {latₒ,lonₒ,S,Datum} = Orthographic{latₒ,lonₒ,S,Datum}

"""
    OrthoNorth(x, y)
    OrthoNorth{Datum}(x, y)

Orthographic North Pole coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
OrthoNorth(1, 1) # add default units
OrthoNorth(1u"m", 1u"m") # integers are converted converted to floats
OrthoNorth(1.0u"km", 1.0u"km") # length quantities are converted to meters
OrthoNorth(1.0u"m", 1.0u"m")
OrthoNorth{WGS84Latest}(1.0u"m", 1.0u"m")
```
"""
const OrthoNorth{Datum} = Orthographic{90.0u"°",0.0u"°",false,Datum}

"""
    OrthoSouth(x, y)
    OrthoSouth{Datum}(x, y)

Orthographic South Pole coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
OrthoSouth(1, 1) # add default units
OrthoSouth(1u"m", 1u"m") # integers are converted converted to floats
OrthoSouth(1.0u"km", 1.0u"km") # length quantities are converted to meters
OrthoSouth(1.0u"m", 1.0u"m")
OrthoSouth{WGS84Latest}(1.0u"m", 1.0u"m")
```
"""
const OrthoSouth{Datum} = Orthographic{-90.0u"°",0.0u"°",false,Datum}

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

function inbounds(::Type{<:Orthographic{latₒ,lonₒ}}, λ, ϕ) where {latₒ,lonₒ}
  λₒ = ustrip(deg2rad(lonₒ))
  ϕₒ = ustrip(deg2rad(latₒ))
  c = acos(sin(ϕₒ) * sin(ϕ) + cos(ϕₒ) * cos(ϕ) * cos(λ - λₒ))
  -π / 2 < c < π / 2
end

inbounds(::Type{<:OrthoNorth}, λ, ϕ) = -π ≤ λ ≤ π && 0 ≤ ϕ ≤ π / 2

inbounds(::Type{<:OrthoSouth}, λ, ϕ) = -π ≤ λ ≤ π && -π / 2 ≤ ϕ ≤ 0

function formulas(::Type{<:Orthographic{latₒ,lonₒ,false,Datum}}, ::Type{T}) where {latₒ,lonₒ,Datum,T}
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  e² = T(eccentricity²(ellipsoid(Datum)))

  sinϕₒ = sin(ϕₒ)
  cosϕₒ = cos(ϕₒ)
  ν(ϕ) = 1 / sqrt(1 - e² * sin(ϕ)^2)
  νₒ = ν(ϕₒ)

  fx(λ, ϕ) = ν(ϕ) * cos(ϕ) * sin(λ - λₒ)

  function fy(λ, ϕ)
    νϕ = ν(ϕ)
    sinϕ = sin(ϕ)
    cosϕ = cos(ϕ)
    νϕ * (sinϕ * cosϕₒ - cosϕ * sinϕₒ * cos(λ - λₒ)) + e² * (νₒ * sinϕₒ - νϕ * sinϕ) * cosϕₒ
  end

  fx, fy
end

function formulas(::Type{<:Orthographic{latₒ,lonₒ,true,Datum}}, ::Type{T}) where {latₒ,lonₒ,Datum,T}
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))

  fx(λ, ϕ) = cos(ϕ) * sin(λ - λₒ)

  fy(λ, ϕ) = sin(ϕ) * cos(ϕₒ) - cos(ϕ) * sin(ϕₒ) * cos(λ - λₒ)

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
    λ = λₒ + atan(x * sinc, ρ * cosϕₒ * cosc - y * sinϕₒ * sinc)
    ϕ = asin(fix(cosc * sinϕₒ + (y * sinc * cosϕₒ / ρ)))
    λ, ϕ
  end
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {latₒ,lonₒ,Datum,C<:Orthographic{latₒ,lonₒ,true,Datum}}
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  x = coords.x / a
  y = coords.y / a
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  λ, ϕ = sphericalinv(x, y, λₒ, ϕₒ)
  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {latₒ,lonₒ,Datum,C<:Orthographic{latₒ,lonₒ,false,Datum}}
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  x = coords.x / a
  y = coords.y / a
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  λₛ, ϕₛ = sphericalinv(x, y, λₒ, ϕₒ)
  fx, fy = formulas(C, T)
  λ, ϕ = projinv(fx, fy, x, y, λₛ, ϕₛ)
  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Orthographic{latₒ,lonₒ,S}}, coords::LatLon{Datum}) where {latₒ,lonₒ,S,Datum} =
  convert(Orthographic{latₒ,lonₒ,S,Datum}, coords)

Base.convert(::Type{LatLon}, coords::Orthographic{latₒ,lonₒ,S,Datum}) where {latₒ,lonₒ,S,Datum} =
  convert(LatLon{Datum}, coords)
