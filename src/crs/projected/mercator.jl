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
Mercator(1u"m", 1u"m") # integers are converted converted to floats
Mercator(1.0u"km", 1.0u"km") # length quantities are converted to meters
Mercator(1.0u"m", 1.0u"m")
Mercator{WGS84Latest}(1.0u"m", 1.0u"m")
```

See [EPSG:3395](https://epsg.io/3395).
"""
struct Mercator{Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
end

Mercator{Datum}(x::M, y::M) where {Datum,M<:Met} = Mercator{Datum,float(M)}(x, y)
Mercator{Datum}(x::Met, y::Met) where {Datum} = Mercator{Datum}(promote(x, y)...)
Mercator{Datum}(x::Len, y::Len) where {Datum} = Mercator{Datum}(uconvert(u"m", x), uconvert(u"m", y))
Mercator{Datum}(x::Number, y::Number) where {Datum} = Mercator{Datum}(addunit(x, u"m"), addunit(y, u"m"))

Mercator(args...) = Mercator{WGS84Latest}(args...)

lentype(::Type{Mercator{Datum,M}}) where {Datum,M} = M

# ------------
# CONVERSIONS
# ------------

inbounds(::Type{<:Mercator}, λ, ϕ) = -π ≤ λ ≤ π && -deg2rad(80) ≤ ϕ ≤ deg2rad(84)

function formulas(::Type{<:Mercator{Datum}}, ::Type{T}) where {Datum,T}
  e = T(eccentricity(ellipsoid(Datum)))

  fx(λ, ϕ) = λ

  fy(λ, ϕ) = asinh(tan(ϕ)) - e * atanh(e * sin(ϕ))

  fx, fy
end

function Base.convert(::Type{LatLon{Datum}}, coords::Mercator{Datum}) where {Datum}
  🌎 = ellipsoid(Datum)
  x = coords.x
  y = coords.y
  a = oftype(x, majoraxis(🌎))
  e = convert(numtype(x), eccentricity(🌎))
  e² = convert(numtype(x), eccentricity²(🌎))
  ome² = 1 - e²

  # τ′(τ)
  function f(τ)
    sqrt1τ² = sqrt(1 + τ^2)
    σ = sinh(e * atanh(e * τ / sqrt1τ²))
    τ * sqrt(1 + σ^2) - σ * sqrt1τ²
  end

  # dτ′/dτ
  df(τ) = (ome² * sqrt(1 + f(τ)^2) * sqrt(1 + τ^2)) / (1 + ome² * τ^2)

  ψ = y / a
  τ′ = sinh(ψ)
  τ₀ = abs(τ′) > 70 ? (τ′ * exp(e * atanh(e))) : (τ′ / ome²)
  τ = newton(τ -> f(τ) - τ′, df, τ₀, maxiter=5)

  λ = x / a
  ϕ = atan(τ)

  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Mercator}, coords::LatLon{Datum}) where {Datum} = convert(Mercator{Datum}, coords)

Base.convert(::Type{LatLon}, coords::Mercator{Datum}) where {Datum} = convert(LatLon{Datum}, coords)
