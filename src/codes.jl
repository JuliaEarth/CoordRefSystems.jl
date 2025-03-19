# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    CRSCode

A code used to identify a coordinate reference system.

See also [`EPSG`](@ref), [`ESRI`](@ref).
"""
abstract type CRSCode end

"""
    EPSG{code}

EPSG dataset `code` between 1024 and 32767.
Codes can be searched at [epsg.io](https://epsg.io).

See [EPSG Geodetic Parameter Dataset](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset)
"""
abstract type EPSG{Code} <: CRSCode end

"""
    ESRI{code}

ESRI dataset `code`. Codes can be searched at [epsg.io](https://epsg.io).
"""
abstract type ESRI{Code} <: CRSCode end

"""
    CoordRefSystems.code(coords)

EPSG/ESRI code of given `coords`.

For the inverse operation, see the [`CoordRefSystems.get`](@ref) function.
"""
code(coords::CRS) = code(typeof(coords))
function code(crs::Type{<:CRS})
  throw(ArgumentError("""
  The provided CRS type `$crs` does not have an EPSG/ESRI code.
  Please check https://github.com/JuliaEarth/CoordRefSystems.jl/blob/main/src/get.jl
  """))
end

"""
    CoordRefSystems.wkt2(coords)

Well-Known-Text (WKT) representation of given `coords` compliant with the
OGC WKT-CRS 2 standard: https://www.ogc.org/publications/standard/wkt-crs
"""
wkt2(coords::CRS) = wkt2(typeof(coords))
wkt2(C::Type{<:CRS}) = wkt2(code(C))

function wkt2(::Type{EPSG{Code}}) where {Code}
  filepath = joinpath(datadep"epsg-wkt2", "EPSG-CRS-$(Code).wkt")
  if !isfile(filepath)
    throw(ArgumentError(
    """
    EPSG:$(Code) not found. This EPSG code may be deprecated.
    Supported and deprecated codes can be checked at epsg.io.
    Please reproject the data to a CRS supported 
    by the latest release of the EPSG dataset.
    """))
  end
  read(filepath, String)
end

function wkt2(::Type{ESRI{Code}}) where {Code}
  throw(ArgumentError(
  """
  WKT2 string is not defined for ESRI:$Code code.
  If you are attempting to save data to disk, please
  reproject the data to a CRS supported by the OGC
  standard.
  """))
end
