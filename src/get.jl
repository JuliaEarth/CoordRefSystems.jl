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
    @crscode CRS Code₁ ... Codeₙ

Define the `get(Codeᵢ) -> CRS` function mapping all codes to `CRS`,
and define the `code(CRS) -> Code₁` function using the first code.
"""
macro crscode(CRS, Codes...)
  Code₁ = first(Codes)
  getexprs = [:(get(::Type{$Code}) = $CRS) for Code in Codes]
  expr = quote
    $(getexprs...)
    code(::Type{<:$CRS}) = $Code₁
  end
  esc(expr)
end

# ----------------
# IMPLEMENTATIONS
# ----------------

@crscode shift(
  TransverseMercator{1.0000067,31.734394°,Israel1993},
  lonₒ=35.204517°,
  xₒ=219529.584m,
  yₒ=626907.39m
) EPSG{2039}
@crscode shift(TransverseMercator{0.99982,53.5°,IRENET95}, lonₒ=-8.0°, xₒ=600000.0m, yₒ=750000.0m) EPSG{2157}
@crscode shift(TransverseMercator{0.9993,0.0°,ETRF{2000}}, lonₒ=19.0°, xₒ=500000.0m, yₒ=-5300000.0m) EPSG{2180}
@crscode shift(TransverseMercator{0.9996,0.0°,NZGD2000}, lonₒ=173.0°, xₒ=1600000.0m, yₒ=10000000.0m) EPSG{2193}
@crscode shift(LambertAzimuthal{52.0°,ETRFLatest}, lonₒ=10.0°, xₒ=4321000.0m, yₒ=3210000.0m) EPSG{3035}
@crscode shift(Albers{0.0°,34.0°,40.5°,NAD83}, lonₒ=-120.0°, yₒ=-4000000.0m) EPSG{3310}
@crscode shift(Albers{50.0°,55.0°,65.0°,NAD83}, lonₒ=-154.0°) EPSG{3338}
@crscode Mercator{WGS84Latest} EPSG{3395}
@crscode WebMercator{WGS84Latest} EPSG{3857}
@crscode LatLon{RGF93v1} EPSG{4171}
@crscode LatLon{Lisbon1937} EPSG{4207}
@crscode LatLon{Aratu} EPSG{4208}
@crscode LatLon{ED50} EPSG{4230}
@crscode LatLon{ED87} EPSG{4231}
@crscode LatLon{NAD27} EPSG{4267}
@crscode LatLon{NAD83} EPSG{4269}
@crscode LatLon{Datum73} EPSG{4274}
@crscode LatLon{NTF} EPSG{4275}
@crscode LatLon{OSGB36} EPSG{4277}
@crscode LatLon{DHDN} EPSG{4314}
@crscode LatLon{WGS84Latest} EPSG{4326}
@crscode LatLon{SAD69} EPSG{4618}
@crscode LatLon{ISN93} EPSG{4659}
@crscode LatLon{Lisbon1890} EPSG{4666}
@crscode LatLon{ED79} EPSG{4668}
@crscode LatLon{SIRGAS2000} EPSG{4674}
@crscode LatLon{RD83} EPSG{4745}
@crscode LatLon{PD83} EPSG{4746}
@crscode Cartesian3D{shift(ITRF{2000}, 2000.4)} EPSG{4988}
@crscode LatLonAlt{shift(ITRF{2000}, 2000.4)} EPSG{4989}
@crscode shift(Albers{23.0°,29.5°,45.5°,NAD83}, lonₒ=-96.0°) EPSG{5070}
@crscode LatLon{ISN2004} EPSG{5324}
@crscode LatLon{SAD96} EPSG{5527}
@crscode LatLon{ISN2016} EPSG{8086}
@crscode LatLon{NAD83CSRS{1}} EPSG{8232}
@crscode LatLon{NAD83CSRS{2}} EPSG{8237}
@crscode LatLon{NAD83CSRS{3}} EPSG{8240}
@crscode LatLon{NAD83CSRS{4}} EPSG{8246}
@crscode LatLon{NAD83CSRS{5}} EPSG{8249}
@crscode LatLon{NAD83CSRS{6}} EPSG{8252}
@crscode LatLon{NAD83CSRS{7}} EPSG{8255}
@crscode LatLon{RGF93v2} EPSG{9777}
@crscode LatLon{RGF93v2b} EPSG{9782}
@crscode Cartesian3D{ITRF{2020}} EPSG{9988}
@crscode Cartesian3D{IGS20} EPSG{10176}
@crscode LatLon{NAD83CSRS{8}} EPSG{10414}
@crscode shift(TransverseMercator{0.9996,0.0°,ETRFLatest}, lonₒ=9.0°, xₒ=500000.0m, yₒ=0.0m) EPSG{25832}
@crscode shift(TransverseMercator{0.9996012717,49.0°,OSGB36}, lonₒ=-2.0°, xₒ=400000.0m, yₒ=-100000.0m) EPSG{27700}
@crscode shift(TransverseMercator{0.9996,0.0°,GDA94}, lonₒ=147.0°, xₒ=500000.0m, yₒ=10000000.0m) EPSG{28355}
@crscode shift(TransverseMercator{1.000035,53.5°,Ire65}, lonₒ=-8.0°, xₒ=200000.0m, yₒ=250000.0m) EPSG{29903}
# For EPSG:31370, the lat/lon projection parameters are given in sexagesimal DMS in the EPSG database.
# To avoid unit conversion, the literal parameters are those obtained with the PROJ command `projinfo EPSG:31370`.
@crscode shift(
  LambertConic{90.0°,51.1666672333333°,49.8333339°,BD72},
  lonₒ=4.36748666666667°,
  xₒ=150000.013m,
  yₒ=5400088.438m
) EPSG{31370}
@crscode PlateCarree{WGS84Latest} EPSG{32662}
@crscode Behrmann{WGS84Latest} ESRI{54017}
@crscode Robinson{WGS84Latest} ESRI{54030}
@crscode LambertCylindrical{WGS84Latest} ESRI{54034}
@crscode WinkelTripel{WGS84Latest} ESRI{54042}
@crscode Orthographic{SphericalMode,90°,WGS84Latest} ESRI{102035}
@crscode Orthographic{SphericalMode,-90°,WGS84Latest} ESRI{102037}

for zone in 1:60
  NorthCode = 32600 + zone
  SouthCode = 32700 + zone
  @eval @crscode utmnorth($zone, datum=WGS84Latest) EPSG{$NorthCode}
  @eval @crscode utmsouth($zone, datum=WGS84Latest) EPSG{$SouthCode}
end
