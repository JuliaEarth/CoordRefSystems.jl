# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Mercator(x, y)
    Mercator{Datum}(x, y)

Mercator coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
Mercator(1, 1) # add default units
Mercator(1m, 1m) # integers are converted converted to floats
Mercator(1.0km, 1.0km) # length quantities are converted to meters
Mercator(1.0m, 1.0m)
Mercator{WGS84Latest}(1.0m, 1.0m)
```

See [EPSG:3395](https://epsg.io/3395).
"""
struct Mercator{Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Mercator{Datum,Shift}(x::M, y::M) where {Datum,Shift,M<:Met} = Mercator{Datum,Shift,float(M)}(x, y)
Mercator{Datum,Shift}(x::Met, y::Met) where {Datum,Shift} = Mercator{Datum,Shift}(promote(x, y)...)
Mercator{Datum,Shift}(x::Len, y::Len) where {Datum,Shift} = Mercator{Datum,Shift}(uconvert(m, x), uconvert(m, y))
Mercator{Datum,Shift}(x::Number, y::Number) where {Datum,Shift} = Mercator{Datum,Shift}(addunit(x, m), addunit(y, m))

Mercator{Datum}(args...) where {Datum} = Mercator{Datum,Shift()}(args...)

Mercator(args...) = Mercator{WGS84Latest}(args...)

Base.convert(::Type{Mercator{Datum,Shift,M}}, coords::Mercator{Datum,Shift}) where {Datum,Shift,M} =
  Mercator{Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Mercator{Datum,Shift}}) where {Datum,Shift} = Mercator{Datum,Shift}

constructor(::Type{<:Mercator{Datum}}) where {Datum} = Mercator{Datum}

constructor(::Type{<:Mercator}) = Mercator

lentype(::Type{<:Mercator{Datum,Shift,M}}) where {Datum,Shift,M} = M

==(coords₁::Mercator{Datum,Shift}, coords₂::Mercator{Datum,Shift}) where {Datum,Shift} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

isconformal(::Type{<:Mercator}) = true

# ------------
# CONVERSIONS
# ------------

function inbounds(::Type{<:Mercator}, λ, ϕ)
  T = typeof(λ)
  -T(π) ≤ λ ≤ T(π) && -T(π) / 2 < ϕ < T(π) / 2
end

function formulas(::Type{<:Mercator{Datum}}, ::Type{T}) where {Datum,T}
  e = T(eccentricity(ellipsoid(Datum)))

  fx(λ, ϕ) = λ

  fy(λ, ϕ) = asinh(tan(ϕ)) - e * atanh(e * sin(ϕ))

  fx, fy
end

function backward(::Type{<:Mercator{Datum}}, x, y) where {Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ome² = 1 - e²

  # τ′(τ)
  function f(τ)
    sqrt1τ² = sqrt(1 + τ^2)
    σ = sinh(e * atanh(e * τ / sqrt1τ²))
    τ * sqrt(1 + σ^2) - σ * sqrt1τ²
  end

  # dτ′/dτ
  df(τ) = (ome² * sqrt(1 + f(τ)^2) * sqrt(1 + τ^2)) / (1 + ome² * τ^2)

  ψ = y
  τ′ = sinh(ψ)
  τ₀ = abs(τ′) > 70 ? (τ′ * exp(e * atanh(e))) : (τ′ / ome²)
  τ = newton(τ -> f(τ) - τ′, df, τ₀, maxiter=5)

  λ = x
  ϕ = atan(τ)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{Mercator}, coords::CRS{Datum}) where {Datum} = indomain(Mercator{Datum}, coords)

Base.convert(::Type{Mercator}, coords::CRS{Datum}) where {Datum} = convert(Mercator{Datum}, coords)
