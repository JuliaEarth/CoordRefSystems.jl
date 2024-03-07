using Cartography
using Unitful
using Test

isnum(x) = !isnan(x) && !isinf(x)

testfiles = ["ellipsoids.jl", "datums.jl", "crs.jl", "codes.jl"]

# --------------------------------
# RUN TESTS WITH SINGLE PRECISION
# --------------------------------

T = Float32
@testset "Cartography.jl ($T)" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end

# --------------------------------
# RUN TESTS WITH DOUBLE PRECISION
# --------------------------------

T = Float64
@testset "Cartography.jl ($T)" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end
