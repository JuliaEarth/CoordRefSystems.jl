# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct TransverseMercator{kₒ,latₒ,lonₒ,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
  TransverseMercator{kₒ,latₒ,lonₒ,Datum}(x::M, y::M) where {kₒ,latₒ,lonₒ,Datum,M<:Met} =
    new{kₒ,latₒ,lonₒ,Datum,float(M)}(x, y)
end

TransverseMercator{kₒ,latₒ,lonₒ,Datum}(x::Met, y::Met) where {kₒ,latₒ,lonₒ,Datum} =
  TransverseMercator{kₒ,latₒ,lonₒ,Datum}(promote(x, y)...)
TransverseMercator{kₒ,latₒ,lonₒ,Datum}(x::Len, y::Len) where {kₒ,latₒ,lonₒ,Datum} =
  TransverseMercator{kₒ,latₒ,lonₒ,Datum}(uconvert(u"m", x), uconvert(u"m", y))
TransverseMercator{kₒ,latₒ,lonₒ,Datum}(x::Number, y::Number) where {kₒ,latₒ,lonₒ,Datum} =
  TransverseMercator{kₒ,latₒ,lonₒ,Datum}(addunit(x, u"m"), addunit(y, u"m"))

TransverseMercator{kₒ,latₒ,lonₒ}(args...) where {kₒ,latₒ,lonₒ} = TransverseMercator{kₒ,latₒ,lonₒ,WGS84Latest}(args...)

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:TransverseMercator{kₒ,latₒ,lonₒ,Datum}}, ::Type{T}) where {kₒ,latₒ,lonₒ,Datum,T}
  k = T(kₒ)
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  e² = T(eccentricity²(ellipsoid(Datum)))
  e⁴ = e²^2
  e⁶ = e²^3
  e′² = e² / (1 - e²)

  M(ϕ) =
    (1 - (e² / 4) - (3e⁴ / 64) - (5e⁶ / 256)) * ϕ - ((3e² / 8) + (3e⁴ / 32) + (45e⁶ / 1024)) * sin(2ϕ) +
    ((15e⁴ / 256) + (45e⁶ / 1024)) * sin(4ϕ) - (35e⁶ / 3072) * sin(6ϕ)

  function fx(λ, ϕ)
    λ -= λₒ
    sinϕ = sin(ϕ)
    cosϕ = cos(ϕ)
    tanϕ = tan(ϕ)
    tanϕ² = tanϕ^2
    tanϕ⁴ = tanϕ²^2
    tanϕ⁶ = tanϕ²^3

    ν = 1 / sqrt(1 - e² * sinϕ^2)
    η² = e′² * cosϕ^2
    λcosϕ = λ * cosϕ

    (k * ν) * (
      λcosϕ +
      λcosϕ^3 / 6 * (1 - tanϕ² + η²) +
      λcosϕ^5 / 120 * (5 - 18tanϕ² + tanϕ⁴ + 14η² - 58tanϕ² * η²) +
      λcosϕ^7 / 5040 * (61 - 479tanϕ² + 179tanϕ⁴ - tanϕ⁶)
    )
  end

  function fy(λ, ϕ)
    λ -= λₒ
    sinϕ = sin(ϕ)
    cosϕ = cos(ϕ)
    tanϕ = tan(ϕ)
    tanϕ² = tanϕ^2
    tanϕ⁴ = tanϕ²^2
    tanϕ⁶ = tanϕ²^3

    ν = 1 / sqrt(1 - e² * sinϕ^2)
    η² = e′² * cosϕ^2
    η⁴ = η²^2

    k * (
      M(ϕ) - M(ϕₒ) +
      ν * (
        λ^2 * sinϕ * cosϕ / 2 +
        λ^4 * sinϕ * cosϕ^3 / 24 * (5 - tanϕ² + 9η² + 4η⁴) +
        λ^6 * sinϕ * cosϕ^5 / 720 * (61 - 58tanϕ² + tanϕ⁴ + 270η² - 330tanϕ² * η²) +
        λ^8 * sinϕ * cosϕ^7 / 40320 * (1385 - 3111tanϕ² + 543tanϕ⁴ - tanϕ⁶)
      )
    )
  end

  fx, fy
end

function Base.convert(::Type{LatLon{Datum}}, coords::TransverseMercator{kₒ,latₒ,lonₒ,Datum}) where {kₒ,latₒ,lonₒ,Datum}
  🌎 = ellipsoid(Datum)
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(🌎))
  x = coords.x / a
  y = coords.y / a
  k = T(kₒ)
  λₒ = T(ustrip(deg2rad(lonₒ)))
  ϕₒ = T(ustrip(deg2rad(latₒ)))
  e² = T(eccentricity²(🌎))
  e⁴ = e²^2
  e⁶ = e²^3
  e′² = e² / (1 - e²)

  Mₒ =
    (1 - (e² / 4) - (3e⁴ / 64) - (5e⁶ / 256)) * ϕₒ - ((3e² / 8) + (3e⁴ / 32) + (45e⁶ / 1024)) * sin(2ϕₒ) +
    ((15e⁴ / 256) + (45e⁶ / 1024)) * sin(4ϕₒ) - (35e⁶ / 3072) * sin(6ϕₒ)
  M₁ = Mₒ + y / k
  μ₁ = M₁ / (1 - e² / 4 - 3e⁴ / 64 - 5e⁶ / 256)
  e₁ = (1 - sqrt(1 - e²)) / (1 + sqrt(1 - e²))
  e₁² = e₁^2
  e₁³ = e₁^3
  e₁⁴ = e₁^4
  ϕ₁ =
    μ₁ +
    (3e₁ / 2 - 27e₁³ / 32) * sin(2μ₁) +
    (21e₁² / 16 - 55e₁⁴ / 32) * sin(4μ₁) +
    (151e₁³ / 96) * sin(6μ₁) +
    (1097e₁⁴ / 512) * sin(8μ₁)
  C₁ = e′² * cos(ϕ₁)^2
  ν₁ = 1 / sqrt(1 - e² * sin(ϕ₁)^2)
  ρ₁ = (1 - e²) / sqrt(1 - e² * sin(ϕ₁)^2)
  D = x / (ν₁ * k)
  tanϕ₁ = tan(ϕ₁)
  tanϕ₁² = tanϕ₁^2

  λ = λₒ + (D - (1 + 2tanϕ₁² + C₁) * D^3 / 6 + (5 - 2C₁ + 28tanϕ₁² - 3C₁^2 + 8e′² + 24tanϕ₁²^2) * D^5 / 120) / cos(ϕ₁)
  ϕ =
    ϕ₁ -
    (ν₁ * tanϕ₁ / ρ₁) * (
      D^2 / 2 - (5 + 3tanϕ₁² + 10C₁ - 4C₁^2 - 9e′²) * D^4 / 24 +
      (61 + 90tanϕ₁² + 298C₁ + 45tanϕ₁²^2 - 252e′² - 3C₁^2) * D^6 / 720
    )

  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end
