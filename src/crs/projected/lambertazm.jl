# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    LambertAzimuthal{latₒ,Datum,Shift}

Lambert Azimuthal CRS with latitude origin `latₒ` in degrees, `Datum` and `Shift`.
"""
struct LambertAzimuthal{latₒ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

LambertAzimuthal{latₒ,Datum,Shift}(x::M, y::M) where {latₒ,Datum,Shift,M<:Met} =
  LambertAzimuthal{latₒ,Datum,Shift,float(M)}(x, y)
LambertAzimuthal{latₒ,Datum,Shift}(x::Met, y::Met) where {latₒ,Datum,Shift} =
  LambertAzimuthal{latₒ,Datum,Shift}(promote(x, y)...)
LambertAzimuthal{latₒ,Datum,Shift}(x::Len, y::Len) where {latₒ,Datum,Shift} =
  LambertAzimuthal{latₒ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
LambertAzimuthal{latₒ,Datum,Shift}(x::Number, y::Number) where {latₒ,Datum,Shift} =
  LambertAzimuthal{latₒ,Datum,Shift}(addunit(x, m), addunit(y, m))

LambertAzimuthal{latₒ,Datum}(args...) where {latₒ,Datum} = LambertAzimuthal{latₒ,Datum,Shift()}(args...)

LambertAzimuthal{latₒ}(args...) where {latₒ} = LambertAzimuthal{latₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{LambertAzimuthal{latₒ,Datum,Shift,M}},
  coords::LambertAzimuthal{latₒ,Datum,Shift}
) where {latₒ,Datum,Shift,M} = LambertAzimuthal{latₒ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:LambertAzimuthal{latₒ,Datum,Shift}}) where {latₒ,Datum,Shift} = LambertAzimuthal{latₒ,Datum,Shift}

constructor(::Type{<:LambertAzimuthal{latₒ,Datum}}) where {latₒ,Datum} = LambertAzimuthal{latₒ,Datum}

constructor(::Type{<:LambertAzimuthal{latₒ}}) where {latₒ} = LambertAzimuthal{latₒ}

lentype(::Type{<:LambertAzimuthal{latₒ,Datum,Shift,M}}) where {latₒ,Datum,Shift,M} = M

==(coords₁::LambertAzimuthal{latₒ,Datum,Shift}, coords₂::LambertAzimuthal{latₒ,Datum,Shift}) where {latₒ,Datum,Shift} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

isequalarea(::Type{<:LambertAzimuthal}) = true

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/laea.cpp
# reference formula: Section 3.6.2 of EPSG Guidance Note 7-2 (https://epsg.org/guidance-notes.html)

function inbounds(::Type{<:LambertAzimuthal{latₒ,Datum}}, λ, ϕ) where {latₒ,Datum}
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
  cosβₒ = cos(βₒ)
  cosβ = cos(β)

  # check if the denominator of the B equation is not equal (or approx) to zero
  Bden = _laeaBden(βₒ, β, cosβₒ, cosβ, λ)
  abs(Bden) > atol(λ)
end

function formulas(::Type{<:LambertAzimuthal{latₒ,Datum}}, ::Type{T}) where {latₒ,Datum,T}
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
  fB(λ, β, cosβ) = Rq * sqrt(2 / _laeaBden(βₒ, β, cosβₒ, cosβ, λ))

  function fx(λ, ϕ)
    q = authq(ϕ, e, ome²)
    β = geod2auth(q, qₚ)
    cosβ = cos(β)
    sinλ = sin(λ)
    B = fB(λ, β, cosβ)
    (B * D) * (cosβ * sinλ)
  end

  function fy(λ, ϕ)
    q = authq(ϕ, e, ome²)
    β = geod2auth(q, qₚ)
    sinβ, cosβ = sincos(β)
    cosλ = cos(λ)
    B = fB(λ, β, cosβ)
    (B / D) * ((cosβₒ * sinβ) - (sinβₒ * cosβ * cosλ))
  end

  fx, fy
end

function forward(::Type{<:LambertAzimuthal{latₒ,Datum}}, λ, ϕ) where {latₒ,Datum}
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
  Bden = _laeaBden(βₒ, β, cosβₒ, cosβ, λ)
  if abs(Bden) < atol(λ)
    throw(ArgumentError("coordinates outside of the projection domain"))
  end

  D = (cosϕₒ / sqrt(1 - e² * sinϕₒ^2)) / (Rq * cosβₒ)
  B = Rq * sqrt(2 / Bden)

  x = (B * D) * (cosβ * sinλ)
  y = (B / D) * ((cosβₒ * sinβ) - (sinβₒ * cosβ * cosλ))

  x, y
end

function backward(::Type{<:LambertAzimuthal{latₒ,Datum}}, x, y) where {latₒ,Datum}
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

indomain(::Type{LambertAzimuthal{latₒ}}, coords::CRS{Datum}) where {latₒ,Datum} =
  indomain(LambertAzimuthal{latₒ,Datum}, coords)

Base.convert(::Type{LambertAzimuthal{latₒ}}, coords::CRS{Datum}) where {latₒ,Datum} =
  convert(LambertAzimuthal{latₒ,Datum}, coords)

# -----------------
# HELPER FUNCTIONS
# -----------------

# 1 + cos(c) with c the angular distance to the center of the projection, written
# as a sum of non-negative terms to avoid cancellation near the antipode
_laeaBden(βₒ, β, cosβₒ, cosβ, λ) = 2 * (sin((β + βₒ) / 2)^2 + (cosβₒ * cosβ) * cos(λ / 2)^2)
