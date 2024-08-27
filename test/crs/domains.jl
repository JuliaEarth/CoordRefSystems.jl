@testset "Projection domain" begin
  @testset "Mercator" begin
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(Mercator, c1)
        c2 = convert(Mercator, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1)
      else
        @test_throws ArgumentError convert(Mercator, c1)
      end
    end
  end

  @testset "WebMercator" begin
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(WebMercator, c1)
        c2 = convert(WebMercator, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1)
      else
        @test_throws ArgumentError convert(WebMercator, c1)
      end
    end
  end

  @testset "PlateCarree" begin
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(PlateCarree, c1)
        c2 = convert(PlateCarree, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1)
      else
        @test_throws ArgumentError convert(PlateCarree, c1)
      end
    end
  end

  @testset "Lambert" begin
    atol = T === Float32 ? 1.0f-2° : 1e-4°
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(Lambert, c1)
        c2 = convert(Lambert, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1; atol)
      else
        @test_throws ArgumentError convert(Lambert, c1)
      end
    end
  end

  @testset "Behrmann" begin
    atol = T === Float32 ? 1.0f-2° : 1e-4°
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(Behrmann, c1)
        c2 = convert(Behrmann, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1; atol)
      else
        @test_throws ArgumentError convert(Behrmann, c1)
      end
    end
  end

  @testset "GallPeters" begin
    atol = T === Float32 ? 1.0f-2° : 1e-4°
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(GallPeters, c1)
        c2 = convert(GallPeters, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1; atol)
      else
        @test_throws ArgumentError convert(GallPeters, c1)
      end
    end
  end

  @testset "WinkelTripel" begin
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(WinkelTripel, c1)
        c2 = convert(WinkelTripel, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1)
      else
        @test_throws ArgumentError convert(WinkelTripel, c1)
      end
    end
  end

  @testset "Robinson" begin
    atol = T(1e-3) * °
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(Robinson, c1)
        c2 = convert(Robinson, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1; atol)
      else
        @test_throws ArgumentError convert(Robinson, c1)
      end
    end
  end

  @testset "OrthoNorth forward" begin
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(OrthoNorth, c1)
        c2 = convert(OrthoNorth, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
      else
        @test_throws ArgumentError convert(OrthoNorth, c1)
      end
    end
  end

  @testset "OrthoNorth inverse" begin
    # coordinates at the singularity of the projection (lat ≈ 90) cannot be inverted
    for lat in T.(1:89), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(OrthoNorth, c1)
        c2 = convert(OrthoNorth, c1)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1)
      end
    end

    # coordinates at the edge of the projection (lat ≈ 0)
    # cannot be accurately inverted by numerical problems
    atol = T(0.5) * °
    for lon in T.(-180:180)
      c1 = LatLon(T(0), lon)
      if indomain(OrthoNorth, c1)
        c2 = convert(OrthoNorth, c1)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1; atol)
      end
    end
  end

  @testset "OrthoSouth forward" begin
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(OrthoSouth, c1)
        c2 = convert(OrthoSouth, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
      else
        @test_throws ArgumentError convert(OrthoSouth, c1)
      end
    end
  end

  @testset "OrthoSouth inverse" begin
    # coordinates at the singularity of the projection (lat ≈ -90) cannot be inverted
    for lat in T.(-89:-1), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(OrthoSouth, c1)
        c2 = convert(OrthoSouth, c1)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1)
      end
    end

    # coordinates at the edge of the projection (lat ≈ 0)
    # cannot be accurately inverted by numerical problems
    atol = T(0.5) * °
    for lon in T.(-180:180)
      c1 = LatLon(T(0), lon)
      if indomain(OrthoSouth, c1)
        c2 = convert(OrthoSouth, c1)
        c3 = convert(LatLon, c2)
        @test allapprox(c3, c1; atol)
      end
    end
  end

  @testset "TransverseMercator forward" begin
    TM = CoordRefSystems.shift(
      CoordRefSystems.TransverseMercator{
        WGS84Latest,
        CoordRefSystems.TransverseMercatorParams(k₀ = 0.9996, latₒ = 15.0°)
      },
      lonₒ=25.0°
    )
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(TM, c1)
        c2 = convert(TM, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
      else
        @test_throws ArgumentError convert(TM, c1)
      end
    end
  end

  @testset "UTMNorth forward" begin
    UTMNorth32 = utm(North, 32)
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(UTMNorth32, c1)
        c2 = convert(UTMNorth32, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
      else
        @test_throws ArgumentError convert(UTMNorth32, c1)
      end
    end
  end

  @testset "UTMSouth forward" begin
    UTMSouth59 = utm(South, 59)
    for lat in T.(-90:90), lon in T.(-180:180)
      c1 = LatLon(lat, lon)
      if indomain(UTMSouth59, c1)
        c2 = convert(UTMSouth59, c1)
        @test isfinite(c2.x)
        @test isfinite(c2.y)
      else
        @test_throws ArgumentError convert(UTMSouth59, c1)
      end
    end
  end
end
