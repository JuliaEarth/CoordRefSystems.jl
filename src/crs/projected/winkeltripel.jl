# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct WinkelParams{D<:Deg}
  lat₁::D
end

WinkelParams(; lat₁=0.0°) = WinkelParams(asdeg(lat₁))

struct Winkel{Datum,Params,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Winkel{Datum,Params,Shift}(x::M, y::M) where {Datum,Params,Shift,M<:Met} = Winkel{Datum,Params,Shift,float(M)}(x, y)
Winkel{Datum,Params,Shift}(x::Met, y::Met) where {Datum,Params,Shift} = Winkel{Datum,Params,Shift}(promote(x, y)...)
Winkel{Datum,Params,Shift}(x::Len, y::Len) where {Datum,Params,Shift} =
  Winkel{Datum,Params,Shift}(uconvert(m, x), uconvert(m, y))
Winkel{Datum,Params,Shift}(x::Number, y::Number) where {Datum,Params,Shift} =
  Winkel{Datum,Params,Shift}(addunit(x, m), addunit(y, m))

Winkel{Datum,Params}(args...) where {Datum,Params} = Winkel{Datum,Params,Shift()}(args...)

Base.convert(::Type{Winkel{Datum,Params,Shift,M}}, coords::Winkel{Datum,Params,Shift}) where {Datum,Params,Shift,M} =
  Winkel{Datum,Params,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Winkel{Datum,Params,Shift}}) where {Datum,Params,Shift} = Winkel{Datum,Params,Shift}

lentype(::Type{<:Winkel{Datum,Params,Shift,M}}) where {Datum,Params,Shift,M} = M

==(coords₁::Winkel{Datum,Params,Shift}, coords₂::Winkel{Datum,Params,Shift}) where {Datum,Params,Shift} =
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
const WinkelTripel{Datum,Shift} = Winkel{Datum,WinkelParams(lat₁ = 50.467°),Shift}

WinkelTripel(args...) = WinkelTripel{WGS84Latest}(args...)

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/aitoff.cpp
# reference formula: https://en.wikipedia.org/wiki/Winkel_tripel_projection

function formulas(::Type{<:Winkel{Datum,Params}}, ::Type{T}) where {Datum,Params,T}
  ϕ₁ = T(ustrip(deg2rad(Params.lat₁)))

  function sincα(λ, ϕ)
    α = acos(cos(ϕ) * cos(λ / 2))
    sinc(α / π) # unnormalized sinc
  end

  fx(λ, ϕ) = (λ * cos(ϕ₁) + (2cos(ϕ) * sin(λ / 2)) / sincα(λ, ϕ)) / 2

  fy(λ, ϕ) = (ϕ + sin(ϕ) / sincα(λ, ϕ)) / 2

  fx, fy
end

function backward(C::Type{<:Winkel}, x, y)
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

Base.convert(::Type{WinkelTripel}, coords::CRS{Datum}) where {Datum} = convert(WinkelTripel{Datum}, coords)
