@testset "Datum API" begin
  c = Cartesian(T(1), T(1))
  @test datum(c) === NoDatum

  c = LatLon(T(1), T(1))
  @test datum(c) === WGS84Latest
  @test ellipsoid(c) === Cartography.WGS84🌎
end
