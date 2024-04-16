@testset "atol" begin
  c = Cartesian(T(1), T(1))
  atol = CoordRefSystems.atol(T(1) * u"m")
  @test CoordRefSystems.atol(c) == atol
  c = Polar(T(1), 1f0)
  @test CoordRefSystems.atol(c) == atol
  c = LatLon(T(1), T(1))
  @test CoordRefSystems.atol(c) == atol
  ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
  c = ShiftedMercator(T(1), T(1))
  @test CoordRefSystems.atol(c) == atol
end
