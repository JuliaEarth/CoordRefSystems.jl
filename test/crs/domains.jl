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
    atol = if C <: LambertCylindrical
      T === Float32 ? 1.0f-2° : 1e-4°
    elseif C <: Behrmann
      T === Float32 ? 1.0f-2° : 1e-4°
    elseif C <: GallPeters
      T === Float32 ? 1.0f-1° : 1e-4°
    elseif C <: Robinson
      T(1e-3) * °
    elseif C <: Albers
      T === Float32 ? 1.0f-1° : 1e-5°
    elseif C <: EqualEarth && T === Float64
      1e-5°
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
          @test isclose(c3, c1)
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
          @test isclose(c3, c1; atol)
        end
      end
    elseif C <: OrthoSouth
      # coordinates at the singularity of the projection (lat ≈ -90) cannot be inverted
      for lat in T.(-89:-1), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(OrthoSouth, c1)
          c2 = convert(OrthoSouth, c1)
          c3 = convert(LatLon, c2)
          @test isclose(c3, c1)
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
          @test isclose(c3, c1; atol)
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
          @test isclose(c3, c1)
        end
      end
    elseif C <: LambertAzimuthal
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
            @test isclose(c3, c1; atol)
          end
        end

        atol = 1.0f0°
        for lat in T.(-89:89), lon in T[-180:-171; 171:180]
          c1 = LatLon(lat, lon)
          if indomain(C, c1)
            c2 = convert(C, c1)
            c3 = convert(LatLon, c2)
            @test isclose(c3, c1; atol)
          end
        end
      else
        atol = 1e-6°
        for lat in T.(-89:89), lon in T.(-180:180)
          c1 = LatLon(lat, lon)
          if indomain(C, c1)
            c2 = convert(C, c1)
            c3 = convert(LatLon, c2)
            @test isclose(c3, c1; atol)
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
          @test isclose(c3, c1; kwargs...)
        end
      end
    end
  end
end
