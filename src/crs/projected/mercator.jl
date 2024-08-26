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
struct Mercator{Shift,Datum,M<:Met} <: Projected{Shift,Datum}
  x::M
  y::M
end

Mercator{Shift,Datum}(x::M, y::M) where {Shift,Datum,M<:Met} = Mercator{Shift,Datum,float(M)}(x, y)
Mercator{Shift,Datum}(x::Met, y::Met) where {Shift,Datum} = Mercator{Shift,Datum}(promote(x, y)...)
Mercator{Shift,Datum}(x::Len, y::Len) where {Shift,Datum} = Mercator{Shift,Datum}(uconvert(m, x), uconvert(m, y))
Mercator{Shift,Datum}(x::Number, y::Number) where {Shift,Datum} = Mercator{Shift,Datum}(addunit(x, m), addunit(y, m))

Mercator{Shift}(args...) where {Shift} = Mercator{Shift,WGS84Latest}(args...)

Mercator(args...) = Mercator{Shift()}(args...)

Base.convert(::Type{Mercator{Shift,Datum,M}}, coords::Mercator{Shift,Datum}) where {Shift,Datum,M} =
  Mercator{Shift,Datum,M}(coords.x, coords.y)

constructor(::Type{<:Mercator{Shift,Datum}}) where {Shift,Datum} = Mercator{Shift,Datum}

lentype(::Type{<:Mercator{Shift,Datum,M}}) where {Shift,Datum,M} = M

==(coords₁::Mercator{Shift,Datum}, coords₂::Mercator{Shift,Datum}) where {Shift,Datum} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

# ------------
# CONVERSIONS
# ------------

inbounds(::Type{<:Mercator}, λ, ϕ) = -π ≤ λ ≤ π && -deg2rad(80) ≤ ϕ ≤ deg2rad(84)

function formulas(::Type{<:Mercator{Shift,Datum}}, ::Type{T}) where {Shift,Datum,T}
  e = T(eccentricity(ellipsoid(Datum)))

  fx(λ, ϕ) = λ

  fy(λ, ϕ) = asinh(tan(ϕ)) - e * atanh(e * sin(ϕ))

  fx, fy
end

function backward(::Type{<:Mercator{Shift,Datum}}, x, y) where {Shift,Datum}
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

Base.convert(::Type{Mercator{Shift}}, coords::CRS{Datum}) where {Shift,Datum} = convert(Mercator{Shift,Datum}, coords)

Base.convert(::Type{Mercator}, coords::CRS) = convert(Mercator{Shift()}, coords)
