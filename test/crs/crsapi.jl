@testset "CRS API" begin
  @testset "datum" begin
    for C in basic2D
      c = C(T(1), T(2))
      @test datum(c) === NoDatum
    end

    for C in basic3D
      c = C(T(1), T(2), T(3))
      @test datum(c) === NoDatum
      c = C{WGS84Latest}(T(1), T(2), T(3))
      @test datum(c) === WGS84Latest
    end

    for C in geographic2D
      c = C(T(30), T(60))
      @test datum(c) === WGS84Latest
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test datum(c) === WGS84Latest
    end

    for C in projected
      c = C(T(1), T(2))
      @test datum(c) === WGS84Latest
    end
  end

  @testset "ncoords" begin
    for C in [basic2D; geographic2D; projected]
      c = C(T(1), T(2))
      @test CoordRefSystems.ncoords(C) == 2
      @test CoordRefSystems.ncoords(c) == 2
    end

    for C in [basic3D; geographic3D]
      c = C(T(1), T(2), T(3))
      @test CoordRefSystems.ncoords(C) == 3
      @test CoordRefSystems.ncoords(c) == 3
    end
  end

  @testset "ndims" begin
    for C in basic2D
      c = C(T(1), T(2))
      @test CoordRefSystems.ndims(C) == 2
      @test CoordRefSystems.ndims(c) == 2
    end

    for C in basic3D
      c = C(T(1), T(2), T(3))
      @test CoordRefSystems.ndims(C) == 3
      @test CoordRefSystems.ndims(c) == 3
    end

    for C in geographic2D
      c = C(T(30), T(60))
      @test CoordRefSystems.ndims(C) == 3
      @test CoordRefSystems.ndims(c) == 3
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test CoordRefSystems.ndims(C) == 3
      @test CoordRefSystems.ndims(c) == 3
    end

    for C in projected
      c = C(T(1), T(2))
      @test CoordRefSystems.ndims(C) == 2
      @test CoordRefSystems.ndims(c) == 2
    end
  end

  @testset "names" begin
    c = Cartesian(T(1), T(2))
    @test CoordRefSystems.names(c) == (:x, :y)
    c = Polar(T(1), T(2))
    @test CoordRefSystems.names(c) == (:ρ, :ϕ)
    c = Cartesian(T(1), T(2), T(3))
    @test CoordRefSystems.names(c) == (:x, :y, :z)
    c = Cylindrical(T(1), T(2), T(3))
    @test CoordRefSystems.names(c) == (:ρ, :ϕ, :z)
    c = Spherical(T(1), T(2), T(3))
    @test CoordRefSystems.names(c) == (:r, :θ, :ϕ)

    for C in geographic2D
      c = C(T(30), T(60))
      @test CoordRefSystems.names(c) == (:lat, :lon)
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test CoordRefSystems.names(c) == (:lat, :lon, :alt)
    end

    for C in projected
      c = C(T(1), T(2))
      @test CoordRefSystems.names(c) == (:x, :y)
    end
  end

  @testset "values" begin
    c = Cartesian(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * m)
    c = Polar(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * rad)
    c = Cartesian(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * m, T(3) * m)
    c = Cylindrical(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * rad, T(3) * m)
    c = Spherical(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * rad, T(3) * rad)

    for C in geographic2D
      c = C(T(30), T(60))
      @test CoordRefSystems.values(c) == (T(30) * °, T(60) * °)
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test CoordRefSystems.values(c) == (T(30) * °, T(60) * °, T(1) * m)
    end

    for C in projected
      c = C(T(1), T(2))
      @test CoordRefSystems.values(c) == (T(1) * m, T(2) * m)
    end
  end

  @testset "raw" begin
    c = Cartesian(T(1) * mm, T(2) * mm)
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Polar(T(1) * km, T(2) * rad)
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Cartesian(T(1) * cm, T(2) * cm, T(3) * cm)
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))
    c = Cylindrical(T(1) * cm, T(2) * rad, T(3) * cm)
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))
    c = Spherical(T(1) * mm, T(2) * rad, T(3) * rad)
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))

    for C in geographic2D
      c = C(T(30), T(60))
      @test CoordRefSystems.raw(c) == (T(60), T(30))
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test CoordRefSystems.raw(c) == (T(60), T(30), T(1))
    end

    for C in projected
      c = C(T(1), T(2))
      @test CoordRefSystems.raw(c) == (T(1), T(2))
    end
  end

  @testset "units" begin
    c = Cartesian(T(1) * mm, T(1) * mm)
    @test CoordRefSystems.units(c) == (mm, mm)
    c = Polar(T(1) * km, T(1) * rad)
    @test CoordRefSystems.units(c) == (km, rad)
    c = Cartesian(T(1) * cm, T(1) * cm, T(1) * cm)
    @test CoordRefSystems.units(c) == (cm, cm, cm)
    c = Cylindrical(T(1) * cm, T(1) * rad, T(1) * cm)
    @test CoordRefSystems.units(c) == (cm, rad, cm)
    c = Spherical(T(1) * mm, T(1) * rad, T(1) * rad)
    @test CoordRefSystems.units(c) == (mm, rad, rad)

    for C in geographic2D
      c = C(T(30), T(60))
      @test CoordRefSystems.units(c) == (°, °)
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test CoordRefSystems.units(c) == (°, °, m)
    end

    for C in projected
      c = C(T(1), T(2))
      @test CoordRefSystems.units(c) == (m, m)
    end
  end

  @testset "constructor" begin
    c = Cartesian(T(1), T(2))
    @test CoordRefSystems.constructor(c) === Cartesian{NoDatum}
    c = Polar(T(1), T(2))
    @test CoordRefSystems.constructor(c) === Polar{NoDatum}
    c = Cartesian(T(1), T(2), T(3))
    @test CoordRefSystems.constructor(c) === Cartesian{NoDatum}
    c = Cylindrical(T(1), T(2), T(3))
    @test CoordRefSystems.constructor(c) === Cylindrical{NoDatum}
    c = Spherical(T(1), T(2), T(3))
    @test CoordRefSystems.constructor(c) === Spherical{NoDatum}

    for C in geographic2D
      c = C(T(30), T(60))
      @test CoordRefSystems.constructor(c) === C{WGS84Latest}
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test CoordRefSystems.constructor(c) === C{WGS84Latest}
    end

    for C in projected
      c = C(T(1), T(2))
      @test CoordRefSystems.constructor(c) === C{WGS84Latest,CoordRefSystems.Shift()}
    end
  end

  @testset "reconstruct" begin
    c = Cartesian(T(1) * mm, T(2) * mm)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Polar(T(1) * km, T(2) * rad)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Cartesian(T(1) * cm, T(2) * cm, T(3) * cm)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Cylindrical(T(1) * cm, T(2) * rad, T(3) * cm)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Spherical(T(1) * mm, T(2) * rad, T(3) * rad)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c

    for C in geographic2D
      c = C(T(30), T(60))
      rv = CoordRefSystems.raw(c)
      @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      rv = CoordRefSystems.raw(c)
      @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    end

    for C in projected
      c = C(T(1), T(2))
      rv = CoordRefSystems.raw(c)
      @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    end
  end

  @testset "lentype" begin
    c = Cartesian(T(1) * mm, T(2) * mm)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * mm)
    c = Polar(T(1) * km, T(2) * rad)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * km)
    c = Cartesian(T(1) * mm, T(2) * mm, T(3) * mm)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * mm)
    c = Cylindrical(T(1) * cm, T(2) * rad, T(3) * cm)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * cm)
    c = Spherical(T(1) * mm, T(3) * rad, T(3) * rad)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * mm)

    for C in geographic2D
      c = C(T(30), T(60))
      @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    end

    for C in geographic3D
      c = C(T(30), T(60), T(1))
      @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    end

    for C in projected
      c = C(T(1), T(2))
      @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    end
  end

  @testset "mactype" begin
    for C in [basic2D; geographic2D; projected]
      c = C(T(1), T(2))
      @test CoordRefSystems.mactype(c) == T
    end

    for C in [basic3D; geographic3D]
      c = C(T(1), T(2), T(3))
      @test CoordRefSystems.mactype(c) == T
    end
  end

  @testset "isequal" begin
    for C in [basic; geographic; projected]
      isequaltest(C)
    end
  end

  @testset "isapprox" begin
    isapproxtest2D(Cartesian)
    isapproxtest2D(Polar)

    isapproxtest3D(Cartesian)
    isapproxtest3D(Cylindrical)
    isapproxtest3D(Spherical)

    for C in [geographic; projected]
      # TODO conversion from `AuthalicLatLon` to `Cartesian` is not defined
      if !(C <: AuthalicLatLon)
        isapproxtest3D(C)
      end
    end
  end

  @testset "convert fallback" begin
    # concrete type
    C = typeof(Polar(T(0), T(0)))
    c1 = Cartesian(1.0, 1.0)
    c2 = Cartesian(1.0f0, 1.0f0)
    @test typeof(convert(C, c1)) === C
    @test typeof(convert(C, c2)) === C
    C = typeof(Mercator(T(0), T(0)))
    c1 = LatLon(45.0, 90.0)
    c2 = LatLon(45.0f0, 90.0f0)
    @test typeof(convert(C, c1)) === C
    @test typeof(convert(C, c2)) === C
    c1 = GeocentricLatLon(45.0, 90.0)
    c2 = GeocentricLatLon(45.0f0, 90.0f0)
    @test typeof(convert(C, c1)) === C
    @test typeof(convert(C, c2)) === C

    C = typeof(PlateCarree(T(0), T(0)))
    c1 = Cartesian(1.0, 1.0)
    c2 = Cartesian(1.0f0, 1.0f0)
    @test typeof(convert(C, c1)) === C
    @test typeof(convert(C, c2)) === C

    # unit conversion
    c1 = Cartesian(T(1000) * mm, T(1000) * mm)
    c2 = Cartesian(T(100) * cm, T(100) * cm)
    c3 = Cartesian(T(1) * m, T(1) * m)
    C = typeof(c1)
    c4 = convert(C, c2)
    c5 = convert(C, c3)
    @test typeof(c4) === C
    @test c4 ≈ c1
    @test typeof(c5) === C
    @test c5 ≈ c1

    # same type
    c = Cartesian(T(1), T(2))
    @test convert(Cartesian, c) === c
    c = LatLon(T(45), T(90))
    @test convert(LatLon, c) === c
    c = LatLonAlt(T(45), T(90), T(1))
    @test convert(LatLonAlt, c) === c
    c = GeocentricLatLon(T(45), T(90))
    @test convert(GeocentricLatLon, c) === c
    c = GeocentricLatLonAlt(T(45), T(90), T(1))
    @test convert(GeocentricLatLonAlt, c) === c
    c = OrthoNorth(T(1), T(2))
    @test convert(OrthoNorth, c) === c

    # error: conversion not defined
    C = typeof(Spherical(T(0), T(0), T(0)))
    c = Mercator(T(1), T(2))
    @test_throws ArgumentError convert(C, c)

    # type stability
    C = typeof(Mercator(T(0), T(0)))
    c1 = LatLon(45.0, 90.0)
    c2 = LatLon(45.0f0, 90.0f0)
    c3 = Cartesian(T(1), T(2))
    @inferred convert(C, c1)
    @inferred convert(C, c2)
    @inferred convert(Cartesian, c3)
    c1 = GeocentricLatLon(45.0, 90.0)
    c2 = GeocentricLatLon(45.0f0, 90.0f0)
    @inferred convert(C, c1)
    @inferred convert(C, c2)
  end
end
