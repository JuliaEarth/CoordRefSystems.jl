# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Albers{latₒ,lat₁,lat₂,Datum,Shift}

Albers Conic Equal Area CRS with latitude origin `latₒ` standard parallels `lat₁` and `lat₂`,  `Datum` and `Shift`.
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

Albers{latₒ,lat₁,lat₂,Datum}(args...) where {latₒ,lat₁,lat₂,Datum} = Albers{latₒ,lat₁,lat₂,Datum,Shift()}(args...)

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

function inbounds(::Type{<:Albers{latₒ,lat₁,lat₂,Datum}}, λ, ϕ) where {latₒ,lat₁,lat₂,Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(λ, eccentricity(🌎))
  e² = oftype(λ, eccentricity²(🌎))
  ϕ₁ = oftype(λ, ustrip(deg2rad(lat₁)))
  ϕ₂ = oftype(λ, ustrip(deg2rad(lat₂)))

  m₁ = _albersm(ϕ₁, e, e²)
  m₂ = _albersm(ϕ₂, e, e²)
  α₁ = _albersα(ϕ₁, e, e²)
  α₂ = _albersα(ϕ₂, e, e²)
  n = (m₁^2 - m₂^2) / (α₂ - α₁)
  C = m₁^2 + n * α₁

  ρ = sqrt(C - n * _albersα(ϕ, e, e²)) / n
  ρ ≥ 0
end

function formulas(::Type{<:Albers{latₒ,lat₁,lat₂,Datum}}, ::Type{T}) where {latₒ,lat₁,lat₂,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  ϕ₁ = T(ustrip(deg2rad(lat₁)))
  ϕ₂ = T(ustrip(deg2rad(lat₂)))

  m₁ = _albersm(ϕ₁, e, e²)
  m₂ = _albersm(ϕ₂, e, e²)
  α₁ = _albersα(ϕ₁, e, e²)
  α₂ = _albersα(ϕ₂, e, e²)
  n = (m₁^2 - m₂^2) / (α₂ - α₁)
  C = m₁^2 + n * α₁

  θ(λ) = n * λ
  ρ(ϕ) = sqrt(C - n * _albersα(ϕ, e, e²)) / n
  ρₒ = ρ(ϕₒ)

  fx(λ, ϕ) = ρ(ϕ) * sin(θ(λ))

  fy(λ, ϕ) = ρₒ - ρ(ϕ) * cos(θ(λ))

  fx, fy
end

function backward(::Type{<:Albers{latₒ,lat₁,lat₂,Datum}}, x, y) where {latₒ,lat₁,lat₂,Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ϕₒ = oftype(x, ustrip(deg2rad(latₒ)))
  ϕ₁ = oftype(x, ustrip(deg2rad(lat₁)))
  ϕ₂ = oftype(x, ustrip(deg2rad(lat₂)))

  m₁ = _albersm(ϕ₁, e, e²)
  m₂ = _albersm(ϕ₂, e, e²)
  α₁ = _albersα(ϕ₁, e, e²)
  α₂ = _albersα(ϕ₂, e, e²)
  n = (m₁^2 - m₂^2) / (α₂ - α₁)
  C = m₁^2 + n * α₁

  ρ(ϕ) = sqrt(C - n * _albersα(ϕ, e, e²)) / n
  ρₒ = ρ(ϕₒ)

  θ = n ≥ 0 ? atan(x, ρₒ - y) : atan(-x, y - ρₒ)
  ρ′ = sqrt(x^2 + (ρₒ - y)^2)
  α′ = (C - (ρ′^2 * n^2)) / n
  β′ = asin(α′ / (1 - ((1 - e²) / (2 * e)) * log((1 - e) / (1 + e))))

  λ = θ / n
  ϕ = auth2geod(β′, e²)

  λ, ϕ
end

# -----------------
# HELPER FUNCTIONS
# -----------------

_albersm(ϕ, e, e²) = cos(ϕ) / sqrt(1 - e² * sin(ϕ)^2)

_albersα(ϕ, e, e²) =
  (1 - e²) * ((sin(ϕ) / (1 - e² * sin(ϕ)^2)) - (1 / (2 * e) * log((1 - e * sin(ϕ)) / (1 + e * sin(ϕ)))))

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Albers{latₒ,lat₁,lat₂}}, coords::CRS{Datum}) where {latₒ,lat₁,lat₂,Datum} =
  convert(Albers{latₒ,lat₁,lat₂,Datum}, coords)
