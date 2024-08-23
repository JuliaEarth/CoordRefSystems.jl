@testset "CRS API" begin
  ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0°, xₒ=200.0m, yₒ=200.0m)
  TransverseMercator = CoordRefSystems.TransverseMercator{0.9996,15.0°,45.0°}

  @testset "ncoords" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 2
    @test CoordRefSystems.ncoords(Cartesian2D) == 2
    c = Cartesian(T(1), T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 3
    @test CoordRefSystems.ncoords(Cartesian3D) == 3
    c = Polar(T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 2
    c = Cylindrical(T(1), T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 3
    c = Spherical(T(1), T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 3
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.ncoords(c) == 2
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.ncoords(c) == 3
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 2
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.ncoords(c) == 2
  end

  @testset "ndims" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.ndims(c) == 2
    @test CoordRefSystems.ndims(Cartesian2D) == 2
    c = Cartesian(T(1), T(1), T(1))
    @test CoordRefSystems.ndims(c) == 3
    @test CoordRefSystems.ndims(Cartesian3D) == 3
    c = Polar(T(1), T(1))
    @test CoordRefSystems.ndims(c) == 2
    c = Cylindrical(T(1), T(1), T(1))
    @test CoordRefSystems.ndims(c) == 3
    c = Spherical(T(1), T(1), T(1))
    @test CoordRefSystems.ndims(c) == 3
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.ndims(c) == 3
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.ndims(c) == 3
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.ndims(c) == 2
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.ndims(c) == 2
  end

  @testset "names" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.names(c) == (:x, :y)
    c = Cartesian(T(1), T(1), T(1))
    @test CoordRefSystems.names(c) == (:x, :y, :z)
    c = Polar(T(1), T(1))
    @test CoordRefSystems.names(c) == (:ρ, :ϕ)
    c = Cylindrical(T(1), T(1), T(1))
    @test CoordRefSystems.names(c) == (:ρ, :ϕ, :z)
    c = Spherical(T(1), T(1), T(1))
    @test CoordRefSystems.names(c) == (:r, :θ, :ϕ)
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.names(c) == (:lat, :lon)
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.names(c) == (:lat, :lon, :alt)
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.names(c) == (:x, :y)
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.names(c) == (:x, :y)
  end

  @testset "values" begin
    c = Cartesian(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * m)
    c = Cartesian(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * m, T(3) * m)
    c = Polar(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * rad)
    c = Cylindrical(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * rad, T(3) * m)
    c = Spherical(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * rad, T(3) * rad)
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.values(c) == (T(30) * °, T(60) * °)
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.values(c) == (T(30) * °, T(60) * °, T(1) * m)
    c = Mercator(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * m)
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * m, T(2) * m)
  end

  @testset "raw" begin
    c = Cartesian(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Cartesian(T(1) * cm, T(2) * cm, T(3) * cm)
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))
    c = Polar(T(1) * km, T(2) * rad)
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Cylindrical(T(1) * cm, T(2) * rad, T(3) * cm)
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))
    c = Spherical(T(1) * mm, T(2) * rad, T(3) * rad)
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.raw(c) == (T(60), T(30))
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.raw(c) == (T(60), T(30), T(1))
    c = GeocentricLatLon(T(30), T(60))
    @test CoordRefSystems.raw(c) == (T(60), T(30))
    c = AuthalicLatLon(T(30), T(60))
    @test CoordRefSystems.raw(c) == (T(60), T(30))
    c = Mercator(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = WebMercator(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = PlateCarree(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Lambert(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = WinkelTripel(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Robinson(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = OrthoNorth(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = TransverseMercator(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = UTMNorth{32}(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
  end

  @testset "units" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = Cartesian(T(1) * cm, T(1) * cm, T(1) * cm)
    @test CoordRefSystems.units(c) == (cm, cm, cm)
    c = Polar(T(1) * km, T(1) * rad)
    @test CoordRefSystems.units(c) == (km, rad)
    c = Cylindrical(T(1) * cm, T(1) * rad, T(1) * cm)
    @test CoordRefSystems.units(c) == (cm, rad, cm)
    c = Spherical(T(1) * mm, T(1) * rad, T(1) * rad)
    @test CoordRefSystems.units(c) == (mm, rad, rad)
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.units(c) == (°, °)
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.units(c) == (°, °, m)
    c = GeocentricLatLon(T(30), T(60))
    @test CoordRefSystems.units(c) == (°, °)
    c = AuthalicLatLon(T(30), T(60))
    @test CoordRefSystems.units(c) == (°, °)
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = WebMercator(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = PlateCarree(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = Lambert(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = WinkelTripel(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = Robinson(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = OrthoNorth(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = TransverseMercator(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = UTMNorth{32}(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.units(c) == (m, m)
  end

  @testset "constructor" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.constructor(c) === Cartesian{NoDatum}
    c = Polar(T(1), T(1))
    @test CoordRefSystems.constructor(c) === Polar{NoDatum}
    c = Cylindrical(T(1), T(1), T(1))
    @test CoordRefSystems.constructor(c) === Cylindrical{NoDatum}
    c = Spherical(T(1), T(1), T(1))
    @test CoordRefSystems.constructor(c) === Spherical{NoDatum}
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.constructor(c) === LatLon{WGS84Latest}
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.constructor(c) === LatLonAlt{WGS84Latest}
    c = GeocentricLatLon(T(30), T(60))
    @test CoordRefSystems.constructor(c) === GeocentricLatLon{WGS84Latest}
    c = AuthalicLatLon(T(30), T(60))
    @test CoordRefSystems.constructor(c) === AuthalicLatLon{WGS84Latest}
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.constructor(c) === Mercator{WGS84Latest}
    c = WebMercator(T(1), T(1))
    @test CoordRefSystems.constructor(c) === WebMercator{WGS84Latest}
    c = PlateCarree(T(1), T(1))
    @test CoordRefSystems.constructor(c) === PlateCarree{WGS84Latest}
    c = Lambert(T(1), T(1))
    @test CoordRefSystems.constructor(c) === Lambert{WGS84Latest}
    c = WinkelTripel(T(1), T(1))
    @test CoordRefSystems.constructor(c) === WinkelTripel{WGS84Latest}
    c = Robinson(T(1), T(1))
    @test CoordRefSystems.constructor(c) === Robinson{WGS84Latest}
    c = OrthoNorth(T(1), T(1))
    @test CoordRefSystems.constructor(c) === OrthoNorth{WGS84Latest}
    c = TransverseMercator(T(1), T(1))
    @test CoordRefSystems.constructor(c) === TransverseMercator{WGS84Latest}
    c = UTMNorth{32}(T(1), T(1))
    @test CoordRefSystems.constructor(c) === UTMNorth{32,WGS84Latest}
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.constructor(c) ===
          CoordRefSystems.shift(Mercator{WGS84Latest}, lonₒ=15.0°, xₒ=200.0m, yₒ=200.0m)
  end

  @testset "reconstruct" begin
    c = Cartesian(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Cartesian(T(1) * cm, T(2) * cm, T(3) * cm)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Polar(T(1) * km, T(2) * rad)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Cylindrical(T(1) * cm, T(2) * rad, T(3) * cm)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Spherical(T(1) * mm, T(2) * rad, T(3) * rad)
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = LatLon(T(30), T(60))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = LatLonAlt(T(30), T(60), T(1))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = GeocentricLatLon(T(30), T(60))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = AuthalicLatLon(T(30), T(60))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Mercator(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = WebMercator(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = PlateCarree(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Lambert(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = WinkelTripel(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Robinson(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = OrthoNorth(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = TransverseMercator(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = UTMNorth{32}(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = ShiftedMercator(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
  end

  @testset "lentype" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = Polar(T(1) * km, T(1) * rad)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * km)
    c = Cylindrical(T(1) * cm, T(1) * rad, T(1) * cm)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * cm)
    c = Spherical(T(1) * mm, T(1) * rad, T(1) * rad)
    @test CoordRefSystems.lentype(c) == typeof(T(1) * mm)
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = GeocentricLatLon(T(30), T(60))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = AuthalicLatLon(T(30), T(60))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = WebMercator(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = PlateCarree(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = Lambert(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = WinkelTripel(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = Robinson(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = OrthoNorth(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = TransverseMercator(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = UTMNorth{32}(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
  end

  @testset "datum" begin
    c = Cartesian(T(1), T(1))
    @test datum(c) === NoDatum
    c = LatLon(T(1), T(1))
    @test datum(c) === WGS84Latest
  end

  @testset "equality operator" begin
    equaltest(Cartesian, 2)
    equaltest(Cartesian, 3)
    equaltest(Polar)
    equaltest(Cylindrical)
    equaltest(Spherical)
    equaltest(LatLon)
    @test LatLon(T(0), T(180)) == LatLon(T(0), T(-180))
    equaltest(LatLonAlt)
    @test LatLonAlt(T(0), T(180), T(0)) == LatLonAlt(T(0), T(-180), T(0))
    equaltest(GeocentricLatLon)
    @test GeocentricLatLon(T(0), T(180)) == GeocentricLatLon(T(0), T(-180))
    equaltest(AuthalicLatLon)
    @test AuthalicLatLon(T(0), T(180)) == AuthalicLatLon(T(0), T(-180))
    equaltest(Mercator)
    equaltest(WebMercator)
    equaltest(PlateCarree)
    equaltest(Lambert)
    equaltest(WinkelTripel)
    equaltest(Robinson)
    equaltest(OrthoNorth)
    equaltest(UTMNorth{38})
    equaltest(TransverseMercator)
    equaltest(ShiftedMercator)
  end

  @testset "isapprox" begin
    isapproxtest2D(Cartesian)
    isapproxtest3D(Cartesian)
    isapproxtest2D(Polar)
    isapproxtest3D(Cylindrical)
    isapproxtest3D(Spherical)
    isapproxtest3D(LatLon)
    isapproxtest3D(LatLonAlt)
    isapproxtest3D(Mercator)
    isapproxtest3D(WebMercator)
    isapproxtest3D(PlateCarree)
    isapproxtest3D(Lambert)
    isapproxtest3D(WinkelTripel)
    isapproxtest3D(Robinson)
    isapproxtest3D(OrthoNorth)
    isapproxtest3D(UTMNorth{38})
    isapproxtest3D(TransverseMercator)
    ShiftedMercatorWGS = CoordRefSystems.shift(Mercator{WGS84{1762}}, lonₒ=15.0°, xₒ=200.0m, yₒ=200.0m)
    ShiftedMercatorITRF = CoordRefSystems.shift(Mercator{ITRF{2008}}, lonₒ=15.0°, xₒ=200.0m, yₒ=200.0m)
    isapproxtest3D(ShiftedMercatorWGS, ShiftedMercatorITRF)
  end

  @testset "tol" begin
    tol = CoordRefSystems.atol(T) * m
    c = LatLon(T(1), T(1))
    @test CoordRefSystems.tol(c) == tol
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.tol(c) == tol
    c = Polar(T(1), 1.0f0)
    @test CoordRefSystems.tol(c) == tol
    c = ShiftedMercator(T(1), T(1))
    @test CoordRefSystems.tol(c) == tol
  end

  @testset "convert fallback" begin
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
    C = typeof(PlateCarree(T(0), T(0)))
    c1 = Cartesian(1.0, 1.0)
    c2 = Cartesian(1.0f0, 1.0f0)
    @test typeof(convert(C, c1)) === C
    @test typeof(convert(C, c2)) === C

    # error: conversion not defined
    C = typeof(Spherical(T(0), T(0), T(0)))
    c = Mercator(T(1), T(1))
    @test_throws ArgumentError convert(C, c)
  end
end
