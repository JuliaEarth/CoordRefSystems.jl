@testset "Forward/Backward" begin
  @testset for C in projected
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(C, c1)
        c2 = convert(C, c1)
        c3 = convert(LatLon, c2)
        @test isclose(c3, c1)
      end
    end
  end
end
