# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct EDCHyper{D<:Deg}
  latₜₛ::D
end

EDCHyper(; latₜₛ=0.0°) = EDCHyper(asdeg(latₜₛ))

"""
    EquidistantCylindrical{Hyper,Shift,Datum}

Equidistant Cylindrical CRS with latitude of true scale `latₜₛ` in degrees and a given `Datum`.
"""
struct EquidistantCylindrical{Hyper,Shift,Datum,M<:Met} <: Projected{Shift,Datum}
  x::M
  y::M
end

EquidistantCylindrical{Hyper,Shift,Datum}(x::M, y::M) where {Hyper,Shift,Datum,M<:Met} =
  EquidistantCylindrical{Hyper,Shift,Datum,float(M)}(x, y)
EquidistantCylindrical{Hyper,Shift,Datum}(x::Met, y::Met) where {Hyper,Shift,Datum} =
  EquidistantCylindrical{Hyper,Shift,Datum}(promote(x, y)...)
EquidistantCylindrical{Hyper,Shift,Datum}(x::Len, y::Len) where {Hyper,Shift,Datum} =
  EquidistantCylindrical{Hyper,Shift,Datum}(uconvert(m, x), uconvert(m, y))
EquidistantCylindrical{Hyper,Shift,Datum}(x::Number, y::Number) where {Hyper,Shift,Datum} =
  EquidistantCylindrical{Hyper,Shift,Datum}(addunit(x, m), addunit(y, m))

EquidistantCylindrical{Hyper,Shift}(args...) where {Hyper,Shift} =
  EquidistantCylindrical{Hyper,Shift,WGS84Latest}(args...)

EquidistantCylindrical{Hyper}(args...) where {Hyper} = EquidistantCylindrical{Hyper,Shift(),WGS84Latest}(args...)

Base.convert(
  ::Type{EquidistantCylindrical{Hyper,Shift,Datum,M}},
  coords::EquidistantCylindrical{Hyper,Shift,Datum}
) where {Hyper,Shift,Datum,M} = EquidistantCylindrical{Hyper,Shift,Datum,M}(coords.x, coords.y)

constructor(::Type{<:EquidistantCylindrical{Hyper,Shift,Datum}}) where {Hyper,Shift,Datum} =
  EquidistantCylindrical{Hyper,Shift,Datum}

lentype(::Type{<:EquidistantCylindrical{Hyper,Shift,Datum,M}}) where {Hyper,Shift,Datum,M} = M

==(
  coords₁::EquidistantCylindrical{Hyper,Shift,Datum},
  coords₂::EquidistantCylindrical{Hyper,Shift,Datum}
) where {Hyper,Shift,Datum} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

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
const PlateCarree{Datum} = EquidistantCylindrical{EDCHyper(latₜₛ = 0.0°),Datum}

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:EquidistantCylindrical{Hyper}}, ::Type{T}) where {Hyper,T}
  ϕₜₛ = T(ustrip(deg2rad(Hyper.latₜₛ)))

  fx(λ, ϕ) = λ * cos(ϕₜₛ)

  fy(λ, ϕ) = ϕ

  fx, fy
end

function backward(::Type{<:EquidistantCylindrical{Hyper}}, x, y) where {Hyper}
  ϕₜₛ = oftype(x, ustrip(deg2rad(Hyper.latₜₛ)))

  λ = x / cos(ϕₜₛ)
  ϕ = y

  LatLon{Datum}(phi2lat(ϕ), lam2lon(λ))
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{EquidistantCylindrical{Hyper,Shift}}, coords::CRS{Datum}) where {Hyper,Shift,Datum} =
  convert(EquidistantCylindrical{Hyper,Shift,Datum}, coords)

Base.convert(::Type{EquidistantCylindrical{Hyper}}, coords::CRS) where {Hyper} =
  convert(EquidistantCylindrical{Hyper,Shift()}, coords)
