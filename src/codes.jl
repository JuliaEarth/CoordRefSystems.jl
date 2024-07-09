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
