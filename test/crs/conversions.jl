@testset "Conversions" begin
  @testset "Basic" begin
    atol = CoordRefSystems.atol(T) * u"m"
    @testset "Cartesian <> Polar" begin
      c1 = Cartesian(T(1), T(1))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(√2), T(π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(-T(1), T(1))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(√2), T(3π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(-T(1), -T(1))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(√2), T(5π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(T(1), -T(1))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(√2), T(7π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(T(0), T(1))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(1), T(π / 2)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(0), -T(1))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(1), T(3π / 2)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(1), T(0))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(1), T(0)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(-T(1), T(0))
      c2 = convert(Polar, c1)
      @test allapprox(c2, Polar(T(1), T(π)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      # type stability
      c1 = Cartesian(T(1), T(1))
      c2 = Polar(T(√2), T(π / 4))
      @inferred convert(Polar, c1)
      @inferred convert(Cartesian, c2)
    end

    @testset "Cartesian <> Cylindrical" begin
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(√2), T(π / 4), T(1)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(-T(1), T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(√2), T(3π / 4), T(1)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(-T(1), -T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(√2), T(5π / 4), T(1)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(T(1), -T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(√2), T(7π / 4), T(1)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(T(0), T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(1), T(π / 2), T(1)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(0), -T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(1), T(3π / 2), T(1)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(1), T(0), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(1), T(0), T(1)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(-T(1), T(0), T(1))
      c2 = convert(Cylindrical, c1)
      @test allapprox(c2, Cylindrical(T(1), T(π), T(1)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      # type stability
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = Cylindrical(T(√2), T(π / 4), T(1))
      @inferred convert(Cylindrical, c1)
      @inferred convert(Cartesian, c2)
    end

    @testset "Cartesian <> Spherical" begin
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√3), atan(T(√2)), T(π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(-T(1), T(1), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√3), atan(T(√2)), T(3π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(-T(1), -T(1), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√3), atan(T(√2)), T(5π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(T(1), -T(1), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√3), atan(T(√2)), T(7π / 4)))
      c3 = convert(Cartesian, c2)
      @test allapprox(c3, c1)

      c1 = Cartesian(T(0), T(1), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√2), T(π / 4), T(π / 2)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(0), -T(1), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√2), T(π / 4), T(3π / 2)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(1), T(0), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√2), T(π / 4), T(0)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(-T(1), T(0), T(1))
      c2 = convert(Spherical, c1)
      @test allapprox(c2, Spherical(T(√2), T(π / 4), T(π)))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      # type stability
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = Spherical(T(√3), atan(T(√2)), T(π / 4))
      @inferred convert(Spherical, c1)
      @inferred convert(Cartesian, c2)
    end

    @testset "Cartesian: Datum conversion" begin
      # WGS84 (G1762) to ITRF2008
      c1 = Cartesian{WGS84{1762}}(T(0), T(0), T(0))
      c2 = convert(Cartesian{ITRF{2008}}, c1)
      @test allapprox(c2, Cartesian{ITRF{2008}}(T(0), T(0), T(0)))

      c1 = Cartesian{WGS84{1762}}(T(1), T(1), T(1))
      c2 = convert(Cartesian{ITRF{2008}}, c1)
      @test allapprox(c2, Cartesian{ITRF{2008}}(T(1), T(1), T(1)))

      # ITRF2008 to ITRF2020
      c1 = Cartesian{ITRF{2008}}(T(0), T(0), T(0))
      c2 = convert(Cartesian{ITRFLatest}, c1)
      @test allapprox(c2, Cartesian{ITRFLatest}(T(-0.0002), T(-0.002), T(-0.0023)))

      c1 = Cartesian{ITRF{2008}}(T(1), T(1), T(1))
      c2 = convert(Cartesian{ITRFLatest}, c1)
      @test allapprox(c2, Cartesian{ITRFLatest}(T(0.9998000005900001), T(0.99800000059), T(0.9977000005900001)))

      # avoid converting coordinates with the same datum as the first argument
      c1 = Cartesian{WGS84Latest}(T(0), T(0), T(0))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c1 === c2

      c1 = Cartesian{WGS84Latest}(T(0), T(0))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c1 === c2

      c1 = Cartesian{WGS84{1762}}(T(0), T(0), T(0))
      c2 = Cartesian{ITRF{2008}}(T(0), T(0), T(0))
      @inferred convert(Cartesian{ITRF{2008}}, c1)
      @inferred convert(Cartesian{ITRFLatest}, c2)
    end
  end

  @testset "Geographic" begin
    @testset "GeodeticLatLon <> GeocentricLatLon" begin
      c1 = LatLon(T(30), T(40))
      c2 = convert(GeocentricLatLon, c1)
      @test allapprox(c2, GeocentricLatLon(T(29.833635809829065), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(35), T(40))
      c2 = convert(GeocentricLatLon, c1)
      @test allapprox(c2, GeocentricLatLon(T(34.819388702349606), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(40), T(40))
      c2 = convert(GeocentricLatLon, c1)
      @test allapprox(c2, GeocentricLatLon(T(39.810610551928434), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(30), T(40))
      c2 = convert(GeocentricLatLon, c1)
      @test allapprox(c2, GeocentricLatLon(-T(29.833635809829065), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(35), T(40))
      c2 = convert(GeocentricLatLon, c1)
      @test allapprox(c2, GeocentricLatLon(-T(34.819388702349606), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(40), T(40))
      c2 = convert(GeocentricLatLon, c1)
      @test allapprox(c2, GeocentricLatLon(-T(39.810610551928434), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(30), T(40))
      c2 = GeocentricLatLon(T(29.833635809829065), T(40))
      @inferred convert(GeocentricLatLon, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "GeodeticLatLon <> AuthalicLatLon" begin
      c1 = LatLon(T(30), T(40))
      c2 = convert(AuthalicLatLon, c1)
      @test allapprox(c2, AuthalicLatLon(T(29.888997034459567), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(35), T(40))
      c2 = convert(AuthalicLatLon, c1)
      @test allapprox(c2, AuthalicLatLon(T(34.87951854973729), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(40), T(40))
      c2 = convert(AuthalicLatLon, c1)
      @test allapprox(c2, AuthalicLatLon(T(39.87369373453432), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(30), T(40))
      c2 = convert(AuthalicLatLon, c1)
      @test allapprox(c2, AuthalicLatLon(-T(29.888997034459567), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(35), T(40))
      c2 = convert(AuthalicLatLon, c1)
      @test allapprox(c2, AuthalicLatLon(-T(34.87951854973729), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(40), T(40))
      c2 = convert(AuthalicLatLon, c1)
      @test allapprox(c2, AuthalicLatLon(-T(39.87369373453432), T(40)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(30), T(40))
      c2 = AuthalicLatLon(T(29.888997034459567), T(40))
      @inferred convert(AuthalicLatLon, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> Cartesian" begin
      c1 = LatLon(T(30), T(40))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(35), T(45))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(3698470.287205801), T(3698470.2872058), T(3637866.909378095)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(40), T(50))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(3144971.82314589), T(3748031.468841677), T(4077985.572200376)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(30), -T(40))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(4234890.278665873), -T(3553494.8709047823), -T(3170373.735383637)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(35), T(45))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(3698470.287205801), T(3698470.2872058), -T(3637866.909378095)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(40), -T(50))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(3144971.82314589), -T(3748031.468841677), T(4077985.572200376)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(30), T(40))
      c2 = Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637))
      @inferred convert(Cartesian, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> LatLonAlt" begin
      c1 = LatLon(T(30), T(40))
      c2 = convert(LatLonAlt, c1)
      @test allapprox(c2, LatLonAlt(T(30), T(40), T(0)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(30), T(40))
      c2 = LatLonAlt(T(30), T(40), T(0))
      @inferred convert(LatLonAlt, c1)
      @inferred convert(LatLon, c2)
    end

    if T === Float64
      # altitude can only be calculated accurately using Float64
      @testset "LatLonAlt <> Cartesian" begin
        c1 = LatLonAlt(T(30), T(40), T(0))
        c2 = convert(Cartesian, c1)
        @test allapprox(c2, Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637)))
        c3 = convert(LatLonAlt, c2)
        @test allapprox(c3, c1)

        c1 = LatLonAlt(T(35), T(45), T(100))
        c2 = convert(Cartesian, c1)
        @test allapprox(c2, Cartesian{WGS84Latest}(T(3698528.2100023343), T(3698528.2100023334), T(3637924.26702173)))
        c3 = convert(LatLonAlt, c2)
        @test allapprox(c3, c1)

        c1 = LatLonAlt(T(40), T(50), T(200))
        c2 = convert(Cartesian, c1)
        @test allapprox(c2, Cartesian{WGS84Latest}(T(3145070.3039211915), T(3748148.8336594435), T(4078114.1297223135)))
        c3 = convert(LatLonAlt, c2)
        @test allapprox(c3, c1)

        c1 = LatLonAlt(-T(30), -T(40), T(0))
        c2 = convert(Cartesian, c1)
        @test allapprox(c2, Cartesian{WGS84Latest}(T(4234890.278665873), -T(3553494.8709047823), -T(3170373.735383637)))
        c3 = convert(LatLonAlt, c2)
        @test allapprox(c3, c1)

        c1 = LatLonAlt(-T(35), T(45), T(100))
        c2 = convert(Cartesian, c1)
        @test allapprox(c2, Cartesian{WGS84Latest}(T(3698528.2100023343), T(3698528.2100023334), -T(3637924.26702173)))
        c3 = convert(LatLonAlt, c2)
        @test allapprox(c3, c1)

        c1 = LatLonAlt(T(40), -T(50), T(200))
        c2 = convert(Cartesian, c1)
        @test allapprox(
          c2,
          Cartesian{WGS84Latest}(T(3145070.3039211915), -T(3748148.8336594435), T(4078114.1297223135))
        )
        c3 = convert(LatLonAlt, c2)
        @test allapprox(c3, c1)

        # type stability
        c1 = LatLonAlt(T(30), T(40), T(0))
        c2 = Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637))
        @inferred convert(Cartesian, c1)
        @inferred convert(LatLonAlt, c2)
      end
    end

    @testset "LatLon: Datum conversion" begin
      # WGS84 (G1762) to ITRF2008
      c1 = LatLon(T(30), T(40))
      c2 = convert(LatLon{ITRF{2008}}, c1)
      @test allapprox(c2, LatLon{ITRF{2008}}(T(30), T(40)))

      c1 = LatLon(T(35), T(45))
      c2 = convert(LatLon{ITRF{2008}}, c1)
      @test allapprox(c2, LatLon{ITRF{2008}}(T(35), T(45)))

      # ITRF2008 to ITRF2020
      c1 = LatLon{ITRF{2008}}(T(30), T(40))
      c2 = convert(LatLon{ITRFLatest}, c1)
      @test allapprox(c2, LatLon{ITRFLatest}(T(29.999999988422587), T(39.99999998545356)))

      c1 = LatLon{ITRF{2008}}(T(35), T(45))
      c2 = convert(LatLon{ITRFLatest}, c1)
      @test allapprox(c2, LatLon{ITRFLatest}(T(34.99999999095351), T(44.99999998605742)))

      # GGRS87 to WGS84
      c1 = LatLon{GGRS87}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30.002400431894902), T(40.00192535096667)))

      c1 = LatLon{GGRS87}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35.0022781947901), T(45.002127518092834)))

      # NAD83 to WGS84
      c1 = LatLon{NAD83}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30), T(40)))

      c1 = LatLon{NAD83}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35), T(45)))

      # Potsdam to WGS84
      c1 = LatLon{Potsdam}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30.001530921141082), T(39.99588940866917)))

      c1 = LatLon{Potsdam}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35.00122407077783), T(44.995222349198244)))

      # Carthage to WGS84
      c1 = LatLon{Carthage}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30.00153253176913), T(40.00179973969016)))

      c1 = LatLon{Carthage}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35.001164857937006), T(45.00208363872234)))

      # Hermannskogel to WGS84
      c1 = LatLon{Hermannskogel}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30.002491990948382), T(39.99756285140804)))

      c1 = LatLon{Hermannskogel}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35.00226854367654), T(44.996794271771755)))

      # Ire65 to WGS84
      c1 = LatLon{Ire65}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30.003595375684984), T(39.99572206332302)))

      c1 = LatLon{Ire65}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35.003385379949535), T(44.99524677680064)))

      # NZGD1949 to WGS84
      c1 = LatLon{NZGD1949}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30.000667173416794), T(39.99980114703305)))

      c1 = LatLon{NZGD1949}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35.00052502406383), T(44.999734233826786)))

      # OSGB36 to WGS84
      c1 = LatLon{OSGB36}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(30.003642624158758), T(39.996222132850185)))

      c1 = LatLon{OSGB36}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test allapprox(c2, LatLon{WGS84Latest}(T(35.003474099905354), T(44.99575175081459)))

      c1 = LatLon(T(30), T(40))
      c2 = LatLon{ITRF{2008}}(T(30), T(40))
      @inferred convert(LatLon{ITRF{2008}}, c1)
      @inferred convert(LatLon{ITRFLatest}, c2)
    end
  end

  @testset "Projected" begin
    @testset "LatLon <> Mercator" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Mercator, c1)
      @test allapprox(c2, Mercator(T(10018754.171394622), T(5591295.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Mercator, c1)
      @test allapprox(c2, Mercator(T(10018754.171394622), -T(5591295.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Mercator, c1)
      @test allapprox(c2, Mercator(-T(10018754.171394622), T(5591295.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Mercator, c1)
      @test allapprox(c2, Mercator(-T(10018754.171394622), -T(5591295.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Mercator(T(10018754.171394622), T(5591295.9185533915))
      @inferred convert(Mercator, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> WebMercator" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(WebMercator, c1)
      @test allapprox(c2, WebMercator(T(10018754.171394622), T(5621521.486192066)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(WebMercator, c1)
      @test allapprox(c2, WebMercator(T(10018754.171394622), -T(5621521.486192066)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(WebMercator, c1)
      @test allapprox(c2, WebMercator(-T(10018754.171394622), T(5621521.486192066)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(WebMercator, c1)
      @test allapprox(c2, WebMercator(-T(10018754.171394622), -T(5621521.486192066)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = WebMercator(T(10018754.171394622), T(5621521.486192066))
      @inferred convert(WebMercator, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> PlateCarree" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(PlateCarree, c1)
      @test allapprox(c2, PlateCarree(T(10018754.171394622), T(5009377.085697311)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(PlateCarree, c1)
      @test allapprox(c2, PlateCarree(T(10018754.171394622), -T(5009377.085697311)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(PlateCarree, c1)
      @test allapprox(c2, PlateCarree(-T(10018754.171394622), T(5009377.085697311)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(PlateCarree, c1)
      @test allapprox(c2, PlateCarree(-T(10018754.171394622), -T(5009377.085697311)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = PlateCarree(T(10018754.171394622), T(5009377.085697311))
      @inferred convert(PlateCarree, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> Lambert" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Lambert, c1)
      @test allapprox(c2, Lambert(T(10018754.171394622), T(4489858.8869480025)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Lambert, c1)
      @test allapprox(c2, Lambert(T(10018754.171394622), -T(4489858.8869480025)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Lambert, c1)
      @test allapprox(c2, Lambert(-T(10018754.171394622), T(4489858.8869480025)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Lambert, c1)
      @test allapprox(c2, Lambert(-T(10018754.171394622), -T(4489858.8869480025)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Lambert(T(10018754.171394622), T(4489858.8869480025))
      @inferred convert(Lambert, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> Behrmann" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Behrmann, c1)
      @test allapprox(c2, Behrmann(T(8683765.222580686), T(5180102.328839251)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Behrmann, c1)
      @test allapprox(c2, Behrmann(T(8683765.222580686), -T(5180102.328839251)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Behrmann, c1)
      @test allapprox(c2, Behrmann(-T(8683765.222580686), T(5180102.328839251)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Behrmann, c1)
      @test allapprox(c2, Behrmann(-T(8683765.222580686), -T(5180102.328839251)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Behrmann(T(8683765.222580686), T(5180102.328839251))
      @inferred convert(Behrmann, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> GallPeters" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(GallPeters, c1)
      @test allapprox(c2, GallPeters(T(7096215.158458031), T(6338983.732612475)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(GallPeters, c1)
      @test allapprox(c2, GallPeters(T(7096215.158458031), -T(6338983.732612475)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(GallPeters, c1)
      @test allapprox(c2, GallPeters(-T(7096215.158458031), T(6338983.732612475)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(GallPeters, c1)
      @test allapprox(c2, GallPeters(-T(7096215.158458031), -T(6338983.732612475)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = GallPeters(T(7096215.158458031), T(6338983.732612475))
      @inferred convert(GallPeters, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> WinkelTripel" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(WinkelTripel, c1)
      @test allapprox(c2, WinkelTripel(T(7044801.6979576545), T(5231448.051548355)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(WinkelTripel, c1)
      @test allapprox(c2, WinkelTripel(T(7044801.6979576545), -T(5231448.051548355)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(WinkelTripel, c1)
      @test allapprox(c2, WinkelTripel(-T(7044801.6979576545), T(5231448.051548355)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(WinkelTripel, c1)
      @test allapprox(c2, WinkelTripel(-T(7044801.6979576545), -T(5231448.051548355)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(0), T(0))
      c2 = convert(WinkelTripel, c1)
      @test allapprox(c2, WinkelTripel(T(0), T(0)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = WinkelTripel(T(7044801.6979576545), T(5231448.051548355))
      @inferred convert(WinkelTripel, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> Robinson" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Robinson, c1)
      @test allapprox(c2, Robinson(T(7620313.925950073), T(4805073.646653474)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Robinson, c1)
      @test allapprox(c2, Robinson(T(7620313.925950073), -T(4805073.646653474)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Robinson, c1)
      @test allapprox(c2, Robinson(-T(7620313.925950073), T(4805073.646653474)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Robinson, c1)
      @test allapprox(c2, Robinson(-T(7620313.925950073), -T(4805073.646653474)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Robinson(T(7620313.925950073), T(4805073.646653474))
      @inferred convert(Robinson, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> OrthoNorth" begin
      c1 = LatLon(T(30), T(60))
      c2 = convert(OrthoNorth, c1)
      @test allapprox(c2, OrthoNorth(T(4787610.688267582), T(-2764128.319646418)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(30), -T(60))
      c2 = convert(OrthoNorth, c1)
      @test allapprox(c2, OrthoNorth(-T(4787610.688267582), T(-2764128.319646418)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(30), T(60))
      c2 = OrthoNorth(T(4787610.688267582), T(-2764128.319646418))
      @inferred convert(OrthoNorth, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> OrthoSouth" begin
      c1 = LatLon(-T(30), T(60))
      c2 = convert(OrthoSouth, c1)
      @test allapprox(c2, OrthoSouth(T(4787610.688267582), T(2764128.319646418)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(30), -T(60))
      c2 = convert(OrthoSouth, c1)
      @test allapprox(c2, OrthoSouth(-T(4787610.688267582), T(2764128.319646418)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(-T(30), T(60))
      c2 = OrthoSouth(T(4787610.688267582), T(2764128.319646418))
      @inferred convert(OrthoSouth, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> OrthoSpherical" begin
      OrthoNorthSpherical = CoordRefSystems.get(ESRI{102035})
      OrthoSouthSpherical = CoordRefSystems.get(ESRI{102037})

      c1 = LatLon(T(30), T(60))
      c2 = convert(OrthoNorthSpherical, c1)
      @test allapprox(c2, OrthoNorthSpherical(T(4783602.75), T(-2761814.335408735)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(30), -T(60))
      c2 = convert(OrthoNorthSpherical, c1)
      @test allapprox(c2, OrthoNorthSpherical(-T(4783602.75), T(-2761814.335408735)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(30), T(60))
      c2 = convert(OrthoSouthSpherical, c1)
      @test allapprox(c2, OrthoSouthSpherical(T(4783602.75), T(2761814.335408735)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(30), -T(60))
      c2 = convert(OrthoSouthSpherical, c1)
      @test allapprox(c2, OrthoSouthSpherical(-T(4783602.75), T(2761814.335408735)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(30), T(60))
      c2 = LatLon(-T(30), T(60))
      c3 = OrthoNorthSpherical(T(4783602.75), T(-2761814.335408735))
      c4 = OrthoSouthSpherical(T(4783602.75), T(2761814.335408735))
      @inferred convert(OrthoNorthSpherical, c1)
      @inferred convert(OrthoSouthSpherical, c2)
      @inferred convert(LatLon, c3)
      @inferred convert(LatLon, c4)
    end

    @testset "LatLon <> TransverseMercator" begin
      # tests from GeographicLib testset
      # link: https://sourceforge.net/projects/geographiclib/files/testdata/TMcoords.dat.gz
      TM = CoordRefSystems.TransverseMercator{0.9996,0.0u"°",0.0u"°"}

      c1 = LatLon(T(70.579277094557), T(45.599419731762))
      c2 = convert(TM, c1)
      @test allapprox(c2, TM(T(1548706.7916191491794), T(8451449.1987722350778)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(19.479895588178), T(75.662049225092))
      c2 = convert(TM, c1)
      @test allapprox(c2, TM(T(9855841.2329353332058), T(6145496.1151551160577)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(5.458957393183), T(36.385237374895))
      c2 = convert(TM, c1)
      @test allapprox(c2, TM(T(4328154.0835012728645), T(749647.6236903529367)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(61.965604972549), T(58.931370849824))
      c2 = convert(TM, c1)
      @test allapprox(c2, TM(T(2727657.3379737519243), T(8283916.696409868168)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # latₒ, lonₒ ≠ 0
      TM = CoordRefSystems.TransverseMercator{0.9996,15.0u"°",25.0u"°"}

      c1 = LatLon(T(30), T(60))
      c2 = convert(TM, c1)
      @test allapprox(c2, TM(T(3478021.0568801453), T(2237622.8976712096)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(35), T(65))
      c2 = convert(TM, c1)
      @test allapprox(c2, TM(T(3736618.554412091), T(3043187.5889959945)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(30), T(60))
      c2 = TM(T(3478021.0568801453), T(2237622.8976712096))
      @inferred convert(TM, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> UTM" begin
      c1 = LatLon(T(56), T(12))
      c2 = convert(UTMNorth{32}, c1)
      @test allapprox(c2, UTMNorth{32}(T(687071.439107327), T(6210141.326872105)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(44), T(174))
      c2 = convert(UTMSouth{59}, c1)
      @test allapprox(c2, UTMSouth{59}(T(740526.3210524899), T(5123750.873037999)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(56), T(12))
      c2 = LatLon(-T(44), T(174))
      c3 = UTMNorth{32}(T(687071.439107327), T(6210141.326872105))
      c4 = UTMSouth{59}(T(740526.3210524899), T(5123750.873037999))
      @inferred convert(UTMNorth{32}, c1)
      @inferred convert(UTMSouth{59}, c2)
      @inferred convert(LatLon, c3)
      @inferred convert(LatLon, c4)
    end

    @testset "LatLon <> ShiftedCRS" begin
      ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
      c1 = LatLon(T(45), T(90))
      c2 = convert(ShiftedMercator, c1)
      @test allapprox(c2, ShiftedMercator(T(8349161.809495518), T(5591495.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), T(90))
      c2 = convert(ShiftedMercator, c1)
      @test allapprox(c2, ShiftedMercator(T(8349161.809495518), -T(5591095.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(T(45), -T(90))
      c2 = convert(ShiftedMercator, c1)
      @test allapprox(c2, ShiftedMercator(-T(11688346.533293724), T(5591495.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(ShiftedMercator, c1)
      @test allapprox(c2, ShiftedMercator(-T(11688346.533293724), -T(5591095.9185533915)))
      c3 = convert(LatLon, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = ShiftedMercator(T(8349161.809495518), T(5591495.9185533915))
      @inferred convert(ShiftedMercator, c1)
      @inferred convert(LatLon, c2)
    end

    @testset "LatLon <> Projected (different datums)" begin
      # WGS84 (G1762) to ITRF2008
      c1 = LatLon{WGS84{1762}}(T(45), T(90))
      c2 = convert(Mercator{ITRF{2008}}, c1)
      @test allapprox(c2, Mercator{ITRF{2008}}(T(10018754.171394622), T(5591295.9185533915)))

      c1 = Mercator{WGS84{1762}}(T(10018754.171394622), T(5591295.9185533915))
      c2 = convert(LatLon{ITRF{2008}}, c1)
      @test allapprox(c2, LatLon{ITRF{2008}}(T(45), T(90)))

      # ITRF2008 to ITRF2020
      ShiftedMercator = CoordRefSystems.shift(Mercator{ITRFLatest}, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
      c1 = LatLon{ITRF{2008}}(T(45), T(90))
      c2 = convert(ShiftedMercator, c1)
      @test allapprox(c2, ShiftedMercator(T(8349161.8090374395), T(5591495.918071649)))

      ShiftedMercator = CoordRefSystems.shift(Mercator{ITRF{2008}}, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
      c1 = ShiftedMercator(T(8349161.8090374395), T(5591495.918071649))
      c2 = convert(LatLon{ITRFLatest}, c1)
      @test allapprox(c2, LatLon{ITRFLatest}(T(44.99999999574679), T(89.99999999177004)))

      # GGRS87 to WGS84
      c1 = LatLon{GGRS87}(T(45), T(90))
      c2 = convert(PlateCarree{WGS84{1762}}, c1)
      @test allapprox(c2, PlateCarree(T(10019036.352134585), T(5009498.78549335)))

      c1 = PlateCarree{GGRS87}(T(10019036.352134585), T(5009498.78549335))
      c2 = convert(LatLon{WGS84{1762}}, c1)
      @test allapprox(c2, LatLon(T(45.002186400242984), T(90.00506975166428)))

      # NAD83 to WGS84
      c1 = LatLon{NAD83}(T(45), T(90))
      c2 = convert(WinkelTripel{WGS84{1762}}, c1)
      @test allapprox(c2, WinkelTripel(T(7044801.698007298), T(5231448.051441181)))

      c1 = WinkelTripel{NAD83}(T(7044801.698007298), T(5231448.051441181))
      c2 = convert(LatLon{WGS84{1762}}, c1)
      @test allapprox(c2, LatLon(T(45), T(90)))

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Mercator(T(10018754.171394622), T(5591295.9185533915))
      @inferred convert(Mercator{ITRF{2008}}, c1)
      @inferred convert(LatLon{ITRF{2008}}, c2)
    end

    @testset "Cartesian <> Projected" begin
      ShiftedMercator = CoordRefSystems.shift(Mercator{WGS84Latest}, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")

      # conversion to cartesian 2D (default)
      c1 = Mercator(T(1), T(1))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(1), T(1)))
      c3 = convert(Mercator{WGS84Latest}, c2)
      @test allapprox(c3, c1)

      c1 = OrthoNorth(T(1), T(1))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(1), T(1)))
      c3 = convert(OrthoNorth{WGS84Latest}, c2)
      @test allapprox(c3, c1)

      c1 = ShiftedMercator(T(1), T(1))
      c2 = convert(Cartesian, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(1), T(1)))
      c3 = convert(ShiftedMercator, c2)
      @test allapprox(c3, c1)

      # conversion to cartesian 3D
      c1 = convert(Mercator, LatLon(T(30), T(40)))
      c2 = convert(Cartesian{WGS84Latest,3}, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637)))
      c3 = convert(Mercator{WGS84Latest}, c2)
      @test allapprox(c3, c1)

      c1 = convert(OrthoNorth, LatLon(T(30), T(40)))
      c2 = convert(Cartesian{WGS84Latest,3}, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637)))
      c3 = convert(OrthoNorth{WGS84Latest}, c2)
      @test allapprox(c3, c1)

      c1 = convert(ShiftedMercator, LatLon(T(30), T(40)))
      c2 = convert(Cartesian{WGS84Latest,3}, c1)
      @test allapprox(c2, Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637)))
      c3 = convert(ShiftedMercator, c2)
      @test allapprox(c3, c1)

      # type stability
      c1 = Cartesian{WGS84Latest}(T(1), T(1))
      c2 = Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637))
      c3 = Mercator(T(0), T(0))
      c4 = OrthoNorth(T(0), T(0))
      c5 = ShiftedMercator(T(0), T(0))
      @inferred convert(Mercator{WGS84Latest}, c1)
      @inferred convert(OrthoNorth{WGS84Latest}, c1)
      @inferred convert(ShiftedMercator, c1)
      @inferred convert(Mercator{WGS84Latest}, c2)
      @inferred convert(OrthoNorth{WGS84Latest}, c2)
      @inferred convert(ShiftedMercator, c2)
      @inferred convert(Cartesian, c3)
      @inferred convert(Cartesian, c4)
      @inferred convert(Cartesian, c5)
      @inferred convert(Cartesian{WGS84Latest,3}, c3)
      @inferred convert(Cartesian{WGS84Latest,3}, c4)
      @inferred convert(Cartesian{WGS84Latest,3}, c5)
    end

    @testset "Projection conversion" begin
      # same datum
      c1 = Lambert(T(10018754.171394622), T(4489858.8869480025))
      c2 = convert(WinkelTripel{WGS84Latest}, c1)
      @test allapprox(c2, WinkelTripel(T(7044801.69820402), T(5231448.051016482)))

      c1 = WinkelTripel(T(7044801.6979576545), T(5231448.051548355))
      c2 = convert(Robinson{WGS84Latest}, c1)
      @test allapprox(c2, Robinson(T(7620313.9259500755), T(4805073.646653474)))

      # different datums
      c1 = Lambert{ITRF{2008}}(T(10018754.171394622), T(4489858.886849141))
      c2 = convert(WinkelTripel{ITRFLatest}, c1)
      @test allapprox(c2, WinkelTripel{ITRFLatest}(T(7044801.699171027), T(5231448.049360464)))

      c1 = WinkelTripel{ITRF{2008}}(T(7044801.697957653), T(5231448.051548355))
      c2 = convert(Robinson{ITRFLatest}, c1)
      @test allapprox(c2, Robinson{ITRFLatest}(T(7620313.811209339), T(4805075.1317550065)))

      c1 = Lambert(T(10018754.171394622), T(4489858.8869480025))
      c2 = Lambert{ITRF{2008}}(T(10018754.171394622), T(4489858.886849141))
      @inferred convert(WinkelTripel{WGS84Latest}, c1)
      @inferred convert(WinkelTripel{ITRFLatest}, c2)
    end
  end
end
