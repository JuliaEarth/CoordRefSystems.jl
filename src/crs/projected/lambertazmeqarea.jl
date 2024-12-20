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

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/laea.cpp
# reference formula: Section 3.6.2 of EPSG Guidance Note 7-2 (https://epsg.org/guidance-notes.html)

function inbounds(::Type{<:LambertAzimuthalEqualArea{latₒ,Datum}}, λ, ϕ) where {latₒ,Datum}
  🌎 = ellipsoid(Datum)
  e = oftype(λ, eccentricity(🌎))
  e² = oftype(λ, eccentricity²(🌎))
  ϕₒ = oftype(λ, ustrip(deg2rad(latₒ)))
  ome² = 1 - e²

  qₚ = authqₚ(e, ome²)
  qₒ = authq(ϕₒ, e, ome²)
  q = authq(ϕ, e, ome²)
  βₒ = geod2auth(qₒ, qₚ)
  β = geod2auth(q, qₚ)
  sinβₒ, cosβₒ = sincos(βₒ)
  sinβ, cosβ = sincos(β)
  cosλ = cos(λ)

  # check if the denominator of the B equation is not equal (or approx) to zero
  Bden = 1 + (sinβₒ * sinβ) + (cosβₒ * cosβ * cosλ)
  abs(Bden) > atol(λ)
end

function formulas(::Type{<:LambertAzimuthalEqualArea{latₒ,Datum}}, ::Type{T}) where {latₒ,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  ome² = 1 - e²

  qₚ = authqₚ(e, ome²)
  qₒ = authq(ϕₒ, e, ome²)
  βₒ = geod2auth(qₒ, qₚ)
  sinβₒ, cosβₒ = sincos(βₒ)
  sinϕₒ, cosϕₒ = sincos(ϕₒ)

  Rq = sqrt(qₚ / 2)
  D = (cosϕₒ / sqrt(1 - e² * sinϕₒ^2)) / (Rq * cosβₒ)
  fB(cosλ, sinβ, cosβ) = Rq * sqrt(2 / (1 + (sinβₒ * sinβ) + (cosβₒ * cosβ * cosλ)))

  function fx(λ, ϕ)
    q = authq(ϕ, e, ome²)
    β = geod2auth(q, qₚ)
    sinβ, cosβ = sincos(β)
    sinλ, cosλ = sincos(λ)
    B = fB(cosλ, sinβ, cosβ)
    (B * D) * (cosβ * sinλ)
  end

  function fy(λ, ϕ)
    q = authq(ϕ, e, ome²)
    β = geod2auth(q, qₚ)
    sinβ, cosβ = sincos(β)
    cosλ = cos(λ)
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
  q = authq(ϕ, e, ome²)
  βₒ = geod2auth(qₒ, qₚ)
  β = geod2auth(q, qₚ)
  sinβₒ, cosβₒ = sincos(βₒ)
  sinϕₒ, cosϕₒ = sincos(ϕₒ)
  sinβ, cosβ = sincos(β)
  sinλ, cosλ = sincos(λ)

  Rq = sqrt(qₚ / 2)
  # check if the denominator of the B equation is not equal (or approx) to zero
  Bden = (1 + (sinβₒ * sinβ) + (cosβₒ * cosβ * cosλ))
  if abs(Bden) < atol(λ)
    throw(ArgumentError("coordinates outside of the projection domain"))
  end

  D = (cosϕₒ / sqrt(1 - e² * sinϕₒ^2)) / (Rq * cosβₒ)
  B = Rq * sqrt(2 / Bden)

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
  sinβₒ, cosβₒ = sincos(βₒ)
  sinϕₒ, cosϕₒ = sincos(ϕₒ)

  Rq = sqrt(qₚ / 2)
  D = (cosϕₒ / sqrt(1 - e² * sinϕₒ^2)) / (Rq * cosβₒ)
  ρ = sqrt((x / D)^2 + (D * y)^2)

  if ρ < atol(x)
    zero(x), ϕₒ
  else
    C = 2 * asinclamp(ρ / 2Rq)
    sinC, cosC = sincos(C)

    β′ = asinclamp((cosC * sinβₒ) + ((D * y * sinC * cosβₒ) / ρ))

    λ = atan(x * sinC, (D * ρ * cosβₒ * cosC) - (D^2 * y * sinβₒ * sinC))
    ϕ = auth2geod(β′, e²)

    λ, ϕ
  end
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{LambertAzimuthalEqualArea{latₒ}}, coords::CRS{Datum}) where {latₒ,Datum} =
  indomain(LambertAzimuthalEqualArea{latₒ,Datum}, coords)

Base.convert(::Type{LambertAzimuthalEqualArea{latₒ}}, coords::CRS{Datum}) where {latₒ,Datum} =
  convert(LambertAzimuthalEqualArea{latₒ,Datum}, coords)
