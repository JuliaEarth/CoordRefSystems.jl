# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Stereographic{Mode,k₀,latₒ,Datum,Shift}

Stereographic CRS with given `Mode`, scale factor `k₀`, latitude origin `latₒ`,
`Datum` and `Shift`.
"""
struct Stereographic{Mode,k₀,latₒ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

Stereographic{Mode,k₀,latₒ,Datum,Shift}(x::M, y::M) where {Mode,k₀,latₒ,Datum,Shift,M<:Met} =
  Stereographic{Mode,k₀,latₒ,Datum,Shift,float(M)}(x, y)
Stereographic{Mode,k₀,latₒ,Datum,Shift}(x::Met, y::Met) where {Mode,k₀,latₒ,Datum,Shift} =
  Stereographic{Mode,k₀,latₒ,Datum,Shift}(promote(x, y)...)
Stereographic{Mode,k₀,latₒ,Datum,Shift}(x::Len, y::Len) where {Mode,k₀,latₒ,Datum,Shift} =
  Stereographic{Mode,k₀,latₒ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
Stereographic{Mode,k₀,latₒ,Datum,Shift}(x::Number, y::Number) where {Mode,k₀,latₒ,Datum,Shift} =
  Stereographic{Mode,k₀,latₒ,Datum,Shift}(addunit(x, m), addunit(y, m))

Stereographic{Mode,k₀,latₒ,Datum}(args...) where {Mode,k₀,latₒ,Datum} =
  Stereographic{Mode,k₀,latₒ,Datum,Shift()}(args...)

Stereographic{Mode,k₀,latₒ}(args...) where {Mode,k₀,latₒ} = Stereographic{Mode,k₀,latₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{Stereographic{Mode,k₀,latₒ,Datum,Shift,M}},
  coords::Stereographic{Mode,k₀,latₒ,Datum,Shift}
) where {Mode,k₀,latₒ,Datum,Shift,M} = Stereographic{Mode,k₀,latₒ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:Stereographic{Mode,k₀,latₒ,Datum,Shift}}) where {Mode,k₀,latₒ,Datum,Shift} =
  Stereographic{Mode,k₀,latₒ,Datum,Shift}

constructor(::Type{<:Stereographic{Mode,k₀,latₒ,Datum}}) where {Mode,k₀,latₒ,Datum} = Stereographic{Mode,k₀,latₒ,Datum}

constructor(::Type{<:Stereographic{Mode,k₀,latₒ}}) where {Mode,k₀,latₒ} = Stereographic{Mode,k₀,latₒ}

lentype(::Type{<:Stereographic{Mode,k₀,latₒ,Datum,Shift,M}}) where {Mode,k₀,latₒ,Datum,Shift,M} = M

==(
  coords₁::Stereographic{Mode,k₀,latₒ,Datum,Shift},
  coords₂::Stereographic{Mode,k₀,latₒ,Datum,Shift}
) where {Mode,k₀,latₒ,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

isconformal(::Type{<:Stereographic}) = true

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/stere.cpp
# reference formulas: https://neacsu.net/docs/geodesy/snyder/5-azimuthal/sect_21/

function inbounds(::Type{<:Stereographic{Mode,k₀,latₒ}}, λ, ϕ) where {Mode,k₀,latₒ}
  T = typeof(λ)
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  # the antipode of the center of the projection is at infinity
  cosc = sin(ϕₒ) * sin(ϕ) + cos(ϕₒ) * cos(ϕ) * cos(λ)
  cosc > -one(T) + atol(T)
end

function formulas(::Type{<:Stereographic{EllipticalMode,k₀,latₒ,Datum}}, ::Type{T}) where {k₀,latₒ,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  κ₀ = T(k₀)

  if _ispolar(ϕₒ)
    # in the polar aspect the parallels are concentric circles
    s = sign(ϕₒ)
    c = 2κ₀ / sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))
    ρ(ϕ) = c * _stereot(s * ϕ, e)

    fx(λ, ϕ) = ρ(ϕ) * sin(λ)
    fy(λ, ϕ) = -s * ρ(ϕ) * cos(λ)

    fx, fy
  else
    χₒ = _stereoχ(ϕₒ, e)
    mₒ = cos(ϕₒ) / sqrt(1 - e² * sin(ϕₒ)^2)
    sinχₒ, cosχₒ = sincos(χₒ)

    function fA(λ, χ)
      sinχ, cosχ = sincos(χ)
      2κ₀ * mₒ / (cosχₒ * (1 + sinχₒ * sinχ + cosχₒ * cosχ * cos(λ)))
    end

    function fx′(λ, ϕ)
      χ = _stereoχ(ϕ, e)
      fA(λ, χ) * cos(χ) * sin(λ)
    end

    function fy′(λ, ϕ)
      χ = _stereoχ(ϕ, e)
      sinχ, cosχ = sincos(χ)
      fA(λ, χ) * (cosχₒ * sinχ - sinχₒ * cosχ * cos(λ))
    end

    fx′, fy′
  end
end

function formulas(::Type{<:Stereographic{SphericalMode,k₀,latₒ,Datum}}, ::Type{T}) where {k₀,latₒ,Datum,T}
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  κ₀ = T(k₀)

  if _ispolar(ϕₒ)
    s = sign(ϕₒ)
    ρ(ϕ) = 2κ₀ * tan(T(π) / 4 - s * ϕ / 2)

    fx(λ, ϕ) = ρ(ϕ) * sin(λ)
    fy(λ, ϕ) = -s * ρ(ϕ) * cos(λ)

    fx, fy
  else
    sinϕₒ, cosϕₒ = sincos(ϕₒ)

    fk(λ, ϕ) = 2κ₀ / (1 + sinϕₒ * sin(ϕ) + cosϕₒ * cos(ϕ) * cos(λ))

    fx′(λ, ϕ) = fk(λ, ϕ) * cos(ϕ) * sin(λ)
    fy′(λ, ϕ) = fk(λ, ϕ) * (cosϕₒ * sin(ϕ) - sinϕₒ * cos(ϕ) * cos(λ))

    fx′, fy′
  end
end

function backward(C::Type{<:Stereographic{EllipticalMode,k₀,latₒ}}, x, y) where {k₀,latₒ}
  T = typeof(x)
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  λₛ, ϕₛ = _stereosphericalinv(x, y, ϕₒ, T(k₀))
  fx, fy = formulas(C, T)
  projinv(fx, fy, x, y, λₛ, ϕₛ)
end

function backward(::Type{<:Stereographic{SphericalMode,k₀,latₒ}}, x, y) where {k₀,latₒ}
  T = typeof(x)
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  _stereosphericalinv(x, y, ϕₒ, T(k₀))
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{Stereographic{Mode,k₀,latₒ}}, coords::CRS{Datum}) where {Mode,k₀,latₒ,Datum} =
  indomain(Stereographic{Mode,k₀,latₒ,Datum}, coords)

Base.convert(::Type{Stereographic{Mode,k₀,latₒ}}, coords::CRS{Datum}) where {Mode,k₀,latₒ,Datum} =
  convert(Stereographic{Mode,k₀,latₒ,Datum}, coords)

# -----------------
# HELPER FUNCTIONS
# -----------------

# tells whether or not the projection is in the polar aspect
_ispolar(ϕₒ) = abs(abs(ϕₒ) - oftype(ϕₒ, π) / 2) < atol(ϕₒ)

# conformal latitude, see equation 3-1 of Snyder
function _stereoχ(ϕ, e)
  esinϕ = e * sin(ϕ)
  2 * atan(tan(oftype(ϕ, π) / 4 + ϕ / 2) * ((1 - esinϕ) / (1 + esinϕ))^(e / 2)) - oftype(ϕ, π) / 2
end

# auxiliary quantity of the polar aspect, see equation 15-9 of Snyder
function _stereot(ϕ, e)
  esinϕ = e * sin(ϕ)
  tan(oftype(ϕ, π) / 4 - ϕ / 2) / ((1 - esinϕ) / (1 + esinϕ))^(e / 2)
end

function _stereosphericalinv(x, y, ϕₒ, k₀)
  ρ = hypot(x, y)
  if ρ < atol(x)
    zero(x), ϕₒ
  else
    c = 2 * atan(ρ, 2k₀)
    sinc, cosc = sincos(c)
    if _ispolar(ϕₒ)
      s = sign(ϕₒ)
      λ = atan(x, -s * y)
      ϕ = s * (oftype(x, π) / 2 - c)
      λ, ϕ
    else
      sinϕₒ, cosϕₒ = sincos(ϕₒ)
      λ = atan(x * sinc, ρ * cosϕₒ * cosc - y * sinϕₒ * sinc)
      ϕ = asinclamp(cosc * sinϕₒ + (y * sinc * cosϕₒ / ρ))
      λ, ϕ
    end
  end
end
