# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Sinusoidal(x, y)
    Sinusoidal{Datum}(x, y)

Sinusoidal (Sanson-Flamsteed) coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
Sinusoidal(1, 1) # add default units
Sinusoidal(1m, 1m) # integers are converted converted to floats
Sinusoidal(1.0km, 1.0km) # length quantities are converted to meters
Sinusoidal(1.0m, 1.0m)
Sinusoidal{WGS84Latest}(1.0m, 1.0m)
```

See [Sinusoidal projection](https://en.wikipedia.org/wiki/Sinusoidal_projection)
"""
struct Sinusoidal{Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Sinusoidal{Datum,Shift}(x::M, y::M) where {Datum,Shift,M<:Met} = Sinusoidal{Datum,Shift,float(M)}(x, y)
Sinusoidal{Datum,Shift}(x::Met, y::Met) where {Datum,Shift} = Sinusoidal{Datum,Shift}(promote(x, y)...)
Sinusoidal{Datum,Shift}(x::Len, y::Len) where {Datum,Shift} = Sinusoidal{Datum,Shift}(uconvert(m, x), uconvert(m, y))
Sinusoidal{Datum,Shift}(x::Number, y::Number) where {Datum,Shift} =
  Sinusoidal{Datum,Shift}(addunit(x, m), addunit(y, m))

Sinusoidal{Datum}(args...) where {Datum} = Sinusoidal{Datum,Shift()}(args...)

Sinusoidal(args...) = Sinusoidal{WGS84Latest}(args...)

Base.convert(::Type{Sinusoidal{Datum,Shift,M}}, coords::Sinusoidal{Datum,Shift}) where {Datum,Shift,M} =
  Sinusoidal{Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Sinusoidal{Datum,Shift}}) where {Datum,Shift} = Sinusoidal{Datum,Shift}

lentype(::Type{<:Sinusoidal{Datum,Shift,M}}) where {Datum,Shift,M} = M

==(coords₁::Sinusoidal{Datum,Shift}, coords₂::Sinusoidal{Datum,Shift}) where {Datum,Shift} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

isequalarea(::Type{<:Sinusoidal}) = true
isequidistant(::Type{<:Sinusoidal}) = true

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:Sinusoidal}, ::Type{T}) where {T}
  fx(λ, ϕ) = λ * cos(ϕ)

  fy(λ, ϕ) = ϕ

  fx, fy
end

function backward(::Type{<:Sinusoidal}, x, y)
  ϕ = y
  λ = x / cos(ϕ)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Sinusoidal}, coords::CRS{Datum}) where {Datum} = convert(Sinusoidal{Datum}, coords)
