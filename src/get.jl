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

For the inverse operation, see the [`CoordRefSystems.code`](@ref) function.
"""
function get(code::Type{<:CRSCode})
  throw(ArgumentError("""
  The provided code $code is not mapped to a CRS type yet.
  Please check https://github.com/JuliaEarth/CoordRefSystems.jl/blob/main/src/get.jl
  If you know the CRS type of a given code, please submit a pull request.
  See https://discourse.julialang.org/t/esri-code-for-british-national-grid-not-known-by-geoio/117641
  for a practical example.
  """))
end

"""
    CoordRefSystems.code(CRS)

Get the EPSG/ESRI code from the `CRS` type.

For the inverse operation, see the [`CoordRefSystems.get`](@ref) function.
"""
function code(crs::Type{<:CRS})
  throw(ArgumentError("""
  The provided CRS type `$crs` does not have an EPSG/ESRI code.
  Please check https://github.com/JuliaEarth/CoordRefSystems.jl/blob/main/src/get.jl
  """))
end

"""
    @crscode(Code, CRS)

Define both `get` and `code` functions for `Code` and `CRS`.
"""
macro crscode(Code, CRS)
  expr = quote
    get(::Type{$Code}) = $CRS
    code(::Type{<:$CRS}) = $Code
  end
  esc(expr)
end

# ----------------
# IMPLEMENTATIONS
# ----------------

@crscode EPSG{2157} shift(TransverseMercator{0.99982,53.5°,IRENET95}, lonₒ=-8.0°, xₒ=600000.0m, yₒ=750000.0m)
@crscode EPSG{3395} Mercator{WGS84Latest}
@crscode EPSG{3857} WebMercator{WGS84Latest}
@crscode EPSG{4208} LatLon{Aratu}
@crscode EPSG{4269} LatLon{NAD83}
@crscode EPSG{4326} LatLon{WGS84Latest}
@crscode EPSG{5070} shift(Albers{23.0,29.5,45.5,NAD83}, lonₒ=-96.0)
@crscode EPSG{4618} LatLon{SAD69}
@crscode EPSG{4674} LatLon{SIRGAS2000}
@crscode EPSG{4988} Cartesian3D{shift(ITRF{2000}, 2000.4)}
@crscode EPSG{4989} LatLonAlt{shift(ITRF{2000}, 2000.4)}
@crscode EPSG{5527} LatLon{SAD96}
@crscode EPSG{9988} Cartesian3D{ITRF{2020}}
@crscode EPSG{10176} Cartesian3D{IGS20}
@crscode EPSG{27700} shift(TransverseMercator{0.9996012717,49.0°,OSGB36}, lonₒ=-2.0°, xₒ=400000.0m, yₒ=-100000.0m)
@crscode EPSG{29903} shift(TransverseMercator{1.000035,53.5°,Ire65}, lonₒ=-8.0°, xₒ=200000.0m, yₒ=250000.0m)
@crscode EPSG{32662} PlateCarree{WGS84Latest}
@crscode ESRI{54017} Behrmann{WGS84Latest}
@crscode ESRI{54030} Robinson{WGS84Latest}
@crscode ESRI{54034} Lambert{WGS84Latest}
@crscode ESRI{54042} WinkelTripel{WGS84Latest}
@crscode ESRI{102035} Orthographic{SphericalMode,90°,WGS84Latest}
@crscode ESRI{102037} Orthographic{SphericalMode,-90°,WGS84Latest}

for zone in 1:60
  NorthCode = 32600 + zone
  SouthCode = 32700 + zone
  @eval @crscode EPSG{$NorthCode} utmnorth($zone, datum=WGS84Latest)
  @eval @crscode EPSG{$SouthCode} utmsouth($zone, datum=WGS84Latest)
end
