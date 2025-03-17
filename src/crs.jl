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

Converts `coords₁` and `coords₂` to `Cartesian` coordinates and compare the coordinate
values with the `isapprox` method of vectors. The conversion to `Cartesian` coordinates
takes care of possibly different `Datum`.
"""
Base.isapprox(coords₁::CRS, coords₂::CRS; kwargs...) =
  isapprox(convert(Cartesian, coords₁), convert(Cartesian, coords₂); kwargs...)

"""
    CoordRefSystems.tol(coords)

Absolute tolerance for the underlying machine type (e.g. `Float64`) used to represent the `coords`. 
The result inherits the unit of the `coords` after conversion to [`Cartesian`](@ref).
"""
tol(coords::CRS) = tol(convert(Cartesian, coords))


"""
    CoordRefSystems.wkt(crs)

Get the WKT2 `string` representation from a CRS object.
"""
wkt(coords::CRS) = wkt(typeof(coords))

wkt(C::Type{<:CRS}) = wkt(code(C))

function wkt(code::Type{EPSG{I}}) where I
  filename = "EPSG-CRS-$(I).wkt"
  filepath = joinpath(datadep"epsg-wkt2", filename)
  if !isfile(filepath)
    throw(ArgumentError("A WKT string for EPSG:$I was not found in the EPSG dataset."))
  end
  return read(filepath, String)
end

function epsgregistration()
  epsg_dataset_metadata = DataDep(
    "epsg-wkt2",
    """
    EPSG dataset providing coordinate reference system definitions in WKT 2 format.
    For terms of use and more information, see https://epsg.org/terms-of-use.html
    """,
    # TODO: update the URL to JuliaEarth hosted version
    "https://github.com/Omar-Elrefaei/epsg-dataset/raw/refs/heads/main/EPSG-latest-WKT.Zip",
    Any,
    # unpack the tarball
    post_fetch_method=unpack
)
  register(epsg_dataset_metadata)
end


# -------------
# RAND METHODS
# -------------

Random.rand(::Type{C}) where {C<:CRS} = rand(Random.default_rng(), C)

Random.rand(::Type{C}, n::Int) where {C<:CRS} = rand(Random.default_rng(), C, n)

Random.rand(rng::Random.AbstractRNG, ::Type{C}, n::Int) where {C<:CRS} = [rand(rng, C) for _ in 1:n]

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
