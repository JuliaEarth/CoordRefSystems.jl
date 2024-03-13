# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct TransverseMercator{kₒ,lonₒ,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
  TransverseMercator{kₒ,lonₒ,Datum}(x::M, y::M) where {kₒ,lonₒ,Datum,M<:Met} = new{kₒ,lonₒ,Datum,float(M)}(x, y)
end

TransverseMercator{kₒ,lonₒ,Datum}(x::Met, y::Met) where {kₒ,lonₒ,Datum} =
  TransverseMercator{kₒ,lonₒ,Datum}(promote(x, y)...)
TransverseMercator{kₒ,lonₒ,Datum}(x::Len, y::Len) where {kₒ,lonₒ,Datum} =
  TransverseMercator{kₒ,lonₒ,Datum}(uconvert(u"m", x), uconvert(u"m", y))
TransverseMercator{kₒ,lonₒ,Datum}(x::Number, y::Number) where {kₒ,lonₒ,Datum} =
  TransverseMercator{kₒ,lonₒ,Datum}(addunit(x, u"m"), addunit(y, u"m"))

TransverseMercator{kₒ,lonₒ}(args...) where {kₒ,lonₒ} = TransverseMercator{kₒ,lonₒ,WGS84Latest}(args...)

# ------------
# CONVERSIONS
# ------------

function Base.convert(C::Type{TransverseMercator{kₒ,lonₒ,Datum}}, coords::LatLon{Datum}) where {kₒ,lonₒ,Datum}
  🌎 = ellipsoid(Datum)
  T = numtype(coords.lon)
  λ = ustrip(deg2rad(coords.lon))
  ϕ = ustrip(deg2rad(coords.lat))
  if !inbounds(C, λ, ϕ)
    throw(ArgumentError("coordinates outside of the projection domain"))
  end
  a = numconvert(T, majoraxis(🌎))
  e = T(eccentricity²(🌎))
  e² = T(eccentricity²(🌎))
  k = T(kₒ)
  λₒ = T(ustrip(deg2rad(lonₒ)))

  λ -= λₒ
  λsign = signbit(λ) ? -1 : 1
  ϕsign = signbit(ϕ) ? -1 : 1
  λ *= λsign
  ϕ *= ϕsign

  mu = e²
  mv = 1 - e²
  τ = tan(ϕ)
  τ′ = tauprime(τ, e)
  halfπ = T(π / 2)
  u, v = if ϕ == halfπ
    Elliptic.K(mu), zero(T)
  elseif ϕ == 0 && λ == halfπ * (1 - e)
    zero(T), Elliptic.K(mv)
  else
    zetainv(T, τ′, λ, e, mu, mv)
  end
  snu, cnu, dnu = sncndn(u, mu)
  snv, cnv, dnv = sncndn(v, mv)

  # unsacled x,y
  xu, yu = sigma(u, v, snu, cnu, dnu, snv, cnv, dnv, mu, mv)

  x = xu * a * k * λsign
  y = yu * a * k * ϕsign

  C(x, y)
end

function Base.convert(::Type{LatLon{Datum}}, coords::TransverseMercator{kₒ,lonₒ,Datum}) where {kₒ,lonₒ,Datum}
  🌎 = ellipsoid(Datum)
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(🌎))
  e = T(eccentricity²(🌎))
  e² = T(eccentricity²(🌎))
  k = T(kₒ)
  λₒ = T(ustrip(deg2rad(lonₒ)))
  x = coords.x / (a * k)
  y = coords.y / (a * k)

  xsign = signbit(x) ? -1 : 1
  ysign = signbit(y) ? -1 : 1
  x *= xsign
  y *= ysign

  mu = e²
  mv = 1 - e²
  Kmv = Elliptic.K(mv)
  Emv = Elliptic.E(mv)
  KEmv = Kmv - Emv
  u, v = if x == 0 && y == KEmv
    zero(T), Kmv
  else
    sigmainv(T, x, y, e, mu, mv)
  end
  snu, cnu, dnu = sncndn(u, mu)
  snv, cnv, dnv = sncndn(v, mv)

  if (v ≠ 0 || u ≠ Elliptic.K(mu))
    τ′, λ = zeta(T, snu, cnu, dnu, snv, cnv, dnv, e, mu, mv)
    τ = tau(τ′, e)
    ϕ = atan(τ)
  else
    λ = zero(T)
    ϕ = T(π / 2)
  end

  λ = (λ + λₒ) * xsign
  ϕ = ϕ * ysign

  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end

