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
  TransverseMercator{T(0.9996),T(0.0)°},
  Albers{T(23.0)°,T(29.5)°,T(45.0)°},
  Sinusoidal,
  LambertAzimuthal{T(15.0)°},
  LambertConic{T(27.8333333333333)°,T(28.3833333333333)°,T(30.2833333333333)°},
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
  "crs/fwdbwd.jl",
  "crs/rand.jl",
  "crs/traits.jl",

  # EPSG/ESRI codes
  "codes.jl",
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
