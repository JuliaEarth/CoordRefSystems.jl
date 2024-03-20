# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct Shifted{CRS,lonₒ,xₒ,yₒ,Datum} <: Projected{Datum}
  coords::CRS
end

_coords(coords::Shifted) = getfield(coords, :coords)

Base.propertynames(coords::Shifted) = propertynames(_coords(coords))

Base.getproperty(coords::Shifted, name::Symbol) = getproperty(_coords(coords), name)

Base.isapprox(coords₁::C, coords₂::C; kwargs...) where {C<:Shifted} =
  isapprox(_coords(coords₁), _coords(coords₂); kwargs...)

function Shifted{CRS,lonₒ,xₒ,yₒ}(args...) where {CRS<:Projected,lonₒ,xₒ,yₒ}
  coords = CRS(args...)
  Datum = datum(coords)
  Shifted{typeof(coords),lonₒ,xₒ,yₒ,Datum}(coords)
end

"""
    shift(CRS::Type{<:Projected}; lonₒ=0.0u"°", xₒ=0.0u"m", yₒ=0.0u"m")

Shifts the `CRS` by longitude origin `lonₒ` in degrees, false easting `xₒ`
and false northing `yₒ` in meters.
"""
shift(CRS::Type{<:Projected}; lonₒ=0.0u"°", xₒ=0.0u"m", yₒ=0.0u"m") = Shifted{CRS,lonₒ,xₒ,yₒ}

# ------------
# CONVERSIONS
# ------------

function inbounds(::Type{<:Shifted{CRS,lonₒ}}, λ, ϕ) where {CRS,lonₒ}
  λₒ = T(ustrip(deg2rad(lonₒ)))
  inbounds(CRS, λ - λₒ, ϕ)
end

function formulas(::Type{<:Shifted{CRS,lonₒ,xₒ,yₒ}}, ::Type{T}) where {CRS,lonₒ,xₒ,yₒ,T}
  a = numconvert(T, majoraxis(ellipsoid(CRS)))
  λₒ = T(ustrip(deg2rad(lonₒ)))
  x = T(xₒ / a)
  y = T(yₒ / a)

  crsfx, crsfy = formulas(CRS, T)

  fx(λ, ϕ) = crsfx(λ - λₒ, ϕ) + x

  fy(λ, ϕ) = crsfy(λ - λₒ, ϕ) + y

  fx, fy
end

function Base.convert(C::Type{<:Shifted{CRS,lonₒ,xₒ,yₒ}}, coords::LatLon{Datum}) where {CRS,lonₒ,xₒ,yₒ,Datum}
  T = numtype(coords.lon)
  x = numconvert(T, xₒ)
  y = numconvert(T, yₒ)
  lon = numconvert(T, lonₒ)
  latlon = LatLon{Datum}(coords.lat, coords.lon - lon)
  pcoords = convert(CRS, latlon)
  C(pcoords.x + x, pcoords.y + y)
end

function Base.convert(C::Type{<:LatLon}, coords::Shifted{CRS,lonₒ,xₒ,yₒ}) where {CRS,lonₒ,xₒ,yₒ}
  T = numtype(coords.x)
  x = numconvert(T, xₒ)
  y = numconvert(T, yₒ)
  lon = numconvert(T, lonₒ)
  pcoords = CRS(coords.x - x, coords.y - y)
  latlon = convert(C, pcoords)
  C(latlon.lat, latlon.lon + lon)
end
