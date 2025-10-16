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

# To map a EPSG{code} to a CRS type, please go to
# https://epsg.org/search/by-name and type the code
# in the search box.
#
# Check the CRSs tab of the result and click on the
# desired entry in the table. You will be redirected
# to a page with clickable items.
#
# You need to find the ellipsoid inside the datum item
# and the conversion parameters of the projection in case
# of projected coordinates.
#
# Double check the parameters stored in the EPSG database
# using the `projinfo` utility that is shipped with PROJ:
#
# shell> projinfo EPSG:5070
#
# If the sign of some parameter differs, for example lon_0=8
# in the EPSG database and lon_0=-8 in the projinfo output,
# please use the projinfo output.

@crscode EPSG{2039} shift(
  TransverseMercator{1.0000067,31.734394°,Israel1993},
  lonₒ=35.204517°,
  xₒ=219529.584m,
  yₒ=626907.39m
)
@crscode EPSG{2157} shift(TransverseMercator{0.99982,53.5°,IRENET95}, lonₒ=-8.0°, xₒ=600000.0m, yₒ=750000.0m)
@crscode EPSG{2180} shift(TransverseMercator{0.9993,0.0°,ETRF{2000}}, lonₒ=19.0°, xₒ=500000.0m, yₒ=-5300000.0m)
@crscode EPSG{2193} shift(TransverseMercator{0.9996,0.0°,NZGD2000}, lonₒ=173.0°, xₒ=1600000.0m, yₒ=10000000.0m)
@crscode EPSG{3035} shift(LambertAzimuthal{52.0°,ETRFLatest}, lonₒ=10.0°, xₒ=4321000.0m, yₒ=3210000.0m)
@crscode EPSG{3310} shift(Albers{0.0°,34.0°,40.5°,NAD83}, lonₒ=-120.0°, yₒ=-4000000.0m)
@crscode EPSG{3338} shift(Albers{50.0°,55.0°,65.0°,NAD83}, lonₒ=-154.0°)
@crscode EPSG{3395} Mercator{WGS84Latest}
@crscode EPSG{3857} WebMercator{WGS84Latest}
@crscode EPSG{4171} LatLon{RGF93v1}
@crscode EPSG{4207} LatLon{Lisbon1937}
@crscode EPSG{4208} LatLon{Aratu}
@crscode EPSG{4230} LatLon{ED50}
@crscode EPSG{4231} LatLon{ED87}
@crscode EPSG{4267} LatLon{NAD27}
@crscode EPSG{4269} LatLon{NAD83}
@crscode EPSG{4274} LatLon{Datum73}
@crscode EPSG{4275} LatLon{NTF}
@crscode EPSG{4277} LatLon{OSGB36}
@crscode EPSG{4314} LatLon{DHDN}
@crscode EPSG{4326} LatLon{WGS84Latest}
@crscode EPSG{4618} LatLon{SAD69}
@crscode EPSG{4659} LatLon{ISN93}
@crscode EPSG{4666} LatLon{Lisbon1890}
@crscode EPSG{4668} LatLon{ED79}
@crscode EPSG{4674} LatLon{SIRGAS2000}
@crscode EPSG{4745} LatLon{RD83}
@crscode EPSG{4746} LatLon{PD83}
@crscode EPSG{4988} Cartesian3D{shift(ITRF{2000}, 2000.4)}
@crscode EPSG{4989} LatLonAlt{shift(ITRF{2000}, 2000.4)}
@crscode EPSG{5070} shift(Albers{23.0°,29.5°,45.5°,NAD83}, lonₒ=-96.0°)
@crscode EPSG{5324} LatLon{ISN2004}
@crscode EPSG{5527} LatLon{SAD96}
@crscode EPSG{8086} LatLon{ISN2016}
@crscode EPSG{8232} LatLon{NAD83CSRS{1}}
@crscode EPSG{8237} LatLon{NAD83CSRS{2}}
@crscode EPSG{8240} LatLon{NAD83CSRS{3}}
@crscode EPSG{8246} LatLon{NAD83CSRS{4}}
@crscode EPSG{8249} LatLon{NAD83CSRS{5}}
@crscode EPSG{8252} LatLon{NAD83CSRS{6}}
@crscode EPSG{8255} LatLon{NAD83CSRS{7}}
@crscode EPSG{9777} LatLon{RGF93v2}
@crscode EPSG{9782} LatLon{RGF93v2b}
@crscode EPSG{9988} Cartesian3D{ITRF{2020}}
@crscode EPSG{10176} Cartesian3D{IGS20}
@crscode EPSG{10414} LatLon{NAD83CSRS{8}}
@crscode EPSG{25832} shift(TransverseMercator{0.9996,0.0°,ETRFLatest}, lonₒ=9.0°, xₒ=500000.0m, yₒ=0.0m)
@crscode EPSG{27700} shift(TransverseMercator{0.9996012717,49.0°,OSGB36}, lonₒ=-2.0°, xₒ=400000.0m, yₒ=-100000.0m)
@crscode EPSG{28355} shift(TransverseMercator{0.9996,0.0°,GDA94}, lonₒ=147.0°, xₒ=500000.0m, yₒ=10000000.0m)
# For EPSG:29902, the lat/lon projection parameters are given in sexagesimal DMS in the EPSG database.
# To avoid unit conversion, the literal parameters are those obtained with the PROJ command `projinfo EPSG:29902`.
@crscode EPSG{29902} shift(TransverseMercator{1.000035,53.5°,Ire65}, lonₒ=-8.0°, xₒ=200000.0m, yₒ=250000.0m)
# For EPSG:29903, the lat/lon projection parameters are given in sexagesimal DMS in the EPSG database.
# To avoid unit conversion, the literal parameters are those obtained with the PROJ command `projinfo EPSG:29903`.
@crscode EPSG{29903} shift(TransverseMercator{1.000035,53.5°,Ire65}, lonₒ=-8.0°, xₒ=200000.0m, yₒ=250000.0m)
# For EPSG:31370, the lat/lon projection parameters are given in sexagesimal DMS in the EPSG database.
# To avoid unit conversion, the literal parameters are those obtained with the PROJ command `projinfo EPSG:31370`.
@crscode EPSG{31370} shift(
  LambertConic{90.0°,51.1666672333333°,49.8333339°,BD72},
  lonₒ=4.36748666666667°,
  xₒ=150000.013m,
  yₒ=5400088.438m
)
@crscode EPSG{32662} PlateCarree{WGS84Latest}
@crscode ESRI{54017} Behrmann{WGS84Latest}
@crscode ESRI{54030} Robinson{WGS84Latest}
@crscode ESRI{54034} LambertCylindrical{WGS84Latest}
@crscode ESRI{54042} WinkelTripel{WGS84Latest}
@crscode ESRI{102035} Orthographic{SphericalMode,90°,WGS84Latest}
@crscode ESRI{102037} Orthographic{SphericalMode,-90°,WGS84Latest}

for zone in 1:60
  NorthCode = 32600 + zone
  SouthCode = 32700 + zone
  @eval @crscode EPSG{$NorthCode} utmnorth($zone, datum=WGS84Latest)
  @eval @crscode EPSG{$SouthCode} utmsouth($zone, datum=WGS84Latest)
end
