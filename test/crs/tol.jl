@testset "Tolerance" begin
  tol = CoordRefSystems.atol(T) * u"m"
  c = LatLon(T(1), T(1))
  @test CoordRefSystems.tol(c) == tol
  c = Cartesian(T(1), T(1))
  @test CoordRefSystems.tol(c) == tol
  c = Polar(T(1), 1.0f0)
  @test CoordRefSystems.tol(c) == tol
  ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
  c = ShiftedMercator(T(1), T(1))
  @test CoordRefSystems.tol(c) == tol
end
