using CoordRefSystems
using Unitful
using StableRNGs
using Test

using CoordRefSystems: Met, Deg, Rad

function isapproxtest2D(CRS)
  c1 = convert(CRS, Cartesian{WGS84Latest}(T(1), T(1)))

  τ = CoordRefSystems.atol(Float64) * u"m"
  c2 = convert(CRS, Cartesian{WGS84Latest}(1u"m" + τ, 1u"m"))
  c3 = convert(CRS, Cartesian{WGS84Latest}(1u"m", 1u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3

  τ = CoordRefSystems.atol(Float32) * u"m"
  c2 = convert(CRS, Cartesian{WGS84Latest}(1u"m" + τ, 1u"m"))
  c3 = convert(CRS, Cartesian{WGS84Latest}(1u"m", 1u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
end

function isapproxtest3D(CRS)
  c1 = convert(CRS, Cartesian{WGS84Latest}(T(3.2e6), T(3.2e6), T(4.5e6)))

  τ = CoordRefSystems.atol(Float64) * u"m"
  c2 = convert(CRS, Cartesian{WGS84Latest}(3.2e6u"m" + τ, 3.2e6u"m", 4.5e6u"m"))
  c3 = convert(CRS, Cartesian{WGS84Latest}(3.2e6u"m", 3.2e6u"m" + τ, 4.5e6u"m"))
  c4 = convert(CRS, Cartesian{WGS84Latest}(3.2e6u"m", 3.2e6u"m", 4.5e6u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  τ = CoordRefSystems.atol(Float32) * u"m"
  c2 = convert(CRS, Cartesian{WGS84Latest}(3.2f6u"m" + τ, 3.2f6u"m", 4.5f6u"m"))
  c3 = convert(CRS, Cartesian{WGS84Latest}(3.2f6u"m", 3.2f6u"m" + τ, 4.5f6u"m"))
  c4 = convert(CRS, Cartesian{WGS84Latest}(3.2f6u"m", 3.2f6u"m", 4.5f6u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  τ = CoordRefSystems.atol(T) * u"m"
  c1 = convert(CRS, Cartesian{ITRF{2008}}(T(3.2e6), T(3.2e6), T(4.5e6)))
  c2 = convert(CRS, Cartesian{WGS84Latest}(T(3.2e6), T(3.2e6), T(4.5e6)))
  @test c1 ≈ c2
end

testfiles = ["ellipsoids.jl", "datums.jl", "crs.jl", "codes.jl", "misc.jl"]

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
