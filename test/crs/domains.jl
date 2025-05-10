@testset "Projection domain" begin
  c0 = LatLon(T(90), T(0))
  c1 = LatLon(T(30), T(60))
  c2 = LatLon(T(85), T(60))
  c3 = LatLon{ITRF{2008}}(T(30), T(60))
  c4 = LatLon{ITRF{2008}}(T(85), T(60))
  c5 = convert(Lambert, c1)
  c6 = convert(Lambert, c2)
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

  @testset "C" for C in projected
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
    if C <: TransverseMercator
      # TODO: fix backward implementation
      continue
    elseif C <: Robinson && T == Float64
      # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/55
      continue
    end

    for lat in T.(-90:90), lon in T.(-180:180)
      if C <: EqualEarth && lat == -90
        # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/243
        continue
      elseif C <: Orthographic && lat == 0
        continue
      elseif C <: LambertAzimuthalEqualArea && lat == -90
        # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/265
        continue
      elseif C == LambertAzimuthalEqualArea{15.0°} && -16 <= lat <= -12 && 180 - abs(lon) <= 3
        # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/268
        continue
      end

      c1 = LatLon(lat, lon)

      # skip if not in domain
      indomain(C, c1) || continue

      # convert forward
      c2 = convert(C, c1)

      # convert backward
      c3 = convert(LatLon, c2)

      # Default tolerances
      lat_atol = sqrt(eps(T)) * 90°
      lon_atol = sqrt(eps(T)) * 180°

      if C <: Albers || C <: EqualAreaCylindrical
        lat_atol = sqrt_tol(abs(lat), 90) * °
      end
      if C <: LambertAzimuthalEqualArea
        antipode(::Type{<:LambertAzimuthalEqualArea{latₒ}}) where {latₒ} = LatLon(-T(ustrip(°, latₒ)), T(180))
        relative_error(x, xlim) = norm(x - xlim) / norm(xlim)
        tol = sqrt_tol(
            relative_error(
              svec(convert(Cartesian, c1)),
              svec(convert(Cartesian, antipode(C)))
            )
        )
        lat_atol = tol * 90°
        lon_atol = tol * 180°
      end
      if C <: Orthographic
        lat_atol = sqrt_tol(abs(lat), 90) * °
      end
      if (
        (
          C <: LambertAzimuthalEqualArea
          || C <: Orthographic
          || C <: Sinusoidal
        )
        && abs(lat) == 90
      )
        lon_atol = Inf*°
      end
      @assert (
        isapprox(c3.lat, c1.lat; atol = lat_atol)
        && isapproxangle(c3.lon, c1.lon; atol = lon_atol)
      )
    end
  end
end
