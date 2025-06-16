@testset "Projection domain" begin
  c0 = LatLon(T(90), T(0))
  c1 = LatLon(T(30), T(60))
  c2 = LatLon(T(85), T(60))
  c3 = LatLon{ITRF{2008}}(T(30), T(60))
  c4 = LatLon{ITRF{2008}}(T(85), T(60))
  c5 = convert(LambertCylindrical, c1)
  c6 = convert(LambertCylindrical, c2)
  c7 = Cartesian(T(1), T(2))
  c8 = Cartesian{WGS84Latest}(T(1), T(2))
  for C in [Mercator, WebMercator]
    @test !indomain(C, c0)
    @test indomain(C, c1)
    @test indomain(C, c2)
    @test !indomain(C{WGS84Latest}, c0)
    @test indomain(C{WGS84Latest}, c1)
    @test indomain(C{WGS84Latest}, c2)
    @test indomain(C{WGS84{1762}}, c3)
    @test indomain(C{WGS84{1762}}, c4)
    @test indomain(C, c5)
    @test indomain(C, c6)
    @test indomain(C{WGS84Latest}, c7)
    @test indomain(C{WGS84Latest}, c8)
  end

  for C in projected
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(C, c1)
        c2 = convert(C, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
      else
        @test_throws ArgumentError convert(C, c1)
      end
    end
  end
end
