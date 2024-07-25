# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    CRS{Datum}

Coordinate Reference System (CRS) with a given `Datum`.
"""
abstract type CRS{Datum} end

"""
    CoordRefSystems.ncoords(coords)

Number of coordinates of `coords`.

See also [`ndims`](@ref).
"""
ncoords(coords::CRS) = ncoords(typeof(coords))
ncoords(C::Type{<:CRS}) = fieldcount(C)

"""
    CoordRefSystems.ndims(coords)

Number of embedding dimensions of `coords`.

See also [`ncoords`](@ref).
"""
ndims(coords::CRS) = ndims(typeof(coords))

"""
    CoordRefSystems.names(coords)

Coordinate names of `coords`.
"""
names(coords::CRS) = names(typeof(coords))
names(C::Type{<:CRS}) = fieldnames(C)

"""
    CoordRefSystems.values(coords)

Coordinate values of `coords` as a tuple.

See also [`rawvalues`](@ref).

### Notes

The order of coordinates may change depending on the
coordinate reference system. For instance, `LatLon`
values are reversed to produce the tuple `(lon, lat)`.
"""
values(coords::CRS) = ntuple(i -> getfield(coords, i), nfields(coords))

"""
    CoordRefSystems.rawvalues(coords)

Unitless coordinate values of `coords` as a tuple.

This function is equivalent to calling `ustrip` on
the `values` of `coords`.

See also [`values`](@ref), [`reconstruct`](@ref)
"""
rawvalues(coords::CRS) = ustrip.(values(coords))

"""
    CoordRefSystems.units(coords)

Units of `coords` as a tuple, in the same order
of `values` and `rawvalues`.

See also [`values`](@ref), [`rawvalues`](@ref)
"""
units(coords::CRS) = units(typeof(coords))
units(C::Type{<:CRS}) = ntuple(i -> unit(fieldtype(C, i)), fieldcount(C))

"""
    CoordRefSystems.constructor(coords)

CRS type of `coords` that can be used to construct 
a new instance or in conversions.
"""
constructor(coords::CRS) = constructor(typeof(coords))

"""
    CoordRefSystems.reconstruct(CRS, rawvalues)

Reconstruct an instance of `CRS` using `rawvalues`.

See also [`rawvalues`](@ref).
"""
function reconstruct(C::Type{<:CRS}, rawvalues)
  coords = rawvalues .* units(C)
  constructor(C)(coords...)
end

"""
    CoordRefSystems.lentype(coords)

Length unit type of `coords`.
"""
lentype(coords::CRS) = lentype(typeof(coords))

"""
    datum(coords)

Datum of the coordinates `coords`.
"""
datum(coords::CRS) = datum(typeof(coords))
datum(::Type{<:CRS{Datum}}) where {Datum} = Datum

"""
    isapprox(coords₁, coords₂; kwargs...)

Checks whether the coordinates `coords₁` and `coords₂`
are approximate using the `isapprox` function.
"""
Base.isapprox(coords₁::CRS, coords₂::CRS; kwargs...) =
  isapprox(convert(Cartesian, coords₁), convert(Cartesian, coords₂); kwargs...)

"""
    CoordRefSystems.tol(coords)

Absolute tolerance for the underlying machine type (e.g. `Float64`) used to represent the `coords`. 
The result inherits the unit of the `coords` after conversion to [`Cartesian`](@ref).
"""
tol(coords::CRS) = tol(convert(Cartesian, coords))

# -----------
# IO METHODS
# -----------

function Base.summary(io::IO, coords::CRS)
  name = prettyname(coords)
  Datum = datum(coords)
  print(io, "$name{$(rmmodule(Datum))} coordinates")
end

function Base.show(io::IO, coords::CRS)
  name = prettyname(coords)
  Datum = datum(coords)
  print(io, "$name{$(rmmodule(Datum))}(")
  printfields(io, values(coords), names(coords), compact=true)
  print(io, ")")
end

function Base.show(io::IO, ::MIME"text/plain", coords::CRS)
  summary(io, coords)
  printfields(io, values(coords), names(coords))
end

# ----------------
# IMPLEMENTATIONS
# ----------------

include("crs/basic.jl")
include("crs/geographic.jl")
include("crs/projected.jl")
