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

Base.isapprox(coords₁::AuthalicLatLon{Datum}, coords₂::AuthalicLatLon{Datum}; kwargs...) where {Datum} =
  isapprox(coords₁.lat, coords₂.lat; kwargs...) && isapprox(coords₁.lon, coords₂.lon; kwargs...)

Random.rand(rng::Random.AbstractRNG, ::Type{AuthalicLatLon{Datum}}) where {Datum} =
  AuthalicLatLon{Datum}(-90 + 180 * rand(rng), -180 + 360 * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{AuthalicLatLon}) = rand(rng, AuthalicLatLon{WGS84Latest})

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{AuthalicLatLon}, coords::CRS{Datum}) where {Datum} = convert(AuthalicLatLon{Datum}, coords)
