# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Orthographic{lat₀,lon₀,S,Datum}

Orthographic CRS with latitude origin `lat₀` and longitude origin `lon₀` in degrees,
spherical mode `S` enabled or not and a given `Datum`.
"""
struct Orthographic{lat₀,lon₀,S,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
  Orthographic{lat₀,lon₀,S,Datum}(x::M, y::M) where {lat₀,lon₀,S,Datum,M<:Met} = new{lat₀,lon₀,S,Datum,float(M)}(x, y)
end

Orthographic{lat₀,lon₀,S,Datum}(x::Met, y::Met) where {lat₀,lon₀,S,Datum} =
  Orthographic{lat₀,lon₀,S,Datum}(promote(x, y)...)
Orthographic{lat₀,lon₀,S,Datum}(x::Len, y::Len) where {lat₀,lon₀,S,Datum} =
  Orthographic{lat₀,lon₀,S,Datum}(uconvert(u"m", x), uconvert(u"m", y))
Orthographic{lat₀,lon₀,S,Datum}(x::Number, y::Number) where {lat₀,lon₀,S,Datum} =
  Orthographic{lat₀,lon₀,S,Datum}(addunit(x, u"m"), addunit(y, u"m"))

Orthographic{lat₀,lon₀,S}(args...) where {lat₀,lon₀,S} = Orthographic{lat₀,lon₀,S,WGS84}(args...)

"""
    OrthoNorth(x, y)
    OrthoNorth{Datum}(x, y)

Orthographic North Pole coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
OrthoNorth(1, 1) # add default units
OrthoNorth(1u"m", 1u"m") # integers are converted converted to floats
OrthoNorth(1.0u"km", 1.0u"km") # length quantities are converted to meters
OrthoNorth(1.0u"m", 1.0u"m")
OrthoNorth{WGS84}(1.0u"m", 1.0u"m")
```
"""
const OrthoNorth{Datum} = Orthographic{90.0u"°",0.0u"°",false,Datum}

"""
    OrthoSouth(x, y)
    OrthoSouth{Datum}(x, y)

Orthographic South Pole coordinates in length units (default to meter)
with a given `Datum` (default to `WGS84`).

## Examples

```julia
OrthoSouth(1, 1) # add default units
OrthoSouth(1u"m", 1u"m") # integers are converted converted to floats
OrthoSouth(1.0u"km", 1.0u"km") # length quantities are converted to meters
OrthoSouth(1.0u"m", 1.0u"m")
OrthoSouth{WGS84}(1.0u"m", 1.0u"m")
```
"""
const OrthoSouth{Datum} = Orthographic{-90.0u"°",0.0u"°",false,Datum}

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:Orthographic{lat₀,lon₀,false,Datum}}, ::Type{T}) where {lat₀,lon₀,Datum,T}
  λ₀ = T(ustrip(deg2rad(lon₀)))
  ϕ₀ = T(ustrip(deg2rad(lat₀)))
  e² = T(eccentricity²(ellipsoid(Datum)))

  sinϕ₀ = sin(ϕ₀)
  cosϕ₀ = cos(ϕ₀)
  ν(ϕ) = 1 / sqrt(1 - e² * sin(ϕ)^2)
  ν₀ = ν(ϕ₀)

  fx(λ, ϕ) = ν(ϕ) * cos(ϕ) * sin(λ - λ₀)

  function fy(λ, ϕ)
    νϕ = ν(ϕ)
    sinϕ = sin(ϕ)
    cosϕ = cos(ϕ)
    νϕ * (sinϕ * cosϕ₀ - cosϕ * sinϕ₀ * cos(λ - λ₀)) + e² * (ν₀ * sinϕ₀ - νϕ * sinϕ) * cosϕ₀
  end

  fx, fy
end

function formulas(::Type{<:Orthographic{lat₀,lon₀,true,Datum}}, ::Type{T}) where {lat₀,lon₀,Datum,T}
  λ₀ = T(ustrip(deg2rad(lon₀)))
  ϕ₀ = T(ustrip(deg2rad(lat₀)))

  fx(λ, ϕ) = cos(ϕ) * sin(λ - λ₀)

  fy(λ, ϕ) = sin(ϕ) * cos(ϕ₀) - cos(ϕ) * sin(ϕ₀) * cos(λ - λ₀)

  fx, fy
end
