@testset "Codes" begin
  @test CoordRefSystems.integer(EPSG{4326}) == 4326
  @test CoordRefSystems.integer(ESRI{102100}) == 102100
end
