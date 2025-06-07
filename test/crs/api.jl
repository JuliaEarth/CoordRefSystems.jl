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
    # Cartesian2D
    x = T(1) * m
    y = T(2) * m
    τx = CoordRefSystems.atol(x)
    τy = CoordRefSystems.atol(y)
    c1 = Cartesian(x, y)
    c2 = Cartesian(x + τx, y)
    c3 = Cartesian(x, y + τy)
    @test c1 ≈ c2
    @test c1 ≈ c3

    # Polar
    ρ = T(1) * m
    ϕ = T(π / 4) * rad
    τρ = CoordRefSystems.atol(ρ)
    τϕ = CoordRefSystems.atol(ϕ)
    c1 = Polar(ρ, ϕ)
    c2 = Polar(ρ + τρ, ϕ)
    c3 = Polar(ρ, ϕ + τϕ)
    @test c1 ≈ c2
    @test c1 ≈ c3

    # Cartesian3D
    x = T(1) * m
    y = T(2) * m
    z = T(3) * m
    τx = CoordRefSystems.atol(x)
    τy = CoordRefSystems.atol(y)
    τz = CoordRefSystems.atol(z)
    c1 = Cartesian(x, y, z)
    c2 = Cartesian(x + τx, y, z)
    c3 = Cartesian(x, y + τy, z)
    c4 = Cartesian(x, y, z + τz)
    @test c1 ≈ c2
    @test c1 ≈ c3
    @test c1 ≈ c4

    # Cylindrical
    ρ = T(1) * m
    ϕ = T(π / 4) * rad
    z = T(2) * m
    τρ = CoordRefSystems.atol(ρ)
    τϕ = CoordRefSystems.atol(ϕ)
    τz = CoordRefSystems.atol(z)
    c1 = Cylindrical(ρ, ϕ, z)
    c2 = Cylindrical(ρ + τρ, ϕ, z)
    c3 = Cylindrical(ρ, ϕ + τϕ, z)
    c4 = Cylindrical(ρ, ϕ, z + τz)
    @test c1 ≈ c2
    @test c1 ≈ c3
    @test c1 ≈ c4

    # Spherical
    r = T(1) * m
    θ = T(π / 4) * rad
    ϕ = T(π / 4) * rad
    τr = CoordRefSystems.atol(r)
    τθ = CoordRefSystems.atol(θ)
    τϕ = CoordRefSystems.atol(ϕ)
    c1 = Spherical(r, θ, ϕ)
    c2 = Spherical(r + τr, θ, ϕ)
    c3 = Spherical(r, θ + τθ, ϕ)
    c4 = Spherical(r, θ, ϕ + τϕ)
    @test c1 ≈ c2
    @test c1 ≈ c3
    @test c1 ≈ c4

    # Geographic 2D
    for C in geographic2D
      lat = T(30) * °
      lon = T(60) * °
      τlat = CoordRefSystems.atol(lat)
      τlon = CoordRefSystems.atol(lon)
      c1 = C(lat, lon)
      c2 = C(lat + τlat, lon)
      c3 = C(lat, lon + τlon)
      @test c1 ≈ c2
      @test c1 ≈ c3
    end

    # Geographic 3D
    for C in geographic3D
      lat = T(30) * °
      lon = T(60) * °
      alt = T(1) * m
      τlat = CoordRefSystems.atol(lat)
      τlon = CoordRefSystems.atol(lon)
      τalt = CoordRefSystems.atol(alt)
      c1 = C(lat, lon, alt)
      c2 = C(lat + τlat, lon, alt)
      c3 = C(lat, lon + τlon, alt)
      c4 = C(lat, lon, alt + τalt)
      @test c1 ≈ c2
      @test c1 ≈ c3
      @test c1 ≈ c4
    end

    # Projected
    for C in projected
      x = T(100) * m
      y = T(200) * m
      τx = CoordRefSystems.atol(x)
      τy = CoordRefSystems.atol(y)
      c1 = C(x, y)
      c2 = C(x + τx, y)
      c3 = C(x, y + τy)
      @test c1 ≈ c2
      @test c1 ≈ c3
    end

    # make sure isapprox is not too permissive
    @test !isapprox(LatLon(T(30), T(60)), AuthalicLatLon(T(30), T(60)))
    @test !isapprox(Mercator(T(300), T(300)), Robinson(T(300), T(300)))
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