# -----------------
# HELPER FUNCTIONS
# -----------------

eatanhe(x, e) = e > 0 ? e * atanh(e * x) : -e * atan(e * x)

function tauprime(τ, e)
  τ₁ = hypot(one(τ), τ)
  sig = sinh(eatanhe(τ / τ₁, e))
  hypot(one(τ), sig) * τ - sig * τ₁
end

function tau(τ′, e; maxiter=5)
  sqrteps = sqrt(eps(typeof(τ′)))
  tol = sqrteps / 10
  τmax = 2 / sqrteps

  o = one(τ′)
  ome² = o - e^2
  τ = abs(τ′) > 70 ? τ′ * exp(eatanhe(o, e)) : τ′ / ome²
  stol = tol * max(o, abs(τ′))

  if !(abs(τ′) < τmax)
    return τ
  end

  for _ in 1:maxiter
    τ′ᵢ = tauprime(τ, e)
    dτ = (τ′ - τ′ᵢ) * (1 + ome² * τ^2) / (ome² * hypot(o, τ) * hypot(o, τ′ᵢ))
    τ += dτ
    if !(abs(dτ) >= stol)
      break
    end
  end

  τ
end

sncndn(u, m) = Jacobi.sn(u, m), Jacobi.cn(u, m), Jacobi.dn(u, m)

# Lee 54.17
function zeta(T, snu, cnu, dnu, snv, cnv, dnv, e, mu, mv)
  o = 1 / eps(T)^2
  overflow = ifelse(signbit(snu), -o, o)

  d₁ = sqrt(cnu^2 + mv * (snu * snv)^2)
  d₂ = sqrt(mu * cnu^2 + mv * cnv^2)
  t₁ = ifelse(d₁ ≠ 0, snu * dnv / d₁, overflow)
  t₂ = ifelse(d₂ ≠ 0, sinh(e * asin(e * snu / d₂)), overflow)

  τ′ = t₁ * hypot(one(T), t₂) - t₂ * hypot(one(T), t₁)
  λ = ifelse(d₁ ≠ 0 && d₂ ≠ 0, atan(dnu * snv, cnu * cnv) - e * atan(e * cnu * snv, dnu * cnv), zero(T))
  τ′, λ
end

# Lee 54.21
function dwdzeta(snu, cnu, dnu, snv, cnv, dnv, mu, mv)
  d = mv * (cnv^2 + mu * (snu * snv)^2)^2
  du = cnu * dnu * dnv * (cnv^2 - mu * (snu * snv)^2) / d
  dv = -snu * snv * cnv * ((dnu * dnv)^2 + mu * cnu^2) / d
  du, dv
end

# Starting point for zetainv
function zetainv0(T, ψ, λ, e, mu, mv)
  retval = false
  Kmu = Elliptic.K(mu)
  Kmv = Elliptic.K(mv)
  halfπ = T(π / 2)
  taytol = eps(T)^T(0.6)
  if (ψ < -e * T(π / 4)) && (λ > (1 - 2e) * halfπ) && (ψ < λ - (1 - e) * halfπ)
    ψx = 1 - ψ / e
    λx = (halfπ - λ) / e
    u = asinh(sin(λx) / hypot(cos(λx), sin(ψx))) * (1 + mu / 2)
    v = atan(cos(λx), sin(ψx)) * (1 + mu / 2)
    u = Kmu - u
    v = Kmv - v
  elseif (ψ < e * halfπ) && (λ > (1 - 2e) * halfπ)
    dλ = λ - (1 - e) * halfπ
    rad = hypot(ψ, dλ)
    ang = atan(dλ - ψ, ψ + dλ) - T(0.75) * π
    retval = rad < e * taytol
    rad = cbrt(3 / (mv * e) * rad)
    ang /= 3
    u = rad * cos(ang)
    v = rad * sin(ang) + Kmv
  else
    v = asinh(sin(λ) / hypot(cos(λ), sinh(ψ)))
    u = atan(sinh(ψ), cos(λ))
    u *= Kmu / halfπ
    v *= Kmu / halfπ
  end
  u, v, retval
