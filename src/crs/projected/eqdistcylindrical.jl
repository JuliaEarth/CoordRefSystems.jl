# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EquidistantCylindrical{latₜₛ,Datum}

Equidistant Cylindrical CRS with latitude of true scale `latₜₛ` in degrees and a given `Datum`.
"""
struct EquidistantCylindrical{latₜₛ,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
end

EquidistantCylindrical{latₜₛ,Datum}(x::M, y::M) where {latₜₛ,Datum,M<:Met} =
  EquidistantCylindrical{latₜₛ,Datum,float(M)}(x, y)
EquidistantCylindrical{latₜₛ,Datum}(x::Met, y::Met) where {latₜₛ,Datum} =
  EquidistantCylindrical{latₜₛ,Datum}(promote(x, y)...)
EquidistantCylindrical{latₜₛ,Datum}(x::Len, y::Len) where {latₜₛ,Datum} =
  EquidistantCylindrical{latₜₛ,Datum}(uconvert(m, x), uconvert(m, y))
EquidistantCylindrical{latₜₛ,Datum}(x::Number, y::Number) where {latₜₛ,Datum} =
  EquidistantCylindrical{latₜₛ,Datum}(addunit(x, m), addunit(y, m))

EquidistantCylindrical{latₜₛ}(args...) where {latₜₛ} = EquidistantCylindrical{latₜₛ,WGS84Latest}(args...)

Base.convert(
  ::Type{EquidistantCylindrical{latₜₛ,Datum,M}},
  coords::EquidistantCylindrical{latₜₛ,Datum}
) where {latₜₛ,Datum,M} = EquidistantCylindrical{latₜₛ,Datum,M}(coords.x, coords.y)

constructor(::Type{<:EquidistantCylindrical{latₜₛ,Datum}}) where {latₜₛ,Datum} = EquidistantCylindrical{latₜₛ,Datum}

lentype(::Type{<:EquidistantCylindrical{latₜₛ,Datum,M}}) where {latₜₛ,Datum,M} = M

==(coords₁::EquidistantCylindrical{latₜₛ,Datum}, coords₂::EquidistantCylindrical{latₜₛ,Datum}) where {latₜₛ,Datum} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

"""
    PlateCarree(x, y)
    PlateCarree{Datum}(x, y)

Plate Carrée coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
PlateCarree(1, 1) # add default units
PlateCarree(1m, 1m) # integers are converted converted to floats
PlateCarree(1.0km, 1.0km) # length quantities are converted to meters
PlateCarree(1.0m, 1.0m)
PlateCarree{WGS84Latest}(1.0m, 1.0m)
```

See [EPSG:32662](https://epsg.io/32662).
"""
const PlateCarree{Datum} = EquidistantCylindrical{0.0°,Datum}

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:EquidistantCylindrical{latₜₛ,Datum}}, ::Type{T}) where {latₜₛ,Datum,T}
  ϕₜₛ = T(ustrip(deg2rad(latₜₛ)))

  fx(λ, ϕ) = λ * cos(ϕₜₛ)

  fy(λ, ϕ) = ϕ

  fx, fy
end

function Base.convert(::Type{LatLon{Datum}}, coords::EquidistantCylindrical{latₜₛ,Datum}) where {latₜₛ,Datum}
  🌎 = ellipsoid(Datum)
  x = coords.x
  y = coords.y
  a = oftype(x, majoraxis(🌎))
  ϕₜₛ = numconvert(numtype(x), deg2rad(latₜₛ))

  λ = x / (cos(ϕₜₛ) * a)
  ϕ = y / a

  LatLon{Datum}(rad2deg(ϕ) * °, rad2deg(λ) * °)
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{EquidistantCylindrical{latₜₛ}}, coords::CRS{Datum}) where {latₜₛ,Datum} =
  convert(EquidistantCylindrical{latₜₛ,Datum}, coords)
