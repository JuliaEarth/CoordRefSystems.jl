# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EquidistantCylindrical{latₜₛ,Datum,Shift}

Equidistant Cylindrical CRS with latitude of true scale `latₜₛ` in degrees, `Datum` and `Shift`.
"""
struct EquidistantCylindrical{latₜₛ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

EquidistantCylindrical{latₜₛ,Datum,Shift}(x::M, y::M) where {latₜₛ,Datum,Shift,M<:Met} =
  EquidistantCylindrical{latₜₛ,Datum,Shift,float(M)}(x, y)
EquidistantCylindrical{latₜₛ,Datum,Shift}(x::Met, y::Met) where {latₜₛ,Datum,Shift} =
  EquidistantCylindrical{latₜₛ,Datum,Shift}(promote(x, y)...)
EquidistantCylindrical{latₜₛ,Datum,Shift}(x::Len, y::Len) where {latₜₛ,Datum,Shift} =
  EquidistantCylindrical{latₜₛ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
EquidistantCylindrical{latₜₛ,Datum,Shift}(x::Number, y::Number) where {latₜₛ,Datum,Shift} =
  EquidistantCylindrical{latₜₛ,Datum,Shift}(addunit(x, m), addunit(y, m))

EquidistantCylindrical{latₜₛ,Datum}(args...) where {latₜₛ,Datum} = EquidistantCylindrical{latₜₛ,Datum,Shift()}(args...)

EquidistantCylindrical{latₜₛ}(args...) where {latₜₛ} = EquidistantCylindrical{latₜₛ,WGS84Latest}(args...)

Base.convert(
  ::Type{EquidistantCylindrical{latₜₛ,Datum,Shift,M}},
  coords::EquidistantCylindrical{latₜₛ,Datum,Shift}
) where {latₜₛ,Datum,Shift,M} = EquidistantCylindrical{latₜₛ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:EquidistantCylindrical{latₜₛ,Datum,Shift}}) where {latₜₛ,Datum,Shift} =
  EquidistantCylindrical{latₜₛ,Datum,Shift}

lentype(::Type{<:EquidistantCylindrical{latₜₛ,Datum,Shift,M}}) where {latₜₛ,Datum,Shift,M} = M

==(
  coords₁::EquidistantCylindrical{latₜₛ,Datum,Shift},
  coords₂::EquidistantCylindrical{latₜₛ,Datum,Shift}
) where {latₜₛ,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

isequidistant(::Type{<:EquidistantCylindrical}) = true

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
const PlateCarree{Datum,Shift} = EquidistantCylindrical{0.0°,Datum,Shift}

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:EquidistantCylindrical{latₜₛ,Datum}}, ::Type{T}) where {latₜₛ,Datum,T}
  ϕₜₛ = T(ustrip(deg2rad(latₜₛ)))

  fx(λ, ϕ) = λ * cos(ϕₜₛ)

  fy(λ, ϕ) = ϕ

  fx, fy
end

function backward(::Type{<:EquidistantCylindrical{latₜₛ,Datum}}, x, y) where {latₜₛ,Datum}
  ϕₜₛ = oftype(x, ustrip(deg2rad(latₜₛ)))

  λ = x / cos(ϕₜₛ)
  ϕ = y

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{EquidistantCylindrical{latₜₛ}}, coords::CRS{Datum}) where {latₜₛ,Datum} =
  indomain(EquidistantCylindrical{latₜₛ,Datum}, coords)

Base.convert(::Type{EquidistantCylindrical{latₜₛ}}, coords::CRS{Datum}) where {latₜₛ,Datum} =
  convert(EquidistantCylindrical{latₜₛ,Datum}, coords)
