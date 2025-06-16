@testset "traits" begin
  @test isequalarea(Albers)
  @test isequalarea(LambertCylindrical)
  @test isequalarea(Behrmann)
  @test isequalarea(GallPeters)
  @test isequidistant(PlateCarree)
  @test isconformal(Mercator)
  @test iscompromise(Robinson)
  @test isequalarea(Sinusoidal)
  @test isequidistant(Sinusoidal)
  @test isconformal(TransverseMercator)
  @test iscompromise(WebMercator)
  @test iscompromise(WinkelTripel)
end
