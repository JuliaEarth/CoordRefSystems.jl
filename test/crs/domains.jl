@testset "Projection domain" begin
  for P in projected
    C = if P <: TransverseMercator
      P{WGS84Latest}
    elseif P <: Albers
      P{WGS84Latest}
    else
      P
    end

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
      T === Float32 ? 1.0f-2° : 1e-4°
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
