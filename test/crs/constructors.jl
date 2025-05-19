@testset "Constructors" begin
  @testset "Basic" begin
    # Cartesian
    @test Cartesian(T(1)) == Cartesian(T(1) * m)
    @test Cartesian(T(1), T(2)) == Cartesian(T(1) * m, T(2) * m)
    @test Cartesian(T(1), T(2), T(3)) == Cartesian(T(1) * m, T(2) * m, T(3) * m)
    @test Cartesian(T(1) * m, 2 * m) == Cartesian(T(1) * m, T(2) * m)
    @test Cartesian((T(1), T(2))) == Cartesian((T(1) * m, T(2) * m))
    @test Cartesian((T(1), T(2), T(3))) == Cartesian((T(1) * m, T(2) * m, T(3) * m))
    @test Cartesian((T(1) * m, 2 * m)) == Cartesian((T(1) * m, T(2) * m))
    @test Cartesian2D(T(1), T(2)) == Cartesian(T(1) * m, T(2) * m)
    @test Cartesian2D(T(1) * m, 2 * m) == Cartesian(T(1) * m, T(2) * m)
    @test Cartesian3D(T(1), T(2), T(3)) == Cartesian(T(1) * m, T(2) * m, T(3) * m)
    @test Cartesian3D(T(1) * m, T(2) * m, 3 * m) == Cartesian(T(1) * m, T(2) * m, T(3) * m)

    c = Cartesian(T(1))
    @test sprint(show, c) == "Cartesian{NoDatum}(x: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      └─ x: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      └─ x: 1.0 m"""
    end

    c = Cartesian(T(1), T(2))
    @test sprint(show, c) == "Cartesian{NoDatum}(x: 1.0 m, y: 2.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0f0 m
      └─ y: 2.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0 m
      └─ y: 2.0 m"""
    end

    c = Cartesian(T(1), T(2), T(3))
    @test sprint(show, c) == "Cartesian{NoDatum}(x: 1.0 m, y: 2.0 m, z: 3.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0f0 m
      ├─ y: 2.0f0 m
      └─ z: 3.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0 m
      ├─ y: 2.0 m
      └─ z: 3.0 m"""
    end

    c = Cartesian(T(1), T(2), T(3), T(4))
    @test sprint(show, c) == "Cartesian{NoDatum}(x1: 1.0 m, x2: 2.0 m, x3: 3.0 m, x4: 4.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x1: 1.0f0 m
      ├─ x2: 2.0f0 m
      ├─ x3: 3.0f0 m
      └─ x4: 4.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x1: 1.0 m
      ├─ x2: 2.0 m
      ├─ x3: 3.0 m
      └─ x4: 4.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Cartesian(T(1), T(2) * m)
    @test_throws ArgumentError Cartesian(T(1) * s, T(2) * m)
    @test_throws ArgumentError Cartesian(T(1) * m, T(2) * s)
    @test_throws ArgumentError Cartesian(T(1) * s, T(2) * s)

    # Polar
    @test Polar(T(1), T(2)) == Polar(T(1) * m, T(2) * rad)
    @test isclose(Polar(T(1) * m, T(45) * °), Polar(T(1) * m, T(π / 4) * rad))

    c = Polar(T(1), T(2))
    @test sprint(show, c) == "Polar{NoDatum}(ρ: 1.0 m, ϕ: 2.0 rad)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Polar{NoDatum} coordinates
      ├─ ρ: 1.0f0 m
      └─ ϕ: 2.0f0 rad"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Polar{NoDatum} coordinates
      ├─ ρ: 1.0 m
      └─ ϕ: 2.0 rad"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Polar(T(1), T(2) * rad)
    @test_throws ArgumentError Polar(T(1) * s, T(2) * rad)
    @test_throws ArgumentError Polar(T(1) * m, T(2) * s)
    @test_throws ArgumentError Polar(T(1) * s, T(2) * s)

    # Cylindrical
    @test Cylindrical(T(1), T(2), T(3)) == Cylindrical(T(1) * m, T(2) * rad, T(3) * m)
    @test Cylindrical(T(1) * m, T(2) * rad, 3 * m) == Cylindrical(T(1) * m, T(2) * rad, T(3) * m)
    @test isclose(Cylindrical(T(1) * m, T(45) * °, T(1) * m), Cylindrical(T(1) * m, T(π / 4) * rad, T(1) * m))

    c = Cylindrical(T(1), T(2), T(3))
    @test sprint(show, c) == "Cylindrical{NoDatum}(ρ: 1.0 m, ϕ: 2.0 rad, z: 3.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cylindrical{NoDatum} coordinates
      ├─ ρ: 1.0f0 m
      ├─ ϕ: 2.0f0 rad
      └─ z: 3.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cylindrical{NoDatum} coordinates
      ├─ ρ: 1.0 m
      ├─ ϕ: 2.0 rad
      └─ z: 3.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Cylindrical(T(1), T(2) * rad, T(3))
    @test_throws ArgumentError Cylindrical(T(1) * s, T(2) * rad, T(3) * m)
    @test_throws ArgumentError Cylindrical(T(1) * m, T(2) * s, T(3) * m)
    @test_throws ArgumentError Cylindrical(T(1) * m, T(2) * rad, T(3) * s)
    @test_throws ArgumentError Cylindrical(T(1) * s, T(2) * s, T(3) * s)

    # Spherical
    @test Spherical(T(1), T(2), T(3)) == Spherical(T(1) * m, T(2) * rad, T(3) * rad)
    @test Spherical(T(1) * m, T(2) * rad, 3 * rad) == Spherical(T(1) * m, T(2) * rad, T(3) * rad)
    @test isclose(Spherical(T(1) * m, T(45) * °, T(45) * °), Spherical(T(1) * m, T(π / 4) * rad, T(π / 4) * rad))

    c = Spherical(T(1), T(2), T(3))
    @test sprint(show, c) == "Spherical{NoDatum}(r: 1.0 m, θ: 2.0 rad, ϕ: 3.0 rad)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Spherical{NoDatum} coordinates
      ├─ r: 1.0f0 m
      ├─ θ: 2.0f0 rad
      └─ ϕ: 3.0f0 rad"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Spherical{NoDatum} coordinates
      ├─ r: 1.0 m
      ├─ θ: 2.0 rad
      └─ ϕ: 3.0 rad"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Spherical(T(1) * m, T(2), T(3))
    @test_throws ArgumentError Spherical(T(1) * s, T(2) * rad, T(3) * rad)
    @test_throws ArgumentError Spherical(T(1) * m, T(2) * s, T(3) * rad)
    @test_throws ArgumentError Spherical(T(1) * m, T(2) * rad, T(3) * s)
    @test_throws ArgumentError Spherical(T(1) * s, T(2) * s, T(3) * s)
  end

  @testset "Geographic" begin
    for C in geographic2D
      @test C(T(1), T(2)) == C(T(1) * °, T(2) * °)
      @test C(T(1) * °, 2 * °) == C(T(1) * °, T(2) * °)
      @test isclose(C(T(π / 4) * rad, T(π / 4) * rad), C(T(45) * °, T(45) * °))

      # fix longitude
      @test C(T(0), T(225)) == C(T(0), T(-135))
      @test C(T(0), T(270)) == C(T(0), T(-90))
      @test C(T(0), T(315)) == C(T(0), T(-45))
      @test C(T(0), T(-225)) == C(T(0), T(135))
      @test C(T(0), T(-270)) == C(T(0), T(90))
      @test C(T(0), T(-315)) == C(T(0), T(45))
      @test C(T(0), T(405)) == C(T(0), T(45))
      @test C(T(0), T(765)) == C(T(0), T(45))

      c = C(T(1), T(2))
      nm = CoordRefSystems.prettyname(C)
      @test sprint(show, c) == "$nm{WGS84Latest}(lat: 1.0°, lon: 2.0°)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        $nm{WGS84Latest} coordinates
        ├─ lat: 1.0f0°
        └─ lon: 2.0f0°"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        $nm{WGS84Latest} coordinates
        ├─ lat: 1.0°
        └─ lon: 2.0°"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError C(T(1), T(1) * °)
      @test_throws ArgumentError C(T(1) * s, T(1) * °)
      @test_throws ArgumentError C(T(1) * °, T(1) * s)
      @test_throws ArgumentError C(T(1) * s, T(1) * s)

      # error: latitude above 90° or below -90°
      @test_throws ArgumentError C(T(91), T(0))
      @test_throws ArgumentError C(T(-91), T(0))
    end

    for C in geographic3D
      @test C(T(1), T(2), T(3)) == C(T(1) * °, T(2) * °, T(3) * m)
      @test C(T(1) * °, 2 * °, T(3) * m) == C(T(1) * °, T(2) * °, T(3) * m)
      @test isclose(C(T(π / 4) * rad, T(π / 4) * rad, T(1) * km), C(T(45) * °, T(45) * °, T(1000) * m))

      # fix longitude
      @test C(T(0), T(225), T(0)) == C(T(0), T(-135), T(0))
      @test C(T(0), T(270), T(0)) == C(T(0), T(-90), T(0))
      @test C(T(0), T(315), T(0)) == C(T(0), T(-45), T(0))
      @test C(T(0), T(-225), T(0)) == C(T(0), T(135), T(0))
      @test C(T(0), T(-270), T(0)) == C(T(0), T(90), T(0))
      @test C(T(0), T(-315), T(0)) == C(T(0), T(45), T(0))
      @test C(T(0), T(405), T(0)) == C(T(0), T(45), T(0))
      @test C(T(0), T(765), T(0)) == C(T(0), T(45), T(0))

      c = C(T(1), T(2), T(3))
      nm = CoordRefSystems.prettyname(C)
      @test sprint(show, c) == "$nm{WGS84Latest}(lat: 1.0°, lon: 2.0°, alt: 3.0 m)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        $nm{WGS84Latest} coordinates
        ├─ lat: 1.0f0°
        ├─ lon: 2.0f0°
        └─ alt: 3.0f0 m"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        $nm{WGS84Latest} coordinates
        ├─ lat: 1.0°
        ├─ lon: 2.0°
        └─ alt: 3.0 m"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError C(T(1), T(2) * °, T(3) * m)
      @test_throws ArgumentError C(T(1) * s, T(2) * °, T(3) * m)
      @test_throws ArgumentError C(T(1) * °, T(2) * s, T(3) * m)
      @test_throws ArgumentError C(T(1) * °, T(2) * °, T(3) * s)
      @test_throws ArgumentError C(T(1) * s, T(2) * s, T(3) * s)

      # error: latitude above 90° or below -90°
      @test_throws ArgumentError C(T(91), T(0), T(0))
      @test_throws ArgumentError C(T(-91), T(0), T(0))
    end
  end

  @testset "Projected" begin
    for C in projected
      @test C(T(1), T(2)) == C(T(1) * m, T(2) * m)
      @test C(T(1) * m, 2 * m) == C(T(1) * m, T(2) * m)
      @test C(T(1) * km, T(2) * km) == C(T(1000) * m, T(2000) * m)

      c = C(T(1), T(2))
      nm = CoordRefSystems.prettyname(C)
      @test sprint(show, c) == "$nm{WGS84Latest}(x: 1.0 m, y: 2.0 m)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        $nm{WGS84Latest} coordinates
        ├─ x: 1.0f0 m
        └─ y: 2.0f0 m"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        $nm{WGS84Latest} coordinates
        ├─ x: 1.0 m
        └─ y: 2.0 m"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError C(T(1), T(2) * m)
      @test_throws ArgumentError C(T(1) * s, T(2) * m)
      @test_throws ArgumentError C(T(1) * m, T(2) * s)
      @test_throws ArgumentError C(T(1) * s, T(2) * s)
    end

    ShiftedMercator = CoordRefSystems.shift(Mercator{WGS84Latest}, lonₒ=15.0°, xₒ=200.0m, yₒ=200.0m)
    c = ShiftedMercator(T(1), T(2))
    @test sprint(show, c) == "Mercator{WGS84Latest}(x: 1.0 m, y: 2.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Mercator{WGS84Latest} coordinates with lonₒ: 15.0°, xₒ: 200.0 m, yₒ: 200.0 m
      ├─ x: 1.0f0 m
      └─ y: 2.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Mercator{WGS84Latest} coordinates with lonₒ: 15.0°, xₒ: 200.0 m, yₒ: 200.0 m
      ├─ x: 1.0 m
      └─ y: 2.0 m"""
    end
  end
end
