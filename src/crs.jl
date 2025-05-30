# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    CRS{Datum}

Coordinate Reference System (CRS) with a given `Datum`.
"""
abstract type CRS{Datum} end

"""
    datum(coords)

Datum of the coordinates `coords`.
"""
datum(coords::CRS) = datum(typeof(coords))
datum(::Type{<:CRS{Datum}}) where {Datum} = Datum

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

See also [`raw`](@ref).
"""
values(coords::CRS) = ntuple(i -> getfield(coords, i), nfields(coords))

"""
    CoordRefSystems.raw(coords)

Unitless coordinate values of `coords` as a tuple.

See also [`reconstruct`](@ref).

### Notes

The order of coordinate values may change depending
on the coordinate reference system. For instance,
`LatLon` values are reversed to produce the tuple
`(lon, lat)`.
"""
raw(coords::CRS) = ustrip.(values(coords))

"""
    CoordRefSystems.units(coords)

Units of `coords` as a tuple, in the same order
of `raw` values.

See also [`reconstruct`](@ref).
"""
units(coords::CRS) = units(typeof(coords))
units(C::Type{<:CRS}) = ntuple(i -> unit(fieldtype(C, i)), fieldcount(C))

"""
    CoordRefSystems.constructor(coords)

CRS type of `coords` that can be used to construct 
a new instance or in conversions.

See also [`reconstruct`](@ref)
"""
constructor(coords::CRS) = constructor(typeof(coords))

"""
    CoordRefSystems.reconstruct(CRS, raw)

Reconstruct an instance of `CRS` using `raw` values.

See also [`raw`](@ref), [`units`](@ref), [`constructor`](@ref).
"""
function reconstruct(C::Type{<:CRS}, raw)
  coords = raw .* units(C)
  constructor(C)(coords...)
end

"""
    CoordRefSystems.lentype(coords)

Length unit type of `coords`.
"""
lentype(coords::CRS) = lentype(typeof(coords))

"""
    CoordRefSystems.mactype(coords)

Machine type type of `coords`.
"""
mactype(coords::CRS) = mactype(typeof(coords))
mactype(C::Type{<:CRS}) = numtype(lentype(C))

"""
    isapprox(coords₁, coords₂; kwargs...)

Checks whether or not `coords₁` and `coords₂` are approximately equal as
if they were tuples, i.e., their coordinate values are compared one by one
with `isapprox` and the forwarded `kwargs`.

In the case of different CRS types, converts `coords₂` to the `typeof(coords₁)`,
handling possibly different datums, units and machine types.
"""
Base.isapprox(coords₁::CRS, coords₂::CRS; kwargs...) = isapprox(coords₁, convert(typeof(coords₁), coords₂); kwargs...)

Base.isapprox(coords₁::C, coords₂::C; kwargs...) where {C<:CRS} =
  all(ntuple(i -> isapprox(getfield(coords₁, i), getfield(coords₂, i); kwargs...), nfields(coords₁)))

# -------------
# RAND METHODS
# -------------

Random.rand(::Type{C}) where {C<:CRS} = rand(Random.default_rng(), C)

Random.rand(::Type{C}, n::Int) where {C<:CRS} = rand(Random.default_rng(), C, n)

Random.rand(rng::Random.AbstractRNG, ::Type{C}, n::Int) where {C<:CRS} = [rand(rng, C) for _ in 1:n]

# ----------------------------
# EPSG/ESRI CODES AND STRINGS
# ----------------------------

"""
    CoordRefSystems.code(CRS)

EPSG/ESRI code of given `CRS`.

For the inverse operation, see the [`CoordRefSystems.get`](@ref) function.
"""
function code(crs::Type{<:CRS})
  throw(ArgumentError("""
  The provided CRS type `$crs` does not have an EPSG/ESRI code.
  Please check https://github.com/JuliaEarth/CoordRefSystems.jl/blob/main/src/get.jl
  """))
end

"""
    CoordRefSystems.wkt2(CRS)

Well-Known-Text (WKT) representation of given `CRS` compliant with the
OGC WKT-CRS 2 standard: https://www.ogc.org/publications/standard/wkt-crs
"""
wkt2(C::Type{<:CRS}) = wkt2(code(C))

# ----------
# FALLBACKS
# ----------

function Base.convert(::Type{C}, coords::CRS) where {C<:CRS}
  # nothing to do if C has the same abstract type and datum
  C === constructor(coords) && return coords

  # C must be a concrete type with a conversion method defined
  isconcretetype(C) || throw(ArgumentError("conversion from `$(typeof(coords))` to `$C` is not defined"))

  # call the appropriate method to convert coords to C
  # preserving the machine type, units, ...
  coords′ = convert(constructor(C), coords)

  # convert machine type, units, ...
  convert(C, coords′)
end

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
