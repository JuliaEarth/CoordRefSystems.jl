# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Winkel{lat₁,Datum,Shift}

Winkel CRS with first standard parallel `lat₁`, `Datum` and `Shift`.
"""
struct Winkel{lat₁,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Winkel{lat₁,Datum,Shift}(x::M, y::M) where {lat₁,Datum,Shift,M<:Met} = Winkel{lat₁,Datum,Shift,float(M)}(x, y)
Winkel{lat₁,Datum,Shift}(x::Met, y::Met) where {lat₁,Datum,Shift} = Winkel{lat₁,Datum,Shift}(promote(x, y)...)
Winkel{lat₁,Datum,Shift}(x::Len, y::Len) where {lat₁,Datum,Shift} =
  Winkel{lat₁,Datum,Shift}(uconvert(m, x), uconvert(m, y))
Winkel{lat₁,Datum,Shift}(x::Number, y::Number) where {lat₁,Datum,Shift} =
  Winkel{lat₁,Datum,Shift}(addunit(x, m), addunit(y, m))

Winkel{lat₁,Datum}(args...) where {lat₁,Datum} = Winkel{lat₁,Datum,Shift()}(args...)

Winkel{lat₁}(args...) where {lat₁} = Winkel{lat₁,WGS84Latest}(args...)

Base.convert(::Type{Winkel{lat₁,Datum,Shift,M}}, coords::Winkel{lat₁,Datum,Shift}) where {lat₁,Datum,Shift,M} =
  Winkel{lat₁,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Winkel{lat₁,Datum,Shift}}) where {lat₁,Datum,Shift} = Winkel{lat₁,Datum,Shift}

lentype(::Type{<:Winkel{lat₁,Datum,Shift,M}}) where {lat₁,Datum,Shift,M} = M

==(coords₁::Winkel{lat₁,Datum,Shift}, coords₂::Winkel{lat₁,Datum,Shift}) where {lat₁,Datum,Shift} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

iscompromise(::Type{<:Winkel}) = true

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
const WinkelTripel{Datum,Shift} = Winkel{50.467°,Datum,Shift}

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

indomain(::Type{Winkel{lat₁}}, coords::CRS{Datum}) where {lat₁,Datum} = indomain(Winkel{lat₁,Datum}, coords)

Base.convert(::Type{Winkel{lat₁}}, coords::CRS{Datum}) where {lat₁,Datum} = convert(Winkel{lat₁,Datum}, coords)
