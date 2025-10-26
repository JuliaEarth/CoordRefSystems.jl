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
    @crscodes CRS Code₁ Code₂ ... Codeₙ

Internal macro to map the codes `Code₁`, `Code₂`, ..., `Codeₙ` to
the `CRS` type, and the `CRS` type to the first code, i.e. `Code₁`.
"""
macro crscodes(CRS, Codes...)
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
# using the projinfo utility that is shipped with PROJ:
#
# shell> projinfo EPSG:5070
#
# If the sign of some parameter differs, for example lon_0=8
# in the EPSG database and lon_0=-8 in the projinfo output,
# please use the projinfo output.
#
# If the angle parameters are given in sexagesimal DMS in
# the EPSG database, please use the projinfo output.

@crscodes shift(
  TransverseMercator{1.0000067,31.734394°,Israel1993},
  lonₒ=35.204517°,
  xₒ=219529.584m,
  yₒ=626907.39m
) EPSG{2039}
@crscodes shift(TransverseMercator{0.99982,53.5°,IRENET95}, lonₒ=-8.0°, xₒ=600000.0m, yₒ=750000.0m) EPSG{2157}
@crscodes shift(TransverseMercator{0.9993,0.0°,ETRF{2000}}, lonₒ=19.0°, xₒ=500000.0m, yₒ=-5300000.0m) EPSG{2180}
@crscodes shift(TransverseMercator{0.9996,0.0°,NZGD2000}, lonₒ=173.0°, xₒ=1600000.0m, yₒ=10000000.0m) EPSG{2193}
@crscodes shift(LambertAzimuthal{52.0°,ETRFLatest}, lonₒ=10.0°, xₒ=4321000.0m, yₒ=3210000.0m) EPSG{3035}
@crscodes shift(Albers{0.0°,34.0°,40.5°,NAD83}, lonₒ=-120.0°, yₒ=-4000000.0m) EPSG{3310}
@crscodes shift(Albers{50.0°,55.0°,65.0°,NAD83}, lonₒ=-154.0°) EPSG{3338}
@crscodes Mercator{WGS84Latest} EPSG{3395}
@crscodes WebMercator{WGS84Latest} EPSG{3857}
@crscodes LatLon{RGF93v1} EPSG{4171}
@crscodes LatLon{Lisbon1937} EPSG{4207}
@crscodes LatLon{Aratu} EPSG{4208}
@crscodes LatLon{ED50} EPSG{4230}
@crscodes LatLon{ED87} EPSG{4231}
@crscodes LatLon{NAD27} EPSG{4267}
@crscodes LatLon{NAD83} EPSG{4269}
@crscodes LatLon{Datum73} EPSG{4274}
@crscodes LatLon{NTF} EPSG{4275}
@crscodes LatLon{OSGB36} EPSG{4277}
@crscodes LatLon{DHDN} EPSG{4314}
@crscodes LatLon{WGS84Latest} EPSG{4326}
@crscodes LatLon{SAD69} EPSG{4618}
@crscodes LatLon{ISN93} EPSG{4659}
@crscodes LatLon{Lisbon1890} EPSG{4666}
@crscodes LatLon{ED79} EPSG{4668}
@crscodes LatLon{SIRGAS2000} EPSG{4674}
@crscodes LatLon{RD83} EPSG{4745}
@crscodes LatLon{PD83} EPSG{4746}
@crscodes Cartesian3D{shift(ITRF{2000}, 2000.4)} EPSG{4988}
@crscodes LatLonAlt{shift(ITRF{2000}, 2000.4)} EPSG{4989}
@crscodes shift(Albers{23.0°,29.5°,45.5°,NAD83}, lonₒ=-96.0°) EPSG{5070}
@crscodes LatLon{ISN2004} EPSG{5324}
@crscodes LatLon{SAD96} EPSG{5527}
@crscodes LatLon{ISN2016} EPSG{8086}
@crscodes LatLon{NAD83CSRS{1}} EPSG{8232}
@crscodes LatLon{NAD83CSRS{2}} EPSG{8237}
@crscodes LatLon{NAD83CSRS{3}} EPSG{8240}
@crscodes LatLon{NAD83CSRS{4}} EPSG{8246}
@crscodes LatLon{NAD83CSRS{5}} EPSG{8249}
@crscodes LatLon{NAD83CSRS{6}} EPSG{8252}
@crscodes LatLon{NAD83CSRS{7}} EPSG{8255}
@crscodes LatLon{RGF93v2} EPSG{9777}
@crscodes LatLon{RGF93v2b} EPSG{9782}
@crscodes Cartesian3D{ITRF{2020}} EPSG{9988}
@crscodes Cartesian3D{IGS20} EPSG{10176}
@crscodes LatLon{NAD83CSRS{8}} EPSG{10414}
@crscodes shift(TransverseMercator{0.9996,0.0°,ETRFLatest}, lonₒ=9.0°, xₒ=500000.0m, yₒ=0.0m) EPSG{25832}
@crscodes shift(TransverseMercator{0.9996012717,49.0°,OSGB36}, lonₒ=-2.0°, xₒ=400000.0m, yₒ=-100000.0m) EPSG{27700}
@crscodes shift(TransverseMercator{0.9996,0.0°,GDA94}, lonₒ=147.0°, xₒ=500000.0m, yₒ=10000000.0m) EPSG{28355}
@crscodes shift(
  TransverseMercator{1.000035,53.5°,Ire65},
  lonₒ=-8.0°,
  xₒ=200000.0m,
  yₒ=250000.0m
) EPSG{29902} EPSG{29903}
@crscodes shift(
  LambertConic{90.0°,51.1666672333333°,49.8333339°,BD72},
  lonₒ=4.36748666666667°,
  xₒ=150000.013m,
  yₒ=5400088.438m
) EPSG{31370}
@crscodes PlateCarree{WGS84Latest} EPSG{32662}
@crscodes Behrmann{WGS84Latest} ESRI{54017}
@crscodes Robinson{WGS84Latest} ESRI{54030}
@crscodes LambertCylindrical{WGS84Latest} ESRI{54034}
@crscodes WinkelTripel{WGS84Latest} ESRI{54042}
@crscodes Orthographic{SphericalMode,90°,WGS84Latest} ESRI{102035}
@crscodes Orthographic{SphericalMode,-90°,WGS84Latest} ESRI{102037}

for zone in 1:60
  NorthCode = 32600 + zone
  SouthCode = 32700 + zone
  @eval @crscodes utmnorth($zone, datum=WGS84Latest) EPSG{$NorthCode}
  @eval @crscodes utmsouth($zone, datum=WGS84Latest) EPSG{$SouthCode}
end

for zone in 11:22
  NorthCode = 31954 + zone
  @eval @crscodes utmnorth($zone, datum=SIRGAS2000) EPSG{$NorthCode}
end

for zone in 17:25
  SouthCode = 31960 + zone
  @eval @crscodes utmsouth($zone, datum=SIRGAS2000) EPSG{$SouthCode}
end

@crscodes utmnorth(23, datum=SIRGAS2000) EPSG{6210}
@crscodes utmnorth(24, datum=SIRGAS2000) EPSG{6211}
@crscodes utmsouth(26, datum=SIRGAS2000) EPSG{5396}
