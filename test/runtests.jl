using CoordRefSystems
using Unitful
using StableRNGs
using ArchGDAL
using ArchGDAL.GDAL
using Test

using CoordRefSystems: Met, Deg, Rad
using Unitful: m, mm, cm, km, rad, °, s

include("testutils.jl")

testfiles = ["ellipsoids.jl", "datums.jl", "crs.jl", "promotion.jl", "strings.jl", "get.jl", "misc.jl"]

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
