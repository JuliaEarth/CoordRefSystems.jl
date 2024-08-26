# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct WinkelHyper{D<:Deg}
  lat₁::D
end

WinkelHyper(; lat₁=0.0°) = WinkelHyper(asdeg(lat₁))

struct Winkel{Hyper,Shift,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
end

Winkel{Hyper,Shift,Datum}(x::M, y::M) where {Hyper,Shift,Datum,M<:Met} = Winkel{Hyper,Shift,Datum,float(M)}(x, y)
Winkel{Hyper,Shift,Datum}(x::Met, y::Met) where {Hyper,Shift,Datum} = Winkel{Hyper,Shift,Datum}(promote(x, y)...)
Winkel{Hyper,Shift,Datum}(x::Len, y::Len) where {Hyper,Shift,Datum} =
  Winkel{Hyper,Shift,Datum}(uconvert(m, x), uconvert(m, y))
Winkel{Hyper,Shift,Datum}(x::Number, y::Number) where {Hyper,Shift,Datum} =
  Winkel{Hyper,Shift,Datum}(addunit(x, m), addunit(y, m))

Winkel{Hyper,Shift}(args...) where {Hyper,Shift} = Winkel{Hyper,Shift,WGS84Latest}(args...)

Winkel{Hyper}(args...) where {Hyper} = Winkel{Hyper,Shift(),WGS84Latest}(args...)

Base.convert(::Type{Winkel{Hyper,Shift,Datum,M}}, coords::Winkel{Hyper,Shift,Datum}) where {Hyper,Shift,Datum,M} =
  Winkel{Hyper,Shift,Datum,M}(coords.x, coords.y)

constructor(::Type{<:Winkel{Hyper,Shift,Datum}}) where {Hyper,Shift,Datum} = Winkel{Hyper,Shift,Datum}

lentype(::Type{<:Winkel{Hyper,Shift,Datum,M}}) where {Hyper,Shift,Datum,M} = M

==(coords₁::Winkel{Hyper,Shift,Datum}, coords₂::Winkel{Hyper,Shift,Datum}) where {Hyper,Shift,Datum} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

"""
    WinkelTripel(x, y)
    WinkelTripel{Datum}(x, y)

Winkel Tripel coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
WinkelTripel(1, 1) # add default units
WinkelTripel(1m, 1m) # integers are converted converted to floats
WinkelTripel(1.0km, 1.0km) # length quantities are converted to meters
WinkelTripel(1.0m, 1.0m)
WinkelTripel{WGS84Latest}(1.0m, 1.0m)
```

See [ESRI:54042](https://epsg.io/54042).
"""
const WinkelTripel{Shift,Datum} = Winkel{WinkelHyper(lat₁ = 50.467°),Shift,Datum}

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/aitoff.cpp
# reference formula: https://en.wikipedia.org/wiki/Winkel_tripel_projection

function formulas(::Type{<:Winkel{Hyper}}, ::Type{T}) where {Hyper,T}
  ϕ₁ = T(ustrip(deg2rad(Hyper.lat₁)))

  function sincα(λ, ϕ)
    α = acos(cos(ϕ) * cos(λ / 2))
    sinc(α / π) # unnormalized sinc
  end

  fx(λ, ϕ) = (λ * cos(ϕ₁) + (2cos(ϕ) * sin(λ / 2)) / sincα(λ, ϕ)) / 2

  fy(λ, ϕ) = (ϕ + sin(ϕ) / sincα(λ, ϕ)) / 2

  fx, fy
end

function backward(::Type{<:Winkel{Hyper}}, x, y) where {Hyper}
  T = typeof(x)
  tol = atol(T)
  if abs(x) < tol && abs(y) < tol
    zero(T), zero(T)
  else
    fx, fy = formulas(C, T)
    projinv(fx, fy, x, y, x, y; tol)
  end
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Winkel{Hyper,Shift}}, coords::CRS{Datum}) where {Hyper,Shift,Datum} =
  convert(Winkel{Hyper,Shift,Datum}, coords)

Base.convert(::Type{Winkel{Hyper}}, coords::CRS) where {Hyper} = convert(Winkel{Hyper,Shift()}, coords)
