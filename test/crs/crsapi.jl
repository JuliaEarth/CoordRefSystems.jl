@testset "CRS API" begin
  ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
  TransverseMercator = CoordRefSystems.TransverseMercator{0.9996,15.0u"°",45.0u"°"}

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
    @test CoordRefSystems.values(c) == (T(1) * u"m", T(2) * u"m")
    c = Cartesian(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * u"m", T(2) * u"m", T(3) * u"m")
    c = Polar(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * u"m", T(2) * u"rad")
    c = Cylindrical(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * u"m", T(2) * u"rad", T(3) * u"m")
    c = Spherical(T(1), T(2), T(3))
    @test CoordRefSystems.values(c) == (T(1) * u"m", T(2) * u"rad", T(3) * u"rad")
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.values(c) == (T(30) * u"°", T(60) * u"°")
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.values(c) == (T(30) * u"°", T(60) * u"°", T(1) * u"m")
    c = Mercator(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * u"m", T(2) * u"m")
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.values(c) == (T(1) * u"m", T(2) * u"m")
  end

  @testset "raw" begin
    c = Cartesian(T(1), T(2))
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Cartesian(T(1) * u"cm", T(2) * u"cm", T(3) * u"cm")
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))
    c = Polar(T(1) * u"km", T(2) * u"rad")
    @test CoordRefSystems.raw(c) == (T(1), T(2))
    c = Cylindrical(T(1) * u"cm", T(2) * u"rad", T(3) * u"cm")
    @test CoordRefSystems.raw(c) == (T(1), T(2), T(3))
    c = Spherical(T(1) * u"mm", T(2) * u"rad", T(3) * u"rad")
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
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = Cartesian(T(1) * u"cm", T(1) * u"cm", T(1) * u"cm")
    @test CoordRefSystems.units(c) == (u"cm", u"cm", u"cm")
    c = Polar(T(1) * u"km", T(1) * u"rad")
    @test CoordRefSystems.units(c) == (u"km", u"rad")
    c = Cylindrical(T(1) * u"cm", T(1) * u"rad", T(1) * u"cm")
    @test CoordRefSystems.units(c) == (u"cm", u"rad", u"cm")
    c = Spherical(T(1) * u"mm", T(1) * u"rad", T(1) * u"rad")
    @test CoordRefSystems.units(c) == (u"mm", u"rad", u"rad")
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.units(c) == (u"°", u"°")
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.units(c) == (u"°", u"°", u"m")
    c = GeocentricLatLon(T(30), T(60))
    @test CoordRefSystems.units(c) == (u"°", u"°")
    c = AuthalicLatLon(T(30), T(60))
    @test CoordRefSystems.units(c) == (u"°", u"°")
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = WebMercator(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = PlateCarree(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = Lambert(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = WinkelTripel(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = Robinson(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = OrthoNorth(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = TransverseMercator(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = UTMNorth{32}(T(1), T(1))
    @test CoordRefSystems.units(c) == (u"m", u"m")
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.units(c) == (u"m", u"m")
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
          CoordRefSystems.shift(Mercator{WGS84Latest}, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
  end

  @testset "reconstruct" begin
    c = Cartesian(T(1), T(2))
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Cartesian(T(1) * u"cm", T(2) * u"cm", T(3) * u"cm")
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Polar(T(1) * u"km", T(2) * u"rad")
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Cylindrical(T(1) * u"cm", T(2) * u"rad", T(3) * u"cm")
    rv = CoordRefSystems.raw(c)
    @test CoordRefSystems.reconstruct(typeof(c), rv) == c
    c = Spherical(T(1) * u"mm", T(2) * u"rad", T(3) * u"rad")
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
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = Polar(T(1) * u"km", T(1) * u"rad")
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"km")
    c = Cylindrical(T(1) * u"cm", T(1) * u"rad", T(1) * u"cm")
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"cm")
    c = Spherical(T(1) * u"mm", T(1) * u"rad", T(1) * u"rad")
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"mm")
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = GeocentricLatLon(T(30), T(60))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = AuthalicLatLon(T(30), T(60))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = WebMercator(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = PlateCarree(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = Lambert(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = WinkelTripel(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = Robinson(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = OrthoNorth(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = TransverseMercator(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = UTMNorth{32}(T(1), T(1))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.lentype(c) == typeof(T(1) * u"m")
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
    ShiftedMercatorWGS = CoordRefSystems.shift(Mercator{WGS84{1762}}, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
    ShiftedMercatorITRF = CoordRefSystems.shift(Mercator{ITRF{2008}}, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
    isapproxtest3D(ShiftedMercatorWGS, ShiftedMercatorITRF)
  end

  @testset "tol" begin
    tol = CoordRefSystems.atol(T) * u"m"
    c = LatLon(T(1), T(1))
    @test CoordRefSystems.tol(c) == tol
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.tol(c) == tol
    c = Polar(T(1), 1.0f0)
    @test CoordRefSystems.tol(c) == tol
    c = ShiftedMercator(T(1), T(1))
    @test CoordRefSystems.tol(c) == tol
  end
end
