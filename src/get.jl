# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    CoordRefSystems.get(string)

Get the CRS type from the CRS `string`.
"""
get(crsstr::AbstractString) = get(string2code(crsstr))

"""
    CoordRefSystems.get(code)

Get the CRS type from the EPSG/ESRI `code`.
"""
function get(code::Type{<:CRSCode})
  throw(ArgumentError("""
  The provided code $code is not mapped to a CRS type yet. 
  Please check https://github.com/JuliaEarth/CoordRefSystems.jl/blob/main/src/get.jl
  If you know the CRS type of a given code, please submit a pull request.
  """))
end

# ----------------
# IMPLEMENTATIONS
# ----------------

get(::Type{EPSG{3395}}) = Mercator{WGS84Latest}
get(::Type{EPSG{3857}}) = WebMercator{WGS84Latest}
get(::Type{EPSG{4208}}) = LatLon{Aratu}
get(::Type{EPSG{4618}}) = LatLon{SAD69}
get(::Type{EPSG{4674}}) = LatLon{SIRGAS2000}
get(::Type{EPSG{4326}}) = LatLon{WGS84Latest}
get(::Type{EPSG{4988}}) = Cartesian{shift(ITRF{2000}, 2000.4),3}
get(::Type{EPSG{4989}}) = LatLonAlt{shift(ITRF{2000}, 2000.4)}
get(::Type{EPSG{5527}}) = LatLon{SAD96}
get(::Type{EPSG{9988}}) = Cartesian{ITRF{2020},3}
get(::Type{EPSG{10176}}) = Cartesian{IGS20,3}
get(::Type{EPSG{32633}}) = UTM{North,33,WGS84Latest}
get(::Type{EPSG{32662}}) = PlateCarree{WGS84Latest}
get(::Type{ESRI{54017}}) = Behrmann{WGS84Latest}
get(::Type{ESRI{54030}}) = Robinson{WGS84Latest}
get(::Type{ESRI{54034}}) = Lambert{WGS84Latest}
get(::Type{ESRI{54042}}) = WinkelTripel{WGS84Latest}
get(::Type{ESRI{102035}}) = Orthographic{90.0u"°",0.0u"°",true,WGS84Latest}
get(::Type{ESRI{102037}}) = Orthographic{-90.0u"°",0.0u"°",true,WGS84Latest}
