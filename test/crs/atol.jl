@testset "atol" begin
  c = LatLon(T(1), T(1))
  @test CoordRefSystems.atol(c) == CoordRefSystems.atol(T)
  c = Cartesian(T(1), T(1))
  @test CoordRefSystems.atol(c) == CoordRefSystems.atol(T)
  c = Polar(T(1), 1f0)
  @test CoordRefSystems.atol(c) == T(1f-5)
  ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
  c = ShiftedMercator(T(1), T(1))
  @test CoordRefSystems.atol(c) == CoordRefSystems.atol(T)
end
