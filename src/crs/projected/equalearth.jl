# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EqualEarth(x, y)
    EqualEarth{Datum}(x, y)

Equal Earth coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
EqualEarth(1, 1) # add default units
EqualEarth(1m, 1m) # integers are converted converted to floats
EqualEarth(1.0km, 1.0km) # length quantities are converted to meters
EqualEarth(1.0m, 1.0m)
EqualEarth{WGS84Latest}(1.0m, 1.0m)
```

See [Equal Earth projection](https://equal-earth.com/equal-earth-projection.html).
"""
struct EqualEarth{Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

EqualEarth{Datum,Shift}(x::M, y::M) where {Datum,Shift,M<:Met} = EqualEarth{Datum,Shift,float(M)}(x, y)
EqualEarth{Datum,Shift}(x::Met, y::Met) where {Datum,Shift} = EqualEarth{Datum,Shift}(promote(x, y)...)
EqualEarth{Datum,Shift}(x::Len, y::Len) where {Datum,Shift} = EqualEarth{Datum,Shift}(uconvert(m, x), uconvert(m, y))
EqualEarth{Datum,Shift}(x::Number, y::Number) where {Datum,Shift} =
  EqualEarth{Datum,Shift}(addunit(x, m), addunit(y, m))

EqualEarth{Datum}(args...) where {Datum} = EqualEarth{Datum,Shift()}(args...)

EqualEarth(args...) = EqualEarth{WGS84Latest}(args...)

Base.convert(::Type{EqualEarth{Datum,Shift,M}}, coords::EqualEarth{Datum,Shift}) where {Datum,Shift,M} =
  EqualEarth{Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:EqualEarth{Datum,Shift}}) where {Datum,Shift} = EqualEarth{Datum,Shift}

lentype(::Type{<:EqualEarth{Datum,Shift,M}}) where {Datum,Shift,M} = M

==(coords₁::EqualEarth{Datum,Shift}, coords₂::EqualEarth{Datum,Shift}) where {Datum,Shift} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

isequalarea(::Type{<:EqualEarth}) = true

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/eqearth.cpp
#                 https://github.com/d3/d3-geo/blob/main/src/projection/equalEarth.js
# reference formula: The Equal Earth map projection (https://doi.org/10.1080/13658816.2018.1504949)

const _EEA₁ = 1.340264
const _EEA₂ = -0.081106
const _EEA₃ = 0.000893
const _EEA₄ = 0.003796

function formulas(::Type{<:EqualEarth{Datum}}, ::Type{T}) where {Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))

  A₁ = T(_EEA₁)
  A₂ = T(_EEA₂)
  A₃ = T(_EEA₃)
  A₄ = T(_EEA₄)
  M = sqrt(T(3)) / T(2)

  fθ(β) = asin(M * sin(β))

  function fx(λ, ϕ)
    β = geod2auth(ϕ, e, e²)
    θ = fθ(β)
    θ² = θ^2
    θ⁶ = θ²^3

    (λ * cos(θ)) / (M * (A₁ + 3 * A₂ * θ² + θ⁶ * (7 * A₃ + 9 * A₄ * θ²)))
  end

  function fy(λ, ϕ)
    β = geod2auth(ϕ, e, e²)
    θ = fθ(β)
    θ² = θ^2
    θ⁶ = θ²^3

    θ * (A₁ + A₂ * θ² + θ⁶ * (A₃ + A₄ * θ²))
  end

  fx, fy
end

function forward(::Type{<:EqualEarth{Datum}}, λ, ϕ) where {Datum}
  T = typeof(λ)
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))

  A₁ = T(_EEA₁)
  A₂ = T(_EEA₂)
  A₃ = T(_EEA₃)
  A₄ = T(_EEA₄)
  M = sqrt(T(3)) / T(2)

  β = geod2auth(ϕ, e, e²)
  θ = asin(M * sin(β))
  θ² = θ^2
  θ⁶ = θ²^3

  x = (λ * cos(θ)) / (M * (A₁ + 3 * A₂ * θ² + θ⁶ * (7 * A₃ + 9 * A₄ * θ²)))
  y = θ * (A₁ + A₂ * θ² + θ⁶ * (A₃ + A₄ * θ²))

  x, y
end

function backward(::Type{<:EqualEarth{Datum}}, x, y) where {Datum}
  T = typeof(x)
  🌎 = ellipsoid(Datum)
  e² = T(eccentricity²(🌎))

  A₁ = T(_EEA₁)
  A₂ = T(_EEA₂)
  A₃ = T(_EEA₃)
  A₄ = T(_EEA₄)
  M = sqrt(T(3)) / T(2)

  function fy(θ)
    θ² = θ^2
    θ⁶ = θ²^3

    θ * (A₁ + A₂ * θ² + θ⁶ * (A₃ + A₄ * θ²))
  end

  function dfy(θ)
    θ² = θ^2
    θ⁶ = θ²^3

    A₁ + 3 * A₂ * θ² + θ⁶ * (7 * A₃ + 9 * A₄ * θ²)
  end

  θ = newton(θ -> fy(θ) - y, dfy, y)
  β = asin(sin(θ) / M)
  θ² = θ^2
  θ⁶ = θ²^3

  ϕ = auth2geod(β, e²)
  λ = (x * M * (A₁ + 3 * A₂ * θ² + θ⁶ * (7 * A₃ + 9 * A₄ * θ²))) / cos(θ)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{EqualEarth}, coords::CRS{Datum}) where {Datum} = indomain(EqualEarth{Datum}, coords)

Base.convert(::Type{EqualEarth}, coords::CRS{Datum}) where {Datum} = convert(EqualEarth{Datum}, coords)
