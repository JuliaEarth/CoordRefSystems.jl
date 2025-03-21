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

function wkt2(::Type{EPSG{Code}}) where {Code}
  epsg = joinpath(pkgdir(@__MODULE__), "artifacts", "epsg-wkt2")
  file = joinpath(epsg, "EPSG-CRS-$Code.wkt")
  if !isfile(file)
    throw(
      ArgumentError(
        """
        EPSG:$Code not found. This EPSG code may be deprecated.
        Supported and deprecated codes can be checked at https://epsg.io.
        Please reproject the data to a CRS supported by the latest release
        of the EPSG dataset: https://github.com/JuliaEarth/CoordRefSystems.jl/tree/main/artifacts/epsg-wkt2
        """
      )
    )
  end
  read(file, String)
end

function wkt2(::Type{ESRI{Code}}) where {Code}
  throw(ArgumentError("""
                      OGC WKT-CRS version 2 does not support ESRI:$Code.
                      Please reproject the data to a CRS with EPSG code:
                      https://github.com/JuliaEarth/CoordRefSystems.jl/blob/main/src/get.jl
                      """))
end
