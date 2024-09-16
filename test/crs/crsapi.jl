@testset "CRS API" begin
  ShiftedMercator = CoordRefSystems.shift(Mercator{WGS84Latest}, lonₒ=15.0°, xₒ=200.0m, yₒ=200.0m)
  ShiftedTM = CoordRefSystems.shift(TransverseMercator{0.9996,15.0°,WGS84Latest}, lonₒ=45.0°)
  UTMNorth32 = utmnorth(32)

  @testset "datum" begin
    c = Cartesian(T(1), T(1))
    @test datum(c) === NoDatum
    c = LatLon(T(1), T(1))
    @test datum(c) === WGS84Latest
    c = LatLonAlt(T(1), T(1), T(1))
    @test datum(c) === WGS84Latest
    c = GeocentricLatLon(T(1), T(1))
    @test datum(c) === WGS84Latest
    c = GeocentricLatLonAlt(T(1), T(1), T(1))
    @test datum(c) === WGS84Latest
    c = AuthalicLatLon(T(1), T(1))
    @test datum(c) === WGS84Latest
  end

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
    c = ShiftedTM(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = UTMNorth32(T(1), T(2))
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
    c = GeocentricLatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.units(c) == (°, °, m)
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
    c = ShiftedTM(T(1), T(1))
    @test CoordRefSystems.units(c) == (m, m)
    c = UTMNorth32(T(1), T(1))
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
    @test CoordRefSystems.constructor(c) === Mercator{WGS84Latest,CoordRefSystems.Shift()}
    c = WebMercator(T(1), T(1))
    @test CoordRefSystems.constructor(c) === WebMercator{WGS84Latest,CoordRefSystems.Shift()}
    c = PlateCarree(T(1), T(1))
    @test CoordRefSystems.constructor(c) === PlateCarree{WGS84Latest,CoordRefSystems.Shift()}
    c = Lambert(T(1), T(1))
    @test CoordRefSystems.constructor(c) === Lambert{WGS84Latest,CoordRefSystems.Shift()}
    c = WinkelTripel(T(1), T(1))
    @test CoordRefSystems.constructor(c) === WinkelTripel{WGS84Latest,CoordRefSystems.Shift()}
    c = Robinson(T(1), T(1))
    @test CoordRefSystems.constructor(c) === Robinson{WGS84Latest,CoordRefSystems.Shift()}
    c = OrthoNorth(T(1), T(1))
    @test CoordRefSystems.constructor(c) === OrthoNorth{WGS84Latest,CoordRefSystems.Shift()}
    c = ShiftedTM(T(1), T(1))
    @test CoordRefSystems.constructor(c) === ShiftedTM
    c = UTMNorth32(T(1), T(1))
    @test CoordRefSystems.constructor(c) === UTMNorth32
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.constructor(c) === ShiftedMercator
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
    c = ShiftedTM(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = UTMNorth32(T(1), T(2))
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
    c = ShiftedTM(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = UTMNorth32(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * m)
  end

  @testset "mactype" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = Polar(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = Cylindrical(T(1), T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = Spherical(T(1), T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.mactype(c) == T
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = GeocentricLatLon(T(30), T(60))
    @test CoordRefSystems.mactype(c) == T
    c = AuthalicLatLon(T(30), T(60))
    @test CoordRefSystems.mactype(c) == T
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = WebMercator(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = PlateCarree(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = Lambert(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = WinkelTripel(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = Robinson(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = OrthoNorth(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = ShiftedTM(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = UTMNorth32(T(1), T(1))
    @test CoordRefSystems.mactype(c) == T
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.mactype(c) == T
  end

  @testset "equality" begin
    equaltest(Cartesian, 2)
    equaltest(Cartesian, 3)
    equaltest(Polar)
    equaltest(Cylindrical)
    equaltest(Spherical)
    equaltest(LatLon)
    equaltest(LatLonAlt)
    equaltest(GeocentricLatLon)
    equaltest(AuthalicLatLon)
    equaltest(Mercator)
    equaltest(WebMercator)
    equaltest(PlateCarree)
    equaltest(Lambert)
    equaltest(WinkelTripel)
    equaltest(Robinson)
    equaltest(OrthoNorth)
    equaltest(UTMNorth32)
    equaltest(ShiftedTM)
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
    UTMNorth32WGS = utmnorth(32, datum=WGS84{1762})
    UTMNorth32ITRF = utmnorth(32, datum=ITRF{2008})
    isapproxtest3D(UTMNorth32WGS, UTMNorth32ITRF)
    TransverseMercatorWGS = CoordRefSystems.shift(TransverseMercator{0.9996,15.0°,WGS84{1762}}, lonₒ=45.0°)
    TransverseMercatorITRF = CoordRefSystems.shift(TransverseMercator{0.9996,15.0°,ITRF{2008}}, lonₒ=45.0°)
    isapproxtest3D(TransverseMercatorWGS, TransverseMercatorITRF)
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
    c = Cartesian(T(1), T(1))
    @test convert(Cartesian, c) === c
    c = LatLon(T(45), T(90))
    @test convert(LatLon, c) === c
    c = OrthoNorth(T(1), T(1))
    @test convert(OrthoNorth, c) === c

    # error: conversion not defined
    C = typeof(Spherical(T(0), T(0), T(0)))
    c = Mercator(T(1), T(1))
    @test_throws ArgumentError convert(C, c)

    # type stability
    C = typeof(Mercator(T(0), T(0)))
    c1 = LatLon(45.0, 90.0)
    c2 = LatLon(45.0f0, 90.0f0)
    c3 = Cartesian(T(1), T(1))
    @inferred convert(C, c1)
    @inferred convert(C, c2)
    @inferred convert(Cartesian, c3)
  end
end
