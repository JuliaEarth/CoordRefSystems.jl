# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct EDCHyper{D<:Deg}
  latₜₛ::D
end

EDCHyper(; latₜₛ=0.0°) = EDCHyper(asdeg(latₜₛ))

"""
    EquidistantCylindrical{Datum,Hyper,Shift}

Equidistant Cylindrical CRS with latitude of true scale `latₜₛ` in degrees and a given `Datum`.
"""
struct EquidistantCylindrical{Datum,Hyper,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

EquidistantCylindrical{Datum,Hyper,Shift}(x::M, y::M) where {Datum,Hyper,Shift,M<:Met} =
  EquidistantCylindrical{Datum,Hyper,Shift,float(M)}(x, y)
EquidistantCylindrical{Datum,Hyper,Shift}(x::Met, y::Met) where {Datum,Hyper,Shift} =
  EquidistantCylindrical{Datum,Hyper,Shift}(promote(x, y)...)
EquidistantCylindrical{Datum,Hyper,Shift}(x::Len, y::Len) where {Datum,Hyper,Shift} =
  EquidistantCylindrical{Datum,Hyper,Shift}(uconvert(m, x), uconvert(m, y))
EquidistantCylindrical{Datum,Hyper,Shift}(x::Number, y::Number) where {Datum,Hyper,Shift} =
  EquidistantCylindrical{Datum,Hyper,Shift}(addunit(x, m), addunit(y, m))

EquidistantCylindrical{Datum,Hyper}(args...) where {Datum,Hyper} = EquidistantCylindrical{Datum,Hyper,Shift()}(args...)

Base.convert(
  ::Type{EquidistantCylindrical{Datum,Hyper,Shift,M}},
  coords::EquidistantCylindrical{Datum,Hyper,Shift}
) where {Datum,Hyper,Shift,M} = EquidistantCylindrical{Datum,Hyper,Shift,M}(coords.x, coords.y)

constructor(::Type{<:EquidistantCylindrical{Datum,Hyper,Shift}}) where {Datum,Hyper,Shift} =
  EquidistantCylindrical{Datum,Hyper,Shift}

lentype(::Type{<:EquidistantCylindrical{Datum,Hyper,Shift,M}}) where {Datum,Hyper,Shift,M} = M

==(
  coords₁::EquidistantCylindrical{Datum,Hyper,Shift},
  coords₂::EquidistantCylindrical{Datum,Hyper,Shift}
) where {Datum,Hyper,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

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
const PlateCarree{Datum,Shift} = EquidistantCylindrical{Datum,EDCHyper(latₜₛ = 0.0°),Shift}

PlateCarree(args...) = PlateCarree{WGS84Latest}(args...)

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:EquidistantCylindrical{Datum,Hyper}}, ::Type{T}) where {Datum,Hyper,T}
  ϕₜₛ = T(ustrip(deg2rad(Hyper.latₜₛ)))

  fx(λ, ϕ) = λ * cos(ϕₜₛ)

  fy(λ, ϕ) = ϕ

  fx, fy
end

function backward(::Type{<:EquidistantCylindrical{Datum,Hyper}}, x, y) where {Datum,Hyper}
  ϕₜₛ = oftype(x, ustrip(deg2rad(Hyper.latₜₛ)))

  λ = x / cos(ϕₜₛ)
  ϕ = y

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{PlateCarree}, coords::CRS{Datum}) where {Datum} = convert(PlateCarree{Datum}, coords)
