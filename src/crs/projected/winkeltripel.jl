# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct Winkel{lat₁,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
  Winkel{lat₁,Datum}(x::M, y::M) where {lat₁,Datum,M<:Met} = new{lat₁,Datum,float(M)}(x, y)
end

Winkel{lat₁,Datum}(x::Met, y::Met) where {lat₁,Datum} = Winkel{lat₁,Datum}(promote(x, y)...)
Winkel{lat₁,Datum}(x::Len, y::Len) where {lat₁,Datum} = Winkel{lat₁,Datum}(uconvert(u"m", x), uconvert(u"m", y))
Winkel{lat₁,Datum}(x::Number, y::Number) where {lat₁,Datum} = Winkel{lat₁,Datum}(addunit(x, u"m"), addunit(y, u"m"))

Winkel{lat₁}(args...) where {lat₁} = Winkel{lat₁,WGS84}(args...)

"""
    WinkelTripel(x, y)
    WinkelTripel{Datum}(x, y)

Winkel Tripel coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
WinkelTripel(1, 1) # add default units
WinkelTripel(1u"m", 1u"m") # integers are converted converted to floats
WinkelTripel(1.0u"km", 1.0u"km") # length quantities are converted to meters
WinkelTripel(1.0u"m", 1.0u"m")
WinkelTripel{WGS84}(1.0u"m", 1.0u"m")
```

See [ESRI:54042](https://epsg.io/54042).
"""
const WinkelTripel{Datum} = Winkel{50.467u"°",Datum}

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/aitoff.cpp
# reference formula: https://en.wikipedia.org/wiki/Winkel_tripel_projection

function formulas(::Type{<:Winkel{lat₁,Datum}}, ::Type{T}) where {lat₁,Datum,T}
  ϕ₁ = T(ustrip(deg2rad(lat₁)))

  function sincα(λ, ϕ)
    α = acos(cos(ϕ) * cos(λ / 2))
    sinc(α / π) # unnormalized sinc
  end

  fx(λ, ϕ) = (λ * cos(ϕ₁) + (2cos(ϕ) * sin(λ / 2)) / sincα(λ, ϕ)) / 2

  fy(λ, ϕ) = (ϕ + sin(ϕ) / sincα(λ, ϕ)) / 2

  fx, fy
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {lat₁,Datum,C<:Winkel{lat₁,Datum}}
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  x = coords.x / a
  y = coords.y / a
  tol = atol(T)
  λ, ϕ = if abs(x) < tol && abs(y) < tol
    zero(T), zero(T)
  else
    fx, fy = formulas(C, T)
    projinv(fx, fy, x, y, x, y; tol)
  end
  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end
