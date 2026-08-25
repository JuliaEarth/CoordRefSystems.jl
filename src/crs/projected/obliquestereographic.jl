# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    ObliqueStereographic{k₀,latₒ,Datum,Shift}

Oblique Stereographic CRS with scale factor `k₀`, latitude origin `latₒ`,
`Datum` and `Shift`.
"""
struct ObliqueStereographic{k₀,latₒ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

ObliqueStereographic{k₀,latₒ,Datum,Shift}(x::M, y::M) where {k₀,latₒ,Datum,Shift,M<:Met} =
  ObliqueStereographic{k₀,latₒ,Datum,Shift,float(M)}(x, y)
ObliqueStereographic{k₀,latₒ,Datum,Shift}(x::Met, y::Met) where {k₀,latₒ,Datum,Shift} =
  ObliqueStereographic{k₀,latₒ,Datum,Shift}(promote(x, y)...)
ObliqueStereographic{k₀,latₒ,Datum,Shift}(x::Len, y::Len) where {k₀,latₒ,Datum,Shift} =
  ObliqueStereographic{k₀,latₒ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
ObliqueStereographic{k₀,latₒ,Datum,Shift}(x::Number, y::Number) where {k₀,latₒ,Datum,Shift} =
  ObliqueStereographic{k₀,latₒ,Datum,Shift}(addunit(x, m), addunit(y, m))

ObliqueStereographic{k₀,latₒ,Datum}(args...) where {k₀,latₒ,Datum} =
  ObliqueStereographic{k₀,latₒ,Datum,Shift()}(args...)

ObliqueStereographic{k₀,latₒ}(args...) where {k₀,latₒ} = ObliqueStereographic{k₀,latₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{ObliqueStereographic{k₀,latₒ,Datum,Shift,M}},
  coords::ObliqueStereographic{k₀,latₒ,Datum,Shift}
) where {k₀,latₒ,Datum,Shift,M} = ObliqueStereographic{k₀,latₒ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:ObliqueStereographic{k₀,latₒ,Datum,Shift}}) where {k₀,latₒ,Datum,Shift} =
  ObliqueStereographic{k₀,latₒ,Datum,Shift}

constructor(::Type{<:ObliqueStereographic{k₀,latₒ,Datum}}) where {k₀,latₒ,Datum} = ObliqueStereographic{k₀,latₒ,Datum}

constructor(::Type{<:ObliqueStereographic{k₀,latₒ}}) where {k₀,latₒ} = ObliqueStereographic{k₀,latₒ}

lentype(::Type{<:ObliqueStereographic{k₀,latₒ,Datum,Shift,M}}) where {k₀,latₒ,Datum,Shift,M} = M

==(
  coords₁::ObliqueStereographic{k₀,latₒ,Datum,Shift},
  coords₂::ObliqueStereographic{k₀,latₒ,Datum,Shift}
) where {k₀,latₒ,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

isconformal(::Type{<:ObliqueStereographic}) = true

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/sterea.cpp
#                 https://github.com/OSGeo/PROJ/blob/master/src/gauss.cpp
# reference formulas: EPSG Guidance Note 7-2, method 9809

function inbounds(::Type{<:ObliqueStereographic{k₀,latₒ}}, λ, ϕ) where {k₀,latₒ}
  T = typeof(λ)
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  # the antipode of the center of the projection is at infinity
  cosc = sin(ϕₒ) * sin(ϕ) + cos(ϕₒ) * cos(ϕ) * cos(λ)
  cosc > -one(T) + atol(T)
end

function formulas(::Type{<:ObliqueStereographic{k₀,latₒ,Datum}}, ::Type{T}) where {k₀,latₒ,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  κ₀ = T(k₀)

  C, K, χₒ, R = _gaussparams(ϕₒ, e, e²)
  sinχₒ, cosχₒ = sincos(χₒ)
  R₂ = 2R

  function fk(λᵪ, sinϕᵪ, cosϕᵪ)
    κ₀ * R₂ / (1 + sinχₒ * sinϕᵪ + cosχₒ * cosϕᵪ * cos(λᵪ))
  end

  function fx(λ, ϕ)
    λᵪ, ϕᵪ = _gauss(λ, ϕ, C, K, e)
    sinϕᵪ, cosϕᵪ = sincos(ϕᵪ)
    fk(λᵪ, sinϕᵪ, cosϕᵪ) * cosϕᵪ * sin(λᵪ)
  end

  function fy(λ, ϕ)
    λᵪ, ϕᵪ = _gauss(λ, ϕ, C, K, e)
    sinϕᵪ, cosϕᵪ = sincos(ϕᵪ)
    fk(λᵪ, sinϕᵪ, cosϕᵪ) * (cosχₒ * sinϕᵪ - sinχₒ * cosϕᵪ * cos(λᵪ))
  end

  fx, fy
end

function backward(::Type{<:ObliqueStereographic{k₀,latₒ,Datum}}, x, y) where {k₀,latₒ,Datum}
  T = typeof(x)
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  κ₀ = T(k₀)

  C, K, χₒ, R = _gaussparams(ϕₒ, e, e²)
  sinχₒ, cosχₒ = sincos(χₒ)
  R₂ = 2R

  xᵪ = x / κ₀
  yᵪ = y / κ₀
  ρ = hypot(xᵪ, yᵪ)

  λᵪ, ϕᵪ = if ρ < atol(x)
    zero(x), χₒ
  else
    c = 2 * atan(ρ, R₂)
    sinc, cosc = sincos(c)
    ϕ = asinclamp(cosc * sinχₒ + (yᵪ * sinc * cosχₒ / ρ))
    λ = atan(xᵪ * sinc, ρ * cosχₒ * cosc - yᵪ * sinχₒ * sinc)
    λ, ϕ
  end

  _invgauss(λᵪ, ϕᵪ, C, K, e)
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{ObliqueStereographic{k₀,latₒ}}, coords::CRS{Datum}) where {k₀,latₒ,Datum} =
  indomain(ObliqueStereographic{k₀,latₒ,Datum}, coords)

Base.convert(::Type{ObliqueStereographic{k₀,latₒ}}, coords::CRS{Datum}) where {k₀,latₒ,Datum} =
  convert(ObliqueStereographic{k₀,latₒ,Datum}, coords)

# -----------------
# HELPER FUNCTIONS
# -----------------

_srat(esinϕ, ratexp) = ((1 - esinϕ) / (1 + esinϕ))^ratexp

# constants of the conformal sphere of Gauss
function _gaussparams(ϕₒ, e, e²)
  sinϕₒ = sin(ϕₒ)
  cos²ϕₒ = cos(ϕₒ)^2
  fortpi = oftype(ϕₒ, π) / 4

  R = sqrt(1 - e²) / (1 - e² * sinϕₒ^2)
  C = sqrt(1 + e² * cos²ϕₒ^2 / (1 - e²))
  χₒ = asinclamp(sinϕₒ / C)
  K = tan(χₒ / 2 + fortpi) / (tan(ϕₒ / 2 + fortpi)^C * _srat(e * sinϕₒ, C * e / 2))

  C, K, χₒ, R
end

# geodetic latitude and longitude to the conformal sphere of Gauss
function _gauss(λ, ϕ, C, K, e)
  halfpi = oftype(ϕ, π) / 2
  fortpi = oftype(ϕ, π) / 4
  ϕᵪ = 2 * atan(K * tan(ϕ / 2 + fortpi)^C * _srat(e * sin(ϕ), C * e / 2)) - halfpi
  C * λ, ϕᵪ
end

# conformal sphere of Gauss to geodetic latitude and longitude
function _invgauss(λᵪ, ϕᵪ, C, K, e; maxiter=20)
  halfpi = oftype(ϕᵪ, π) / 2
  fortpi = oftype(ϕᵪ, π) / 4
  tol = atol(ϕᵪ)

  num = (tan(ϕᵪ / 2 + fortpi) / K)^(1 / C)
  ϕᵢ = ϕᵪ
  for _ in 1:maxiter
    ϕ = 2 * atan(num * _srat(e * sin(ϕᵢ), -e / 2)) - halfpi
    if abs(ϕ - ϕᵢ) < tol
      ϕᵢ = ϕ
      break
    end
    ϕᵢ = ϕ
  end

  λᵪ / C, ϕᵢ
end
