# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    AuthalicLatLon(lat, lon)
    AuthalicLatLon{Datum}(lat, lon)

Authalic latitude `lat ∈ [-90°,90°]` and longitude `lon ∈ [-180°,180°]` in angular units (default to degree)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
AuthalicLatLon(45, 45) # add default units
AuthalicLatLon(45°, 45°) # integers are converted converted to floats
AuthalicLatLon((π/4)rad, (π/4)rad) # radians are converted to degrees
AuthalicLatLon(45.0°, 45.0°)
AuthalicLatLon{WGS84Latest}(45.0°, 45.0°)
```
"""
struct AuthalicLatLon{Datum,D<:Deg} <: Geographic{Datum}
  lat::D
  lon::D
end

AuthalicLatLon{Datum}(lat::D, lon::D) where {Datum,D<:Deg} = AuthalicLatLon{Datum,float(D)}(checklat(lat), fixlon(lon))
AuthalicLatLon{Datum}(lat::Deg, lon::Deg) where {Datum} = AuthalicLatLon{Datum}(promote(lat, lon)...)
AuthalicLatLon{Datum}(lat::Rad, lon::Rad) where {Datum} = AuthalicLatLon{Datum}(rad2deg(lat), rad2deg(lon))
AuthalicLatLon{Datum}(lat::Number, lon::Number) where {Datum} = AuthalicLatLon{Datum}(addunit(lat, °), addunit(lon, °))

AuthalicLatLon(args...) = AuthalicLatLon{WGS84Latest}(args...)

Base.convert(::Type{AuthalicLatLon{Datum,D}}, coords::AuthalicLatLon{Datum}) where {Datum,D} =
  AuthalicLatLon{Datum,D}(coords.lat, coords.lon)

raw(coords::AuthalicLatLon) = ustrip(coords.lon), ustrip(coords.lat) # reverse order

constructor(::Type{<:AuthalicLatLon{Datum}}) where {Datum} = AuthalicLatLon{Datum}

function reconstruct(C::Type{<:AuthalicLatLon}, raw)
  lon, lat = raw .* units(C)
  constructor(C)(lat, lon) # reverse order
end

lentype(::Type{<:AuthalicLatLon{Datum,D}}) where {Datum,D} = Met{numtype(D)}

==(coords₁::AuthalicLatLon{Datum}, coords₂::AuthalicLatLon{Datum}) where {Datum} =
  coords₁.lat == coords₂.lat && coords₁.lon == coords₂.lon

Random.rand(rng::Random.AbstractRNG, ::Type{AuthalicLatLon{Datum}}) where {Datum} =
  AuthalicLatLon{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{AuthalicLatLon}) = rand(rng, AuthalicLatLon{WGS84Latest})

# ------------
# CONVERSIONS
# ------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

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

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{AuthalicLatLon}, coords::CRS{Datum}) where {Datum} = convert(AuthalicLatLon{Datum}, coords)

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
