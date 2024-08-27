# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EquidistantCylindricalParams(; latₜₛ=0.0°)

Equidistant Cylindrical parameters with a given latitude of true scale `latₜₛ`.
"""
struct EquidistantCylindricalParams{D<:Deg}
  latₜₛ::D
end

EquidistantCylindricalParams(; latₜₛ=0.0°) = EquidistantCylindricalParams(asdeg(latₜₛ))

"""
    EquidistantCylindrical{Datum,Params,Shift}

Equidistant Cylindrical CRS with a given `Datum`, `Params` and `Shift`.
"""
struct EquidistantCylindrical{Datum,Params,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

EquidistantCylindrical{Datum,Params,Shift}(x::M, y::M) where {Datum,Params,Shift,M<:Met} =
  EquidistantCylindrical{Datum,Params,Shift,float(M)}(x, y)
EquidistantCylindrical{Datum,Params,Shift}(x::Met, y::Met) where {Datum,Params,Shift} =
  EquidistantCylindrical{Datum,Params,Shift}(promote(x, y)...)
EquidistantCylindrical{Datum,Params,Shift}(x::Len, y::Len) where {Datum,Params,Shift} =
  EquidistantCylindrical{Datum,Params,Shift}(uconvert(m, x), uconvert(m, y))
EquidistantCylindrical{Datum,Params,Shift}(x::Number, y::Number) where {Datum,Params,Shift} =
  EquidistantCylindrical{Datum,Params,Shift}(addunit(x, m), addunit(y, m))

EquidistantCylindrical{Datum,Params}(args...) where {Datum,Params} = EquidistantCylindrical{Datum,Params,Shift()}(args...)

Base.convert(
  ::Type{EquidistantCylindrical{Datum,Params,Shift,M}},
  coords::EquidistantCylindrical{Datum,Params,Shift}
) where {Datum,Params,Shift,M} = EquidistantCylindrical{Datum,Params,Shift,M}(coords.x, coords.y)

constructor(::Type{<:EquidistantCylindrical{Datum,Params,Shift}}) where {Datum,Params,Shift} =
  EquidistantCylindrical{Datum,Params,Shift}

lentype(::Type{<:EquidistantCylindrical{Datum,Params,Shift,M}}) where {Datum,Params,Shift,M} = M

==(
  coords₁::EquidistantCylindrical{Datum,Params,Shift},
  coords₂::EquidistantCylindrical{Datum,Params,Shift}
) where {Datum,Params,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

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
const PlateCarree{Datum,Shift} = EquidistantCylindrical{Datum,EquidistantCylindricalParams(latₜₛ = 0.0°),Shift}

PlateCarree(args...) = PlateCarree{WGS84Latest}(args...)

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:EquidistantCylindrical{Datum,Params}}, ::Type{T}) where {Datum,Params,T}
  ϕₜₛ = T(ustrip(deg2rad(Params.latₜₛ)))

  fx(λ, ϕ) = λ * cos(ϕₜₛ)

  fy(λ, ϕ) = ϕ

  fx, fy
end

function backward(::Type{<:EquidistantCylindrical{Datum,Params}}, x, y) where {Datum,Params}
  ϕₜₛ = oftype(x, ustrip(deg2rad(Params.latₜₛ)))

  λ = x / cos(ϕₜₛ)
  ϕ = y

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{PlateCarree}, coords::CRS{Datum}) where {Datum} = convert(PlateCarree{Datum}, coords)
