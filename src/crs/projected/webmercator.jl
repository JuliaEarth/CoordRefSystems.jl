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
struct WebMercator{Shift,Datum,M<:Met} <: Projected{Shift,Datum}
  x::M
  y::M
end

WebMercator{Shift,Datum}(x::M, y::M) where {Shift,Datum,M<:Met} = WebMercator{Shift,Datum,float(M)}(x, y)
WebMercator{Shift,Datum}(x::Met, y::Met) where {Shift,Datum} = WebMercator{Shift,Datum}(promote(x, y)...)
WebMercator{Shift,Datum}(x::Len, y::Len) where {Shift,Datum} = WebMercator{Shift,Datum}(uconvert(m, x), uconvert(m, y))
WebMercator{Shift,Datum}(x::Number, y::Number) where {Shift,Datum} =
  WebMercator{Shift,Datum}(addunit(x, m), addunit(y, m))

WebMercator{Shift}(args...) where {Shift} = WebMercator{Shift,WGS84Latest}(args...)

WebMercator(args...) = WebMercator{Shift()}(args...)

Base.convert(::Type{WebMercator{Shift,Datum,M}}, coords::WebMercator{Shift,Datum}) where {Shift,Datum,M} =
  WebMercator{Shift,Datum,M}(coords.x, coords.y)

constructor(::Type{<:WebMercator{Shift,Datum}}) where {Shift,Datum} = WebMercator{Shift,Datum}

lentype(::Type{<:WebMercator{Shift,Datum,M}}) where {Shift,Datum,M} = M

==(coords₁::WebMercator{Shift,Datum}, coords₂::WebMercator{Shift,Datum}) where {Shift,Datum} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

# ------------
# CONVERSIONS
# ------------

function inbounds(::Type{<:WebMercator}, λ, ϕ)
  θ = deg2rad(85.06)
  -π ≤ λ ≤ π && -θ ≤ ϕ ≤ θ
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

Base.convert(::Type{WebMercator}, coords::CRS{Datum}) where {Datum} = convert(WebMercator{Datum}, coords)
