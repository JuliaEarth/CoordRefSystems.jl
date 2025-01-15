using CoordRefSystems
using Unitful
using StableRNGs
using ArchGDAL
using ArchGDAL.GDAL
using Test

using CoordRefSystems: Met, Deg, Rad
using Unitful: m, mm, cm, km, rad, °, s

include("testutils.jl")

basic2D = [Cartesian2D, Polar]
basic3D = [Cartesian3D, Cylindrical, Spherical]
basic = [basic2D; basic3D]
geographic2D = [LatLon, GeocentricLatLon, AuthalicLatLon]
geographic3D = [LatLonAlt, GeocentricLatLonAlt]
geographic = [geographic2D; geographic3D]
projected = [
  Mercator,
  WebMercator,
  PlateCarree,
  Lambert,
  Behrmann,
  GallPeters,
  WinkelTripel,
  Robinson,
  OrthoNorth,
  OrthoSouth,
  TransverseMercator{0.9996,0.0°},
  Albers{23.0°,29.5°,45.0°},
  Sinusoidal,
  LambertAzimuthalEqualArea{15.0°},
  EqualEarth,
  PolarStereographicB{-71°,0°,WGS84Latest}
]

testfiles = ["ellipsoids.jl", "datums.jl", "crs.jl", "strings.jl", "get.jl", "misc.jl"]

# --------------------------------
# RUN TESTS WITH SINGLE PRECISION
# --------------------------------

T = Float32
@testset "CoordRefSystems.jl ($T)" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end

# --------------------------------
# RUN TESTS WITH DOUBLE PRECISION
# --------------------------------

T = Float64
@testset "CoordRefSystems.jl ($T)" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end
