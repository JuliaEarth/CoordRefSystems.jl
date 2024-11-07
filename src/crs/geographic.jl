# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Geographic{Datum}

Geographic CRS with a given `Datum`.
"""
abstract type Geographic{Datum} <: CRS{Datum} end

ndims(::Type{<:Geographic}) = 3

# ----------------
# IMPLEMENTATIONS
# ----------------

include("geographic/geodetic.jl")
include("geographic/geocentric.jl")
include("geographic/authalic.jl")

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# AuthalicLatLon <> GeodeticLatLon

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/projections/healpix.cpp#L230
# reference formula: https://mathworld.wolfram.com/AuthalicLatitude.html

function Base.convert(::Type{AuthalicLatLon{Datum}}, coords::LatLon{Datum}) where {Datum}
  🌎 = ellipsoid(Datum)
  ϕ = ustrip(deg2rad(coords.lat))
  e = oftype(ϕ, eccentricity(🌎))
  e² = oftype(ϕ, eccentricity²(🌎))

  ome² = 1 - e²
  sinϕ = sin(ϕ)
  esinϕ = e * sinϕ
  q = ome² * (sinϕ / (1 - esinϕ^2) - (1 / 2e) * log((1 - esinϕ) / (1 + esinϕ)))
  # same formula as q, but ϕ = 90°
  qₚ = ome² * (1 / ome² - (1 / 2e) * log((1 - e) / (1 + e)))
  qqₚ⁻¹ = q / qₚ

  if abs(qqₚ⁻¹) > 1
    # rounding error
    qqₚ⁻¹ = sign(qqₚ⁻¹)
  end

  β = asin(qqₚ⁻¹)
  AuthalicLatLon{Datum}(rad2deg(β) * °, coords.lon)
end

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/auth.cpp
# reference formula: https://mathworld.wolfram.com/AuthalicLatitude.html

function Base.convert(::Type{LatLon{Datum}}, coords::AuthalicLatLon{Datum}) where {Datum}
  β = ustrip(deg2rad(coords.lat))
  e² = oftype(β, eccentricity²(ellipsoid(Datum)))
  ϕ = auth2geod(β, e²)
  LatLon{Datum}(phi2lat(ϕ), coords.lon)
end

# GeocentricLatLon <> GeodeticLatLon

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/4D_api.cpp#L774

function Base.convert(::Type{GeocentricLatLon{Datum}}, coords::LatLon{Datum}) where {Datum}
  ϕ = ustrip(deg2rad(coords.lat))
  e² = oftype(ϕ, eccentricity²(ellipsoid(Datum)))
  ϕ′ = atan((1 - e²) * tan(ϕ))
  GeocentricLatLon{Datum}(rad2deg(ϕ′) * °, coords.lon)
end

function Base.convert(::Type{LatLon{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  ϕ′ = ustrip(deg2rad(coords.lat))
  e² = oftype(ϕ′, eccentricity²(ellipsoid(Datum)))
  ϕ = atan(1 / (1 - e²) * tan(ϕ′))
  LatLon{Datum}(phi2lat(ϕ), coords.lon)
end

# GeocentricLatLon <> GeodeticLatLonAlt

function Base.convert(::Type{GeocentricLatLon{Datum}}, coords::LatLonAlt{Datum}) where {Datum}
  ll = convert(LatLon, coords)
  convert(GeocentricLatLon{Datum}, ll)
end

function Base.convert(::Type{LatLonAlt{Datum}}, coords::GeocentricLatLon{Datum}) where {Datum}
  ll = convert(LatLon, coords)
  convert(LatLonAlt{Datum}, ll)
end

# GeocentricLatLonAlt <> GeodeticLatLonAlt

function Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::LatLonAlt{Datum}) where {Datum}
  lla = convert(GeocentricLatLon, LatLon{Datum}(coords.lat, coords.lon))
  GeocentricLatLonAlt{Datum}(lla.lat, lla.lon, coords.alt)
end

function Base.convert(::Type{LatLonAlt{Datum}}, coords::GeocentricLatLonAlt{Datum}) where {Datum}
  lla = convert(LatLon, GeocentricLatLon{Datum}(coords.lat, coords.lon))
  LatLonAlt{Datum}(lla.lat, lla.lon, coords.alt)
end

# -----------------
# HELPER FUNCTIONS
# -----------------

const _P₁₁ = 0.33333333333333333333 # 1 / 3
const _P₁₂ = 0.17222222222222222222 # 31 / 180
const _P₁₃ = 0.10257936507936507937 # 517 / 5040
const _P₂₁ = 0.06388888888888888888 # 23 / 360
const _P₂₂ = 0.06640211640211640212 # 251 / 3780
const _P₃₁ = 0.01677689594356261023 # 761 / 45360

# convert authalic latitude β to geodetic latitude ϕ
function auth2geod(β, e²)
  e⁴ = e²^2
  e⁶ = e²^3
  P₁₁ = oftype(β, _P₁₁)
  P₁₂ = oftype(β, _P₁₂)
  P₁₃ = oftype(β, _P₁₃)
  P₂₁ = oftype(β, _P₂₁)
  P₂₂ = oftype(β, _P₂₂)
  P₃₁ = oftype(β, _P₃₁)
  β + (P₁₁ * e² + P₁₂ * e⁴ + P₁₃ * e⁶) * sin(2β) + (P₂₁ * e⁴ + P₂₂ * e⁶) * sin(4β) + (P₃₁ * e⁶) * sin(6β)
end
