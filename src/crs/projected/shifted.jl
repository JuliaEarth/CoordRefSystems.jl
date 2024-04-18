# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    ShiftedCRS{CRS,lonₒ,xₒ,yₒ}

Shifted `CRS` with longitude origin `lonₒ` in degrees, false easting `xₒ`
and false northing `yₒ` in meters.
"""
struct ShiftedCRS{CRS,lonₒ,xₒ,yₒ,Datum} <: Projected{Datum}
  coords::CRS
end

function ShiftedCRS{CRS,lonₒ,xₒ,yₒ}(args...) where {CRS<:Projected,lonₒ,xₒ,yₒ}
  coords = CRS(args...)
  Datum = datum(coords)
  ShiftedCRS{typeof(coords),lonₒ,xₒ,yₒ,Datum}(coords)
end

_coords(coords::ShiftedCRS) = getfield(coords, :coords)

Base.propertynames(coords::ShiftedCRS) = propertynames(_coords(coords))

Base.getproperty(coords::ShiftedCRS, name::Symbol) = getproperty(_coords(coords), name)

ndims(::Type{<:ShiftedCRS{CRS}}) = ndims(CRS)

ncoords(::Type{<:ShiftedCRS{CRS}}) = ncoords(CRS)

Base.isapprox(coords₁::C, coords₂::C; kwargs...) where {C<:ShiftedCRS} =
  isapprox(_coords(coords₁), _coords(coords₂); kwargs...)

allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:ShiftedCRS} =
  allapprox(_coords(coords₁), _coords(coords₂); kwargs...)

tol(coords::ShiftedCRS) = tol(_coords(coords))

function Base.summary(io::IO, coords::ShiftedCRS{CRS,lonₒ,xₒ,yₒ}) where {CRS,lonₒ,xₒ,yₒ}
  Datum = datum(coords)
  name = prettyname(CRS)
  print(io, "Shifted$name{$Datum} coordinates with lonₒ: $lonₒ, xₒ: $xₒ, yₒ: $yₒ")
end

function Base.show(io::IO, coords::ShiftedCRS{CRS}) where {CRS}
  Datum = datum(coords)
  name = prettyname(CRS)
  print(io, "Shifted$name{$Datum}(")
  printfields(io, _coords(coords), compact=true)
  print(io, ")")
end

function Base.show(io::IO, ::MIME"text/plain", coords::ShiftedCRS)
  summary(io, coords)
  printfields(io, _coords(coords))
end

# ------------
# CONVERSIONS
# ------------

function inbounds(::Type{<:ShiftedCRS{CRS,lonₒ}}, λ, ϕ) where {CRS,lonₒ}
  λₒ = T(ustrip(deg2rad(lonₒ)))
  inbounds(CRS, λ - λₒ, ϕ)
end

function formulas(::Type{<:ShiftedCRS{CRS,lonₒ,xₒ,yₒ}}, ::Type{T}) where {CRS,lonₒ,xₒ,yₒ,T}
  a = numconvert(T, majoraxis(ellipsoid(CRS)))
  λₒ = T(ustrip(deg2rad(lonₒ)))
  x = T(xₒ / a)
  y = T(yₒ / a)

  crsfx, crsfy = formulas(CRS, T)

  fx(λ, ϕ) = crsfx(λ - λₒ, ϕ) + x

  fy(λ, ϕ) = crsfy(λ - λₒ, ϕ) + y

  fx, fy
end

function Base.convert(C::Type{<:ShiftedCRS{CRS,lonₒ,xₒ,yₒ}}, coords::LatLon{Datum}) where {CRS,lonₒ,xₒ,yₒ,Datum}
  T = numtype(coords.lon)
  x = numconvert(T, xₒ)
  y = numconvert(T, yₒ)
  lon = numconvert(T, lonₒ)
  latlon = LatLon{Datum}(coords.lat, coords.lon - lon)
  pcoords = convert(CRS, latlon)
  C(pcoords.x + x, pcoords.y + y)
end

function Base.convert(C::Type{<:LatLon}, coords::ShiftedCRS{CRS,lonₒ,xₒ,yₒ}) where {CRS,lonₒ,xₒ,yₒ}
  T = numtype(coords.x)
  x = numconvert(T, xₒ)
  y = numconvert(T, yₒ)
  lon = numconvert(T, lonₒ)
  pcoords = CRS(coords.x - x, coords.y - y)
  latlon = convert(C, pcoords)
  C(latlon.lat, latlon.lon + lon)
end
