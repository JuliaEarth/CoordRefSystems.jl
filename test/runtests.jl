using CoordRefSystems
using Unitful
using StableRNGs
using ArchGDAL
using ArchGDAL.GDAL
using Test

using CoordRefSystems: Met, Deg, Rad
using Unitful: m, mm, cm, km, rad, °, s

# environment settings
isCI = "CI" ∈ keys(ENV)
islinux = Sys.islinux()
visualtests = !isCI || (isCI && islinux)
datadir = joinpath(@__DIR__, "data")

# float settings
T = if isCI
  if ENV["FLOAT_TYPE"] == "Float32"
    Float32
  elseif ENV["FLOAT_TYPE"] == "Float64"
    Float64
  end
else
  Float64
end

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
  LambertCylindrical,
  Behrmann,
  GallPeters,
  WinkelTripel,
  Robinson,
  OrthoNorth,
  OrthoSouth,
  TransverseMercator{0.9996,0.0°},
  Albers{23.0°,29.5°,45.0°},
  Sinusoidal,
  LambertAzimuthal{15.0°},
  LambertConic{27.8333333333333°,28.3833333333333°,30.2833333333333°},
  EqualEarth
]

testfiles = [
  # ellipsoids
  "ellipsoids.jl",

  # datums
  "datums.jl",

  # crs
  "crs/api.jl",
  "crs/constructors.jl",
  "crs/conversions.jl",
  "crs/promotions.jl",
  "crs/mactype.jl",
  "crs/domains.jl",
  "crs/rand.jl",
  "crs/traits.jl",

  # EPSG/ESRI codes
  "get.jl",

  # WKT strings
  "strings.jl"
]

@testset "CoordRefSystems.jl" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end
