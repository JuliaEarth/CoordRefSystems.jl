# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    LambertConic{latₒ,lat₁,lat₂,Datum,Shift}

Lambert Conic Conformal CRS with latitude origin `latₒ` standard parallels `lat₁` and `lat₂`,  `Datum` and `Shift`.
"""
struct LambertConic{latₒ,lat₁,lat₂,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

LamberConic{latₒ,lat₁,lat₂,Datum,Shift}(x::M, y::M) where {latₒ,lat₁,lat₂,Datum,Shift,M<:Met} =
  LamberConic{latₒ,lat₁,lat₂,Datum,Shift,float(M)}(x, y)
LamberConic{latₒ,lat₁,lat₂,Datum,Shift}(x::Met, y::Met) where {latₒ,lat₁,lat₂,Datum,Shift} =
  LamberConic{latₒ,lat₁,lat₂,Datum,Shift}(promote(x, y)...)
LamberConic{latₒ,lat₁,lat₂,Datum,Shift}(x::Len, y::Len) where {latₒ,lat₁,lat₂,Datum,Shift} =
  LamberConic{latₒ,lat₁,lat₂,Datum,Shift}(uconvert(m, x), uconvert(m, y))
LamberConic{latₒ,lat₁,lat₂,Datum,Shift}(x::Number, y::Number) where {latₒ,lat₁,lat₂,Datum,Shift} =
  LamberConic{latₒ,lat₁,lat₂,Datum,Shift}(addunit(x, m), addunit(y, m))

LamberConic{latₒ,lat₁,lat₂,Datum}(args...) where {latₒ,lat₁,lat₂,Datum} = LamberConic{latₒ,lat₁,lat₂,Datum,Shift()}(args...)

LamberConic{latₒ,lat₁,lat₂}(args...) where {latₒ,lat₁,lat₂} = LamberConic{latₒ,lat₁,lat₂,WGS84Latest}(args...)

Base.convert(
  ::Type{LamberConic{latₒ,lat₁,lat₂,Datum,Shift,M}},
  coords::LamberConic{latₒ,lat₁,lat₂,Datum,Shift}
) where {latₒ,lat₁,lat₂,Datum,Shift,M} = LamberConic{latₒ,lat₁,lat₂,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:LamberConic{latₒ,lat₁,lat₂,Datum,Shift}}) where {latₒ,lat₁,lat₂,Datum,Shift} =
  LamberConic{latₒ,lat₁,lat₂,Datum,Shift}

lentype(::Type{<:LamberConic{latₒ,lat₁,lat₂,Datum,Shift,M}}) where {latₒ,lat₁,lat₂,Datum,Shift,M} = M

==(
  coords₁::LamberConic{latₒ,lat₁,lat₂,Datum,Shift},
  coords₂::LamberConic{latₒ,lat₁,lat₂,Datum,Shift}
) where {latₒ,lat₁,lat₂,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y


# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:LamberConic{latₒ,lat₁,lat₂,Datum}}, ::Type{T}) where {latₒ,lat₁,lat₂,Datum,T}
  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  e² = T(eccentricity²(🌎))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  ϕ₁ = T(ustrip(deg2rad(lat₁)))
  ϕ₂ = T(ustrip(deg2rad(lat₂)))

  F, n = _lambertFn(ϕ₁, ϕ₂, e, e²)
  
  θ(λ) = n * λ
  t(ϕ) = _lambertt(ϕ, e)
  r(ϕ) = _lambertr(F, t(ϕ), n)
  
  t₀ = _lambertt(ϕₒ, e)
  r₀ = _lambertr(F, t₀, n)

  fx(λ, ϕ) = r(ϕ) * sin(θ(λ))

  fy(λ, ϕ) = r₀ - r(ϕ) * cos(θ(λ))

  fx, fy
end

# -----------------
# HELPER FUNCTIONS
# -----------------

function _lambertFn(ϕ₁, ϕ₂, e, e²)
  m₁ = _lambertm(ϕ₁, e²)
  m₂ = _lambertm(ϕ₂, e²)
  t₁ = _lambertt(ϕ₁, e)
  t₂ = _lambertt(ϕ₂, e)

  n = (log(m₁) - log(m₂)) / (log(t₁) - log(t₂))
  F = m₁ / (n * t₁^n)
  F, n
end

_lambertm(ϕ, e²) = cos(ϕ) / sqrt(1 - e² * sin(ϕ)^2)

_lambertt(ϕ, e) = tan(π/4 - ϕ/2) / ((1 - e * sin(ϕ)) / (1 + e * sin(ϕ)))^(e/2)

_lambertr(F, t, n) = F * t^n

# ----------
# FALLBACKS
# ----------

indomain(::Type{LamberConic{latₒ,lat₁,lat₂}}, coords::CRS{Datum}) where {latₒ,lat₁,lat₂,Datum} =
  indomain(LamberConic{latₒ,lat₁,lat₂,Datum}, coords)

Base.convert(::Type{LamberConic{latₒ,lat₁,lat₂}}, coords::CRS{Datum}) where {latₒ,lat₁,lat₂,Datum} =
  convert(LamberConic{latₒ,lat₁,lat₂,Datum}, coords)
