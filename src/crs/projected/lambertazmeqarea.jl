# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    LambertAzimuthalEqualArea{latₒ,Datum,Shift}

Lambert Azimuthal Equal Area CRS with latitude origin `latₒ` in degrees, `Datum` and `Shift`.
"""
struct LambertAzimuthalEqualArea{latₒ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

LambertAzimuthalEqualArea{latₒ,Datum,Shift}(x::M, y::M) where {latₒ,Datum,Shift,M<:Met} =
  LambertAzimuthalEqualArea{latₒ,Datum,Shift,float(M)}(x, y)
LambertAzimuthalEqualArea{latₒ,Datum,Shift}(x::Met, y::Met) where {latₒ,Datum,Shift} =
  LambertAzimuthalEqualArea{latₒ,Datum,Shift}(promote(x, y)...)
LambertAzimuthalEqualArea{latₒ,Datum,Shift}(x::Len, y::Len) where {latₒ,Datum,Shift} =
  LambertAzimuthalEqualArea{latₒ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
LambertAzimuthalEqualArea{latₒ,Datum,Shift}(x::Number, y::Number) where {latₒ,Datum,Shift} =
  LambertAzimuthalEqualArea{latₒ,Datum,Shift}(addunit(x, m), addunit(y, m))

LambertAzimuthalEqualArea{latₒ,Datum}(args...) where {latₒ,Datum} =
  LambertAzimuthalEqualArea{latₒ,Datum,Shift()}(args...)

LambertAzimuthalEqualArea{latₒ}(args...) where {latₒ} = LambertAzimuthalEqualArea{latₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{LambertAzimuthalEqualArea{latₒ,Datum,Shift,M}},
  coords::LambertAzimuthalEqualArea{latₒ,Datum,Shift}
) where {latₒ,Datum,Shift,M} = LambertAzimuthalEqualArea{latₒ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:LambertAzimuthalEqualArea{latₒ,Datum,Shift}}) where {latₒ,Datum,Shift} =
  LambertAzimuthalEqualArea{latₒ,Datum,Shift}

lentype(::Type{<:LambertAzimuthalEqualArea{latₒ,Datum,Shift,M}}) where {latₒ,Datum,Shift,M} = M

==(
  coords₁::LambertAzimuthalEqualArea{latₒ,Datum,Shift},
  coords₂::LambertAzimuthalEqualArea{latₒ,Datum,Shift}
) where {latₒ,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

isequalarea(::Type{<:LambertAzimuthalEqualArea}) = true

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:LambertAzimuthalEqualArea{latₒ,Datum}}, ::Type{T}) where {latₒ,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  ome² = 1 - e²

  qₚ = authqₚ(e, ome²)
  qₒ = authq(ϕₒ, e, ome²)
  βₒ = geod2auth(qₒ, qₚ)
  sinβₒ = sin(βₒ)
  cosβₒ = cos(βₒ)
  sinϕₒ = sin(ϕₒ)
  cosϕₒ = cos(ϕₒ)

  Rq = sqrt(qₚ / 2)
  D = (cosϕₒ / sqrt(1 - e² * sinϕₒ^2)) / (Rq * cosβₒ)
  fB(cosλ, sinβ, cosβ) = Rq * sqrt(2 / (1 + (sinβₒ * sinβ) + (cosβₒ * cosβ * cosλ)))

  function fx(λ, ϕ)
    q = authq(ϕ, e, ome²)
    β = geod2auth(q, qₚ)
    sinλ = sin(λ)
    cosλ = cos(λ)
    sinβ = sin(β)
    cosβ = cos(β)
    B = fB(cosλ, sinβ, cosβ)
    (B * D) * (cosβ * sinλ)
  end

  function fy(λ, ϕ)
    q = authq(ϕ, e, ome²)
    β = geod2auth(q, qₚ)
    cosλ = cos(λ)
    sinβ = sin(β)
    cosβ = cos(β)
    B = fB(cosλ, sinβ, cosβ)
    (B / D) * ((cosβₒ * sinβ) - (sinβₒ * cosβ * cosλ))
  end

  fx, fy
end

function forward(::Type{<:LambertAzimuthalEqualArea{latₒ,Datum}}, λ, ϕ) where {latₒ,Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(λ, eccentricity(🌎))
  e² = oftype(λ, eccentricity²(🌎))
  ϕₒ = oftype(λ, ustrip(deg2rad(latₒ)))
  ome² = 1 - e²

  qₚ = authqₚ(e, ome²)
  qₒ = authq(ϕₒ, e, ome²)
  βₒ = geod2auth(qₒ, qₚ)
  q = authq(ϕ, e, ome²)
  β = geod2auth(q, qₚ)
  sinβₒ = sin(βₒ)
  cosβₒ = cos(βₒ)
  sinϕₒ = sin(ϕₒ)
  cosϕₒ = cos(ϕₒ)
  sinλ = sin(λ)
  cosλ = cos(λ)
  sinβ = sin(β)
  cosβ = cos(β)

  Rq = sqrt(qₚ / 2)
  D = (cosϕₒ / sqrt(1 - e² * sinϕₒ^2)) / (Rq * cosβₒ)
  B = Rq * sqrt(2 / (1 + (sinβₒ * sinβ) + (cosβₒ * cosβ * cosλ)))

  x = (B * D) * (cosβ * sinλ)
  y = (B / D) * ((cosβₒ * sinβ) - (sinβₒ * cosβ * cosλ))

  x, y
end

function backward(::Type{<:LambertAzimuthalEqualArea{latₒ,Datum}}, x, y) where {latₒ,Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(x, eccentricity(🌎))
  e² = oftype(x, eccentricity²(🌎))
  ϕₒ = oftype(x, ustrip(deg2rad(latₒ)))
  ome² = 1 - e²

  qₚ = authqₚ(e, ome²)
  qₒ = authq(ϕₒ, e, ome²)
  βₒ = geod2auth(qₒ, qₚ)
  sinβₒ = sin(βₒ)
  cosβₒ = cos(βₒ)
  sinϕₒ = sin(ϕₒ)
  cosϕₒ = cos(ϕₒ)

  Rq = sqrt(qₚ / 2)
  D = (cosϕₒ / sqrt(1 - e² * sinϕₒ^2)) / (Rq * cosβₒ)
  ρ = sqrt((x / D)^2 + (D * y)^2)
  C = 2 * asin(ρ / 2Rq)
  sinC = sin(C)
  cosC = cos(C)

  β′ = asin((cosC * sinβₒ) + ((D * y * sinC * cosβₒ) / ρ))

  λ = atan(X * sinC, (D * ρ * cosβₒ * cosC) - (D^2 * y * sinβₒ * sinC))
  ϕ = auth2geod(β′, e²)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{LambertAzimuthalEqualArea{latₒ}}, coords::CRS{Datum}) where {latₒ,Datum} =
  convert(LambertAzimuthalEqualArea{latₒ,Datum}, coords)
