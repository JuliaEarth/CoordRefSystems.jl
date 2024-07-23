# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    TransverseMercator{k₀,latₒ,lonₒ,Datum}

Transverse Mercator CRS with scale factor `k₀`, latitude origin `latₒ`
and longitude origin `lonₒ` in degrees and a given `Datum`.
"""
struct TransverseMercator{k₀,latₒ,lonₒ,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
end

TransverseMercator{k₀,latₒ,lonₒ,Datum}(x::M, y::M) where {k₀,latₒ,lonₒ,Datum,M<:Met} =
  TransverseMercator{k₀,latₒ,lonₒ,Datum,float(M)}(x, y)
TransverseMercator{k₀,latₒ,lonₒ,Datum}(x::Met, y::Met) where {k₀,latₒ,lonₒ,Datum} =
  TransverseMercator{k₀,latₒ,lonₒ,Datum}(promote(x, y)...)
TransverseMercator{k₀,latₒ,lonₒ,Datum}(x::Len, y::Len) where {k₀,latₒ,lonₒ,Datum} =
  TransverseMercator{k₀,latₒ,lonₒ,Datum}(uconvert(u"m", x), uconvert(u"m", y))
TransverseMercator{k₀,latₒ,lonₒ,Datum}(x::Number, y::Number) where {k₀,latₒ,lonₒ,Datum} =
  TransverseMercator{k₀,latₒ,lonₒ,Datum}(addunit(x, u"m"), addunit(y, u"m"))

TransverseMercator{k₀,latₒ,lonₒ}(args...) where {k₀,latₒ,lonₒ} = TransverseMercator{k₀,latₒ,lonₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{TransverseMercator{k₀,latₒ,lonₒ,Datum,M}},
  coords::TransverseMercator{k₀,latₒ,lonₒ,Datum}
) where {k₀,latₒ,lonₒ,Datum,M} = TransverseMercator{k₀,latₒ,lonₒ,Datum,M}(coords.x, coords.y)

lentype(::Type{<:TransverseMercator{k₀,latₒ,lonₒ,Datum,M}}) where {k₀,latₒ,lonₒ,Datum,M} = M

constructor(::Type{<:TransverseMercator{k₀,latₒ,lonₒ,Datum}}) where {k₀,latₒ,lonₒ,Datum} =
  TransverseMercator{k₀,latₒ,lonₒ,Datum}

==(
  coords₁::TransverseMercator{k₀,latₒ,lonₒ,Datum},
  coords₂::TransverseMercator{k₀,latₒ,lonₒ,Datum}
) where {k₀,latₒ,lonₒ,Datum} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

Base.isapprox(
  coords₁::TransverseMercator{k₀,latₒ,lonₒ,Datum},
  coords₂::TransverseMercator{k₀,latₒ,lonₒ,Datum}
) where {k₀,latₒ,lonₒ,Datum} = isapprox(coords₁.x, coords₂.x; kwargs...) && isapprox(coords₁.y, coords₂.y; kwargs...)

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.
# Authors of the original algorithm: Knud Poder and Karsten Engsager
# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/tmerc.cpp

function inbounds(::Type{<:TransverseMercator{k₀,latₒ,lonₒ,Datum}}, λ, ϕ) where {k₀,latₒ,lonₒ,Datum}
  T = typeof(λ)
  🌎 = ellipsoid(Datum)
  a = numconvert(T, majoraxis(🌎))
  b = numconvert(T, minoraxis(🌎))
  λₒ = T(ustrip(deg2rad(lonₒ)))

  n = (a - b) / (a + b) # third flattening
  cbg, gtu = tmfwdcoefs(T, n)
  _, Ce = tmCnCe(λ - λₒ, ϕ, cbg, gtu)

  abs(Ce) ≤ T(2.623395162778)
end

function formulas(::Type{<:TransverseMercator{k₀,latₒ,lonₒ,Datum}}, ::Type{T}) where {k₀,latₒ,lonₒ,Datum,T}
  🌎 = ellipsoid(Datum)
  a = numconvert(T, majoraxis(🌎))
  b = numconvert(T, minoraxis(🌎))
  k = T(k₀)
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))

  n = (a - b) / (a + b) # third flattening
  cbg, gtu = tmfwdcoefs(T, n)
  Qn, Zb = tmQnZb(T, n, k, ϕₒ, cbg, gtu)

  function fx(λ, ϕ)
    λ -= λₒ
    _, Ce = tmCnCe(λ, ϕ, cbg, gtu)
    Qn * Ce
  end

  function fy(λ, ϕ)
    λ -= λₒ
    Cn, _ = tmCnCe(λ, ϕ, cbg, gtu)
    Qn * Cn + Zb
  end

  fx, fy
end

function Base.convert(C::Type{TransverseMercator{k₀,latₒ,lonₒ,Datum}}, coords::LatLon{Datum}) where {k₀,latₒ,lonₒ,Datum}
  🌎 = ellipsoid(Datum)
  T = numtype(coords.lon)
  λ = ustrip(deg2rad(coords.lon))
  ϕ = ustrip(deg2rad(coords.lat))
  k = T(k₀)
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  a = numconvert(T, majoraxis(🌎))
  b = numconvert(T, minoraxis(🌎))

  λ -= λₒ
  n = (a - b) / (a + b) # third flattening
  cbg, gtu = tmfwdcoefs(T, n)
  Qn, Zb = tmQnZb(T, n, k, ϕₒ, cbg, gtu)
  Cn, Ce = tmCnCe(λ, ϕ, cbg, gtu)

  if !(abs(Ce) ≤ T(2.623395162778))
    throw(ArgumentError("coordinates outside of the projection domain"))
  end

  x = (Qn * Ce) * a
  y = (Qn * Cn + Zb) * a

  C(x, y)
end

function Base.convert(::Type{LatLon{Datum}}, coords::TransverseMercator{k₀,latₒ,lonₒ,Datum}) where {k₀,latₒ,lonₒ,Datum}
  🌎 = ellipsoid(Datum)
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(🌎))
  b = numconvert(T, minoraxis(🌎))
  x = coords.x / a
  y = coords.y / a
  k = T(k₀)
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))

  n = (a - b) / (a + b) # third flattening
  cbg, gtu = tmfwdcoefs(T, n)
  Qn, Zb = tmQnZb(T, n, k, ϕₒ, cbg, gtu)

  Ce = x / Qn
  Cn = (y - Zb) / Qn

  cgb, utg = tminvcoefs(T, n)
  dCn, dCe = clenshaw(utg, Cn, Ce)
  Cn += dCn
  Ce += dCe

  sinCn = sin(Cn)
  cosCn = cos(Cn)
  sinhCe = sinh(Ce)
  Ce = atan(sinhCe, cosCn)
  Cn = atan(sinCn, hypot(sinhCe, cosCn))

  λ = Ce + λₒ
  ϕ = gatg(cgb, Cn)

  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{TransverseMercator{k₀,latₒ,lonₒ}}, coords::LatLon{Datum}) where {k₀,latₒ,lonₒ,Datum} =
  convert(TransverseMercator{k₀,latₒ,lonₒ,Datum}, coords)

Base.convert(::Type{LatLon}, coords::TransverseMercator{k₀,latₒ,lonₒ,Datum}) where {k₀,latₒ,lonₒ,Datum} =
  convert(LatLon{Datum}, coords)

# -----------------
# HELPER FUNCTIONS
# -----------------

function gatg(p, B)
  b = 2 * cos(2B)
  h = h₂ = zero(B)
  h₁, rest... = reverse(p)
  for pᵢ in rest
    h = -h₂ + b * h₁ + pᵢ
    h₂ = h₁
    h₁ = h
  end
  B + h * sin(2B)
end

# complex Clenshaw summation
function clenshaw(p, real, imag)
  sin2r, cos2r = sincos(2real)
  sinh2i, cosh2i = sinh(2imag), cosh(2imag)

  r = 2 * cos2r * cosh2i
  i = -2 * sin2r * sinh2i
  hi = hi₁ = hi₂ = zero(real)
  hr₁ = hr₂ = zero(real)
  hr, rest... = reverse(p)
  for pᵢ in rest
    hr₂ = hr₁
    hi₂ = hi₁
    hr₁ = hr
    hi₁ = hi
    hr = -hr₂ + r * hr₁ - i * hi₁ + pᵢ
    hi = -hi₂ + i * hr₁ + r * hi₁
  end

  r = sin2r * cosh2i
  i = cos2r * sinh2i
  R = r * hr - i * hi
  I = r * hi + i * hr

  R, I
end

# real Clenshaw summation
function clenshaw(p, real)
  r = 2 * cos(real)
  hr₁ = hr₂ = zero(real)
  hr, rest... = reverse(p)
  for pᵢ in rest
    hr₂ = hr₁
    hr₁ = hr
    hr = -hr₂ + r * hr₁ + pᵢ
  end
  sin(real) * hr
end

# forward coefficients of trig series
function tmfwdcoefs(T, n)
  n² = n^2
  n³ = n^3
  n⁴ = n²^2
  n⁵ = n² * n³
  n⁶ = n³^2

  # cbg: Geodetic -> Gaussian, KW p186 - 187 (51) - (52)
  cbg₁ = T(n * (-2 + n * (2 / 3 + n * (4 / 3 + n * (-82 / 45 + n * (32 / 45 + n * (4642 / 4725)))))))
  cbg₂ = T(n² * (5 / 3 + n * (-16 / 15 + n * (-13 / 9 + n * (904 / 315 + n * (-1522 / 945))))))
  cbg₃ = T(n³ * (-26 / 15 + n * (34 / 21 + n * (8 / 5 + n * (-12686 / 2835)))))
  cbg₄ = T(n⁴ * (1237 / 630 + n * (-12 / 5 + n * (-24832 / 14175))))
  cbg₅ = T(n⁵ * (-734 / 315 + n * (109598 / 31185)))
  cbg₆ = T(n⁶ * (444337 / 155925))

  # gtu: sph. N, E -> ell. N, E, KW p196 (69)
  gtu₁ = T(n * (0.5 + n * (-2 / 3 + n * (5 / 16 + n * (41 / 180 + n * (-127 / 288 + n * (7891 / 37800)))))))
  gtu₂ = T(n² * (13 / 48 + n * (-3 / 5 + n * (557 / 1440 + n * (281 / 630 + n * (-1983433 / 1935360))))))
  gtu₃ = T(n³ * (61 / 240 + n * (-103 / 140 + n * (15061 / 26880 + n * (167603 / 181440)))))
  gtu₄ = T(n⁴ * (49561 / 161280 + n * (-179 / 168 + n * (6601661 / 7257600))))
  gtu₅ = T(n⁵ * (34729 / 80640 + n * (-3418889 / 1995840)))
  gtu₆ = T(n⁶ * (212378941 / 319334400))

  cbg = (cbg₁, cbg₂, cbg₃, cbg₄, cbg₅, cbg₆)
  gtu = (gtu₁, gtu₂, gtu₃, gtu₄, gtu₅, gtu₆)

  cbg, gtu
end

# inverse coefficients of trig series
function tminvcoefs(T, n)
  n² = n^2
  n³ = n^3
  n⁴ = n²^2
  n⁵ = n² * n³
  n⁶ = n³^2

  # cgb: Gaussian -> Geodetic, KW p190 - 191 (61) - (62)
  cgb₁ = T(n * (2 + n * (-2 / 3 + n * (-2 + n * (116 / 45 + n * (26 / 45 + n * (-2854 / 675)))))))
  cgb₂ = T(n² * (7 / 3 + n * (-8 / 5 + n * (-227 / 45 + n * (2704 / 315 + n * (2323 / 945))))))
  cgb₃ = T(n³ * (56 / 15 + n * (-136 / 35 + n * (-1262 / 105 + n * (73814 / 2835)))))
  cgb₄ = T(n⁴ * (4279 / 630 + n * (-332 / 35 + n * (-399572 / 14175))))
  cgb₅ = T(n⁵ * (4174 / 315 + n * (-144838 / 6237)))
  cgb₆ = T(n⁶ * (601676 / 22275))

  # utg: ell. N, E -> sph. N, E, KW p194 (65)
  utg₁ = T(n * (-0.5 + n * (2 / 3 + n * (-37 / 96 + n * (1 / 360 + n * (81 / 512 + n * (-96199 / 604800)))))))
  utg₂ = T(n² * (-1 / 48 + n * (-1 / 15 + n * (437 / 1440 + n * (-46 / 105 + n * (1118711 / 3870720))))))
  utg₃ = T(n³ * (-17 / 480 + n * (37 / 840 + n * (209 / 4480 + n * (-5569 / 90720)))))
  utg₄ = T(n⁴ * (-4397 / 161280 + n * (11 / 504 + n * (830251 / 7257600))))
  utg₅ = T(n⁵ * (-4583 / 161280 + n * (108847 / 3991680)))
  utg₆ = T(n⁶ * (-20648693 / 638668800))

  cgb = (cgb₁, cgb₂, cgb₃, cgb₄, cgb₅, cgb₆)
  utg = (utg₁, utg₂, utg₃, utg₄, utg₅, utg₆)

  cgb, utg
end

function tmQnZb(T, n, k₀, ϕₒ, cbg, gtu)
  n² = n^2
  # norm. mer. quad, K&W p.50 (96), p.19 (38b), p.5 (2)
  Qn = T(k₀ / (1 + n) * (1 + n² * (1 / 4 + n² * (1 / 64 + n² / 256))))
  # gaussian latitude value of the origin latitude
  Z = gatg(cbg, ϕₒ)
  # origin northing minus true northing at the origin latitude
  Zb = -Qn * (Z + clenshaw(gtu, 2Z))
  Qn, Zb
end

function tmCnCe(λ, ϕ, cbg, gtu)
  Cn = gatg(cbg, ϕ)
  sinCn = sin(Cn)
  cosCn = cos(Cn)
  sinCe = sin(λ)
  cosCe = cos(λ)
  cosCncosCe = cosCn * cosCe
  tanCe = sinCe * cosCn / hypot(sinCn, cosCncosCe)

  Cn = atan(sinCn, cosCncosCe)
  Ce = asinh(tanCe)

  dCn, dCe = clenshaw(gtu, Cn, Ce)
  Cn += dCn
  Ce += dCe

  Cn, Ce
end
