@testset "Projection domain" begin
  for C in projected
    # forward
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

    # backward
    atol = if C <: Lambert
      T === Float32 ? 1.0f-2° : 1e-4°
    elseif C <: Behrmann
      T === Float32 ? 1.0f-2° : 1e-4°
    elseif C <: GallPeters
      T === Float32 ? 1.0f-1° : 1e-4°
    elseif C <: Robinson
      T(1e-3) * °
    elseif C <: Albers
      T === Float32 ? 1.0f-1° : 1e-5°
    else
      nothing
    end

    if C <: OrthoNorth
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
      # cannot be accurately inverted due to numerical issues
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
      # cannot be accurately inverted due to numerical issues
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
      # TODO: fix backward implementation
      continue
    elseif C <: Sinusoidal
      # coordinates at the singularity of the projection (lat ≈ ±90) cannot be inverted
      for lat in T.(-89:89), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(Sinusoidal, c1)
          c2 = convert(Sinusoidal, c1)
          c3 = convert(LatLon, c2)
          @test allapprox(c3, c1)
        end
      end
    elseif C <: LambertAzimuthalEqualArea
      # coordinates at the singularity of the projection (lat ≈ ±90) cannot be inverted
      # Float32 inversion is not very accurate
      if T === Float32
        # accuracy is better at coordinates far from the edge of the projection (lon ≈ ±180)
        atol = 1.0f-2°
        for lat in T.(-89:89), lon in T.(-170:170)
          c1 = LatLon(lat, lon)
          if indomain(C, c1)
            c2 = convert(C, c1)
            c3 = convert(LatLon, c2)
            @test allapprox(c3, c1; atol)
          end
        end

        atol = 1.0f0°
        for lat in T.(-89:89), lon in T[-180:-171; 171:180]
          c1 = LatLon(lat, lon)
          if indomain(C, c1)
            c2 = convert(C, c1)
            c3 = convert(LatLon, c2)
            @test allapprox(c3, c1; atol)
          end
        end
      else
        atol = 1e10°
        for lat in T.(-89:89), lon in T.(-180:180)
          c1 = LatLon(lat, lon)
          if indomain(C, c1)
            c2 = convert(C, c1)
            c3 = convert(LatLon, c2)
            @test allapprox(c3, c1; atol)
          end
        end
      end
    else
      kwargs = isnothing(atol) ? (;) : (; atol)

      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(C, c1)
          c2 = convert(C, c1)
          c3 = convert(LatLon, c2)
          @test allapprox(c3, c1; kwargs...)
        end
      end
    end
  end
end
