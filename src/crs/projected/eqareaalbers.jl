# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Albers(lat₀, lat₁, lat₂, Datum, Shift)
    Albers CRS with latitude origin lat₀ standard parallels `lat₁` and `lat₂`, `lon₀`, `Datum` and `Shift`.

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
struct Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}(x::M, y::M) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift,M<:Met} =
  Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift,float(M)}(x, y)
Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}(x::Met, y::Met) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift} =
  Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}(promote(x, y)...)
Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}(x::Len, y::Len) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift} =
  Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}(uconvert(m, x), uconvert(m, y))
Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}(x::Number, y::Number) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift} =
  Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}(addunit(x, m), addunit(y, m))

Albers{lat₀,lat₁,lat₂,lon₀,Datum}(args...) where {lat₀,lat₁,lat₂,lon₀,Datum} =
  Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift()}(args...)

Albers(args...) = Albers{NAD83}(args...)

Base.convert(
  ::Type{Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift,M}},
  coords::Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}
) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift,M} = Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}}) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift} =
  Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}

lentype(::Type{<:Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift,M}}) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift,M} = M

==(
  coords₁::Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift},
  coords₂::Albers{lat₀,lat₁,lat₂,lon₀,Datum,Shift}
) where {lat₀,lat₁,lat₂,lon₀,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.
# Authors of the original algorithm: Gerald Evenden and Thomas Knudsen
# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/aea.cpp

inbounds(::Type{<:Albers{lat₀,lat₁,lat₂,lon₀,Datum}}, λ, ϕ) where {lat₀,lat₁,lat₂,lon₀,Datum} =
  -π ≤ λ ≤ π && deg2rad(90) ≤ ϕ ≤ deg2rad(90)

function formulas(::Type{<:Albers{Datum}}, ::Type{T}) where {lat₀,lat₁,lat₂,lon₀,Datum,T}
  # Constants
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  a = numconvert(T, majoraxis(🌎))

  # Latitude origin
  ϕ₀ = T(ustrip(deg2rad(lat₀)))

  # Standard parallels
  ϕ₁ = T(ustrip(deg2rad(lat₁)))
  ϕ₂ = T(ustrip(deg2rad(lat₂)))

  # Longitude origin
  λ₀ = T(ustrip(deg2rad(lon₀)))

  m₁ = hm(ϕ₁, e)
  m₂ = hm(ϕ₂, e)
  α₁ = hα(ϕ₁, e)
  α₂ = hα(ϕ₂, e)
  α₀ = hα(ϕ₀, e)
  n = (m₁^2 - m₂^2) / (α₂ - α₁)
  C = m₁^2 + n * α₁

  Θ = n * (λ - λ₀)
  ρ = a * sqrt(C - n * hα(ϕ, e)) / n
  if ρ < 0
    throw(DomainError("Coordinate transformation outside projection domain"))
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

function backward(::Type{<:Albers{Datum}}, x, y) where {lat₀,lat₁,lat₂,lon₀,Datum,T}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ϕ₀, ϕ₁, ϕ₂, λ₀ = T.(ustrip.(deg2rad.(lat₀, lat₁, lat₂, lon₀)))
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

  λ = λ₀ + θ / n
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

Base.convert(::Type{Albers{lat₀,lat₁,lat₂,lon₀}}, coords::CRS{Datum}) where {lat₀,lat₁,lat₂,lon₀,Datum} =
  convert(Albers{lat₀,lat₁,lat₂,lon₀,Datum}, coords)
