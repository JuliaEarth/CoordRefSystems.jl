@testset "Projection domain" begin
  for C in projected
    atol = if C <: Lambert
      T === Float32 ? 1.0f-2° : 1e-4°
    elseif C <: Behrmann
      T === Float32 ? 1.0f-2° : 1e-4°
    elseif C <: GallPeters
      T === Float32 ? 1.0f-2° : 1e-4°
    elseif C <: Robinson
      T(1e-3) * °
    else
      nothing
    end

    if C <: OrthoNorth
      # forward
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

      # inverse
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
    elseif C <: OrthoSouth
      # forward
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

      # inverse
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
    elseif C <: TransverseMercator
      # TODO: fix inverse
      TM = CoordRefSystems.shift(TransverseMercator{0.9996,15.0°,WGS84Latest}, lonₒ=25.0°)
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
    elseif C <: Albers
      atol = T === Float32 ? 1.0f-1° : 1e-7°
      AlbersUS = CoordRefSystems.shift(Albers{23.0°,29.5°,45.5°,NAD83}, lonₒ=-96.0°)
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon{NAD83}(lat, lon)
        if indomain(AlbersUS, c1)
          c2 = convert(AlbersUS, c1)
          @test isfinite(c2.x)
          @test isfinite(c2.y)
          c3 = convert(LatLon{NAD83}, c2)
          @test allapprox(c3, c1; atol)
        else
          @test_throws ArgumentError convert(AlbersUS, c1)
        end
      end
    elseif C <: Sinusoidal
      # forward
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(Sinusoidal, c1)
          c2 = convert(Sinusoidal, c1)
          @test isfinite(c2.x)
          @test isfinite(c2.y)
        else
          @test_throws ArgumentError convert(Sinusoidal, c1)
        end
      end

      # inverse
      # coordinates at the singularity of the projection (lat ≈ ±90) cannot be inverted
      for lat in T.(-89:89), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(Sinusoidal, c1)
          c2 = convert(Sinusoidal, c1)
          c3 = convert(LatLon, c2)
          @test allapprox(c3, c1)
        end
      end
    else
      kwargs = isnothing(atol) ? (;) : (; atol)

      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(C, c1)
          c2 = convert(C, c1)
          @test isfinite(c2.x)
          @test isfinite(c2.y)
          c3 = convert(LatLon, c2)
          @test allapprox(c3, c1; kwargs...)
        else
          @test_throws ArgumentError convert(C, c1)
        end
      end
    end
  end
end
