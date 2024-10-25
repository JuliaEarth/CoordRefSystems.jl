# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Albers(latₒ, lat₁, lat₂, Datum, Shift)
    Albers CRS with latitude origin latₒ standard parallels `lat₁` and `lat₂`,  `Datum` and `Shift`.

## Examples

```julia
Albers(1, 1) # add default units
Albers(1m, 1m) # integers are converted converted to floats
Albers(1.0km, 1.0km) # length quantities are converted to meters
Albers(1.0m, 1.0m)
Albers{NAD83}(1.0m, 1.0m)
```

See [EPSG:5070](https://epsg.io/5070).
"""
struct Albers{latₒ,lat₁,lat₂,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Albers{latₒ,lat₁,lat₂,Datum,Shift}(x::M, y::M) where {latₒ,lat₁,lat₂,Datum,Shift,M<:Met} =
  Albers{latₒ,lat₁,lat₂,Datum,Shift,float(M)}(x, y)
Albers{latₒ,lat₁,lat₂,Datum,Shift}(x::Met, y::Met) where {latₒ,lat₁,lat₂,Datum,Shift} =
  Albers{latₒ,lat₁,lat₂,Datum,Shift}(promote(x, y)...)
Albers{latₒ,lat₁,lat₂,Datum,Shift}(x::Len, y::Len) where {latₒ,lat₁,lat₂,Datum,Shift} =
  Albers{latₒ,lat₁,lat₂,Datum,Shift}(uconvert(m, x), uconvert(m, y))
Albers{latₒ,lat₁,lat₂,Datum,Shift}(x::Number, y::Number) where {latₒ,lat₁,lat₂,Datum,Shift} =
  Albers{latₒ,lat₁,lat₂,Datum,Shift}(addunit(x, m), addunit(y, m))

Albers{latₒ,lat₁,lat₂,Datum}(args...) where {latₒ,lat₁,lat₂,Datum} =
  Albers{latₒ,lat₁,lat₂,Datum,Shift()}(args...)

Albers(args...) = Albers{NAD83}(args...)

Base.convert(
  ::Type{Albers{latₒ,lat₁,lat₂,Datum,Shift,M}},
  coords::Albers{latₒ,lat₁,lat₂,Datum,Shift}
) where {latₒ,lat₁,lat₂,Datum,Shift,M} = Albers{latₒ,lat₁,lat₂,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Albers{latₒ,lat₁,lat₂,Datum,Shift}}) where {latₒ,lat₁,lat₂,Datum,Shift} =
  Albers{latₒ,lat₁,lat₂,Datum,Shift}

lentype(::Type{<:Albers{latₒ,lat₁,lat₂,Datum,Shift,M}}) where {latₒ,lat₁,lat₂,Datum,Shift,M} = M

==(
  coords₁::Albers{latₒ,lat₁,lat₂,Datum,Shift},
  coords₂::Albers{latₒ,lat₁,lat₂,Datum,Shift}
) where {latₒ,lat₁,lat₂,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.
# Authors of the original algorithm: Gerald Evenden and Thomas Knudsen
# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/aea.cpp

inbounds(::Type{<:Albers{latₒ,lat₁,lat₂,Datum}}, λ, ϕ) where {latₒ,lat₁,lat₂,Datum} =
  -π ≤ λ ≤ π && deg2rad(90) ≤ ϕ ≤ deg2rad(90)

function formulas(::Type{<:Albers{Datum}}, ::Type{T}) where {latₒ,lat₁,lat₂,Datum,T}
  # Constants
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  a = numconvert(T, majoraxis(🌎))

  # Latitude origin
  ϕ₀ = T(ustrip(deg2rad(latₒ)))

  # Standard parallels
  ϕ₁ = T(ustrip(deg2rad(lat₁)))
  ϕ₂ = T(ustrip(deg2rad(lat₂)))


  m₁ = hm(ϕ₁, e)
  m₂ = hm(ϕ₂, e)
  α₁ = hα(ϕ₁, e)
  α₂ = hα(ϕ₂, e)
  α₀ = hα(ϕ₀, e)
  n = (m₁^2 - m₂^2) / (α₂ - α₁)
  C = m₁^2 + n * α₁

  Θ = n * λ
  ρ = a * sqrt(C - n * hα(ϕ, e)) / n
  if ρ < 0
    throw(ArgumentError("coordinates outside of the projection domain"))
  end
  ρ₀ = (a * (C - n * α₀))^0.5 / n
  function fx(λ, ϕ)
    ρ₀ - ρ * cos(Θ)
  end

  function fy(λ, ϕ)
    ρ * sin(Θ)
  end

  fx, fy
end

# backward projection formulas

function backward(::Type{<:Albers{Datum}}, x, y) where {latₒ,lat₁,lat₂,Datum,T}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ϕ₀, ϕ₁, ϕ₂ = T.(ustrip.(deg2rad.(latₒ, lat₁, lat₂)))
  α₀ = hα(ϕ₀, e)
  ρ₀ = (a * (C - n * α₀))^0.5 / n
  α₁ = hα(ϕ₁, e)
  α₂ = hα(ϕ₂, e)

  m₁ = hm(ϕ₁, e)
  m₂ = hm(ϕ₂, e)
  n = (m₁^2 - m₂^2) / (α₂ - α₁)
  C = m₁^2 + n * α₁

  θ = atan2(x, ρ₀ - y)
  ρ = sqrt(x^2 + (ρ₀ - y)^2)
  α′ = (C - (ρ^2 * n^2) / a^2) / n
  β′ = asin(α′ / (1 - (1 - e) / (2 * e) * log((1 - e) / (1 + e))))

  λ = θ / n
  ϕ =
    β′ +
    (e^2 / 3 + 31 * e^4 / 180 + 517 * e^6 / 5040) * sin(2 * β′) +
    (23 * e^4 / 360 + 251 * e^6 / 3780) * sin(4 * β′) +
    (761 * e^6 / 45360) * sin(6 * β′)
  return λ, ϕ
end
# ----------
# Helper functions
# ----------
function hm(ϕ, e)
  cos(ϕ) / sqrt(1 - e^2 * sin(ϕ)^2)
end
function hα(ϕ, e)
  (1 - e^2) * (sin(ϕ) / (1 - e^2 * sin(ϕ)^2) - (1 / (2 * e)) * log((1 - e * sin(ϕ)) / (1 + e * sin(ϕ))))
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Albers{latₒ,lat₁,lat₂}}, coords::CRS{Datum}) where {latₒ,lat₁,lat₂,Datum} =
  convert(Albers{latₒ,lat₁,lat₂,Datum}, coords)
