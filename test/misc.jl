@testset "Miscellaneous" begin
  # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/53
  c1 = convert(Cartesian, LatLon(0, 0))
  c2 = convert(Cartesian, LatLon(0, 90))
  c3 = Cartesian{WGS84Latest}(0m, c1.x, 0m)
  @test c2 ≈ c3
end
