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
struct WebMercator{Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

WebMercator{Datum,Shift}(x::M, y::M) where {Datum,Shift,M<:Met} = WebMercator{Datum,Shift,float(M)}(x, y)
WebMercator{Datum,Shift}(x::Met, y::Met) where {Datum,Shift} = WebMercator{Datum,Shift}(promote(x, y)...)
WebMercator{Datum,Shift}(x::Len, y::Len) where {Datum,Shift} = WebMercator{Datum,Shift}(uconvert(m, x), uconvert(m, y))
WebMercator{Datum,Shift}(x::Number, y::Number) where {Datum,Shift} =
  WebMercator{Datum,Shift}(addunit(x, m), addunit(y, m))

WebMercator{Datum}(args...) where {Datum} = WebMercator{Datum,Shift()}(args...)

WebMercator(args...) = WebMercator{WGS84Latest}(args...)

Base.convert(::Type{WebMercator{Datum,Shift,M}}, coords::WebMercator{Datum,Shift}) where {Datum,Shift,M} =
  WebMercator{Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:WebMercator{Datum,Shift}}) where {Datum,Shift} = WebMercator{Datum,Shift}

lentype(::Type{<:WebMercator{Datum,Shift,M}}) where {Datum,Shift,M} = M

==(coords₁::WebMercator{Datum,Shift}, coords₂::WebMercator{Datum,Shift}) where {Datum,Shift} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

iscompromise(::Type{<:WebMercator}) = true

# ------------
# CONVERSIONS
# ------------

function inbounds(::Type{<:WebMercator}, λ, ϕ)
  T = typeof(λ)
  θ = deg2rad(T(85.06))
  -T(π) ≤ λ ≤ T(π) && -θ ≤ ϕ ≤ θ
end

function formulas(::Type{<:WebMercator}, ::Type{T}) where {T}
  fx(λ, ϕ) = λ

  fy(λ, ϕ) = asinh(tan(ϕ))

  fx, fy
end

function backward(::Type{<:WebMercator}, x, y)
  λ = x
  ϕ = atan(sinh(y))
  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{WebMercator}, coords::CRS{Datum}) where {Datum} = indomain(WebMercator{Datum}, coords)

Base.convert(::Type{WebMercator}, coords::CRS{Datum}) where {Datum} = convert(WebMercator{Datum}, coords)
