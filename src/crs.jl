# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    CRS{Datum}

Coordinate Reference System (CRS) with a given `Datum`.
"""
abstract type CRS{Datum} end

Base.isapprox(coords₁::C, coords₂::C; kwargs...) where {C<:CRS} =
  all(ntuple(i -> isapprox(getfield(coords₁, i), getfield(coords₂, i); kwargs...), nfields(coords₁)))

# ------
# DATUM
# ------

"""
    datum(coords)

Returns the datum of the coordinates `coords`.
"""
datum(coords::CRS) = datum(typeof(coords))
datum(::Type{<:CRS{Datum}}) where {Datum} = Datum

"""
    ellipsoid(coords)

Returns the ellipsoid of the coordinates `coords`.
"""
ellipsoid(coords::CRS) = ellipsoid(typeof(coords))
ellipsoid(C::Type{<:CRS}) = ellipsoid(datum(C))

"""
    latitudeₒ(coords)

Returns the latitude origin of the coordinates `coords`.
"""
latitudeₒ(coords::CRS) = latitudeₒ(typeof(coords))
latitudeₒ(C::Type{<:CRS}) = latitudeₒ(datum(C))

"""
    longitudeₒ(coords)

Returns the longitude origin of the coordinates `coords`.
"""
longitudeₒ(coords::CRS) = longitudeₒ(typeof(coords))
longitudeₒ(C::Type{<:CRS}) = longitudeₒ(datum(C))

"""
    altitudeₒ(coords)

Returns the altitude origin of the coordinates `coords`.
"""
altitudeₒ(coords::CRS) = altitudeₒ(typeof(coords))
altitudeₒ(C::Type{<:CRS}) = altitudeₒ(datum(C))

# -----------
# IO METHODS
# -----------

function Base.summary(io::IO, coords::CRS)
  name = prettyname(coords)
  Datum = datum(coords)
  print(io, "$name{$Datum} coordinates")
end

function Base.show(io::IO, coords::CRS)
  name = prettyname(coords)
  Datum = datum(coords)
  print(io, "$name{$Datum}(")
  printfields(io, coords, compact=true)
  print(io, ")")
end

function Base.show(io::IO, ::MIME"text/plain", coords::CRS)
  summary(io, coords)
  printfields(io, coords)
end

# ----------------
# IMPLEMENTATIONS
# ----------------

include("crs/basic.jl")
include("crs/geographic.jl")
include("crs/projected.jl")
