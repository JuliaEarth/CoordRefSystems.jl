# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct Shifted{CRS,lonₒ,xₒ,yₒ,Datum} <: Projected{Datum}
  coords::CRS
end

function Shifted{CRS,lonₒ,xₒ,yₒ}(args...) where {CRS<:Projected,lonₒ,xₒ,yₒ}
  coords = CRS(args...)
  Datum = datum(coords)
  Shifted{typeof(coords),lonₒ,xₒ,yₒ,Datum}(coords)
end

shift(CRS::Type{<:Projected}; lonₒ=0.0u"°", xₒ=0.0u"m", yₒ=0.0u"m") = Shifted{CRS,lonₒ,xₒ,yₒ}

# ------------
# CONVERSIONS
# ------------

function inbounds(::Type{<:Shifted{CRS,lonₒ}}, λ, ϕ) where {CRS,lonₒ}
  λₒ = T(ustrip(deg2rad(lonₒ)))
  λ -= λₒ
  inbounds(CRS, λ, ϕ)
end

function formulas(::Type{<:Shifted{CRS,lonₒ,xₒ,yₒ}}, ::Type{T}) where {CRS,lonₒ,xₒ,yₒ,T}
  a = numconvert(T, majoraxis(ellipsoid(CRS)))
  λₒ = T(ustrip(deg2rad(lonₒ)))
  x = T(xₒ / a)
  y = T(yₒ / a)

  crsfx, crsfy = formulas(CRS, T)

  function fx(λ, ϕ)
    λ -= λₒ
    crsfx(λ, ϕ) + x
  end

  function fy(λ, ϕ)
    λ -= λₒ
    crsfy(λ, ϕ) + y
  end

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
  scoords = coords.coords
  T = numtype(scoords.x)
  x = numconvert(T, xₒ)
  y = numconvert(T, yₒ)
  lon = numconvert(T, lonₒ)
  pcoords = CRS(scoords.x - x, scoords.y - y)
  latlon = convert(C, pcoords)
  C(latlon.lat, latlon.lon + lon)
end