end

function zetainv(T, τ′, λ, e, mu, mv; maxiter=10)
  tol2 = eps(T) * T(0.1)
  ψ = asin(τ′)
  scal = 1 / hypot(one(T), τ′)
  u, v, retval = zetainv0(T, ψ, λ, e, mu, mv)
  if retval
    return u, v
  end
  stol2 = tol2 / max(ψ, one(T))^2
  trip = 0
  for _ in 1:maxiter
    snu, cnu, dnu = sncndn(u, mu)
    snv, cnv, dnv = sncndn(v, mv)
    τ1, λ1 = zeta(T, snu, cnu, dnu, snv, cnv, dnv, e, mu, mv)
    du1, dv1 = dwdzeta(snu, cnu, dnu, snv, cnv, dnv, mu, mv)
    τ1 -= τ′
    λ1 -= λ
    τ1 *= scal
    delu = τ1 * du1 - λ1 * dv1
    delv = τ1 * dv1 + λ1 * du1
    u -= delu
    v -= delv
    if trip > 0
      break
    end
    delw2 = delu^2 + delv^2
    if !(delw2 >= stol2)
      trip += 1
    end
  end
  u, v
end

# xi = x/a (x unsacled)
# eta = y/a (y unsacled)

function sigma(u, v, snu, cnu, dnu, snv, cnv, dnv, mu, mv)
  d = mu * cnu^2 + mv * cnv^2
  x = Elliptic.E(u, mu) - mu * snu * cnu * dnu / d
  y = v - Elliptic.E(v, mv) + mv * snv * cnv * dnv / d
  x, y
end

function dwdsigma(snu, cnu, dnu, snv, cnv, dnv, mu, mv)
  d = mv * (cnv^2 + mu * (snu * snv)^2)^2
  dnr = dnu * cnv * dnv
  dni = -mu * snu * cnu * snv
  du = (dnr^2 - dni^2) / d
  dv = 2 * dnr * dni / d
  du, dv
end

# Starting point for sigmainv
function sigmainv0(T, x, y, mu, mv)
  retval = false
  Kmu = Elliptic.K(mu)
  Kmv = Elliptic.K(mv)
  Emu = Elliptic.E(mu)
  Emv = Elliptic.E(mv)
  KEmv = Kmv - Emv
  taytol = eps(T)^T(0.6)
  if (y > T(1.25) * KEmv) || ((x < -T(0.25) * Emu && (x < y - KEmv)))
    a = x - Emu
    b = y - KEmv
    c² = a^2 + b^2
    u = Kmu + a / c²
    v = Kmv - b / c²
  elseif ((y > T(0.75) * KEmv) && (x < T(0.25) * Emu)) || (y > KEmv)
    dy = y - KEmv
    rad = hypot(x, dy)
    ang = atan(dy - x, x + dy) - T(0.75π)
    retval = rad < 2 * taytol
    rad = cbrt(3 / mv * rad)
    ang /= 3
    u = rad * cos(ang)
    v = rad * sin(ang) + Kmv
  else
    u = x * Kmu / Emu
    v = y * Kmu / Emu
  end
  u, v, retval
end

function sigmainv(T, x, y, e, mu, mv; maxiter=10)
  tol2 = eps(T) * T(0.1)
  u, v, retval = sigmainv0(T, x, y, mu, mv)
  if retval
    return u, v
  end
  trip = 0
  for _ in 1:maxiter
    snu, cnu, dnu = sncndn(u, mu)
    snv, cnv, dnv = sncndn(v, mv)
    x1, y1 = sigma(u, v, snu, cnu, dnu, snv, cnv, dnv, mu, mv)
    du1, dv1 = dwdsigma(snu, cnu, dnu, snv, cnv, dnv, mu, mv)
    x1 -= x
    y1 -= y
    delu = x1 * du1 - y1 * dv1
    delv = x1 * dv1 + y1 * du1
    u -= delu
    v -= delv
    if trip > 0
      break
    end
    delw2 = delu^2 + delv^2
    if !(delw2 >= tol2)
      trip += 1
    end
  end
  u, v
end
