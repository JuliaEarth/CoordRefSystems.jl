# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    WebMercator(x, y)
    WebMercator{Datum}(x, y)

Web Mercator coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
WebMercator(1, 1) # add default units
WebMercator(1m, 1m) # integers are converted converted to floats
WebMercator(1.0km, 1.0km) # length quantities are converted to meters
WebMercator(1.0m, 1.0m)
WebMercator{WGS84Latest}(1.0m, 1.0m)
```

See [EPSG:3857](https://epsg.io/3857).
"""
struct WebMercator{Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
end

WebMercator{Datum}(x::M, y::M) where {Datum,M<:Met} = WebMercator{Datum,float(M)}(x, y)
WebMercator{Datum}(x::Met, y::Met) where {Datum} = WebMercator{Datum}(promote(x, y)...)
WebMercator{Datum}(x::Len, y::Len) where {Datum} = WebMercator{Datum}(uconvert(m, x), uconvert(m, y))
WebMercator{Datum}(x::Number, y::Number) where {Datum} = WebMercator{Datum}(addunit(x, m), addunit(y, m))

WebMercator(args...) = WebMercator{WGS84Latest}(args...)

Base.convert(::Type{WebMercator{Datum,M}}, coords::WebMercator{Datum}) where {Datum,M} =
  WebMercator{Datum,M}(coords.x, coords.y)

constructor(::Type{<:WebMercator{Datum}}) where {Datum} = WebMercator{Datum}

lentype(::Type{<:WebMercator{Datum,M}}) where {Datum,M} = M

==(coords₁::WebMercator{Datum}, coords₂::WebMercator{Datum}) where {Datum} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

# ------------
# CONVERSIONS
# ------------

function inbounds(::Type{<:WebMercator}, λ, ϕ)
  θ = deg2rad(85.06)
  -π ≤ λ ≤ π && -θ ≤ ϕ ≤ θ
end

function formulas(::Type{<:WebMercator{Datum}}, ::Type{T}) where {Datum,T}
  fx(λ, ϕ) = λ

  fy(λ, ϕ) = asinh(tan(ϕ))

  fx, fy
end

function Base.convert(::Type{LatLon{Datum}}, coords::WebMercator{Datum}) where {Datum}
  🌎 = ellipsoid(Datum)
  x = coords.x
  y = coords.y
  a = oftype(x, majoraxis(🌎))
  λ = x / a
  ϕ = atan(sinh(y / a))
  LatLon{Datum}(rad2deg(ϕ) * °, rad2deg(λ) * °)
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{WebMercator}, coords::LatLon{Datum}) where {Datum} = convert(WebMercator{Datum}, coords)

Base.convert(::Type{LatLon}, coords::WebMercator{Datum}) where {Datum} = convert(LatLon{Datum}, coords)
