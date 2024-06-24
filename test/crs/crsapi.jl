@testset "CRS API" begin
  ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
  TransverseMercator = CoordRefSystems.TransverseMercator{0.9996,15.0u"°",45.0u"°"}

  @testset "ncoords" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 2
    c = Cartesian(T(1), T(1), T(1))
    @test CoordRefSystems.ncoords(c) == 3
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

  @testset "cvalues" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.cvalues(c) == (T(1) * u"m", T(1) * u"m")
    c = Cartesian(T(1), T(1), T(1))
    @test CoordRefSystems.cvalues(c) == (T(1) * u"m", T(1) * u"m", T(1) * u"m")
    c = Polar(T(1), T(1))
    @test CoordRefSystems.cvalues(c) == (T(1) * u"m", T(1) * u"rad")
    c = Cylindrical(T(1), T(1), T(1))
    @test CoordRefSystems.cvalues(c) == (T(1) * u"m", T(1) * u"rad", T(1) * u"m")
    c = Spherical(T(1), T(1), T(1))
    @test CoordRefSystems.cvalues(c) == (T(1) * u"m", T(1) * u"rad", T(1) * u"rad")
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.cvalues(c) == (T(30) * u"°", T(60) * u"°")
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.cvalues(c) == (T(30) * u"°", T(60) * u"°", T(1) * u"m")
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.cvalues(c) == (T(1) * u"m", T(1) * u"m")
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.cvalues(c) == (T(1) * u"m", T(2) * u"m")
  end

  @testset "cnames" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.cnames(c) == (:x, :y)
    c = Cartesian(T(1), T(1), T(1))
    @test CoordRefSystems.cnames(c) == (:x, :y, :z)
    c = Polar(T(1), T(1))
    @test CoordRefSystems.cnames(c) == (:ρ, :ϕ)
    c = Cylindrical(T(1), T(1), T(1))
    @test CoordRefSystems.cnames(c) == (:ρ, :ϕ, :z)
    c = Spherical(T(1), T(1), T(1))
    @test CoordRefSystems.cnames(c) == (:r, :θ, :ϕ)
    c = LatLon(T(30), T(60))
    @test CoordRefSystems.cnames(c) == (:lat, :lon)
    c = LatLonAlt(T(30), T(60), T(1))
    @test CoordRefSystems.cnames(c) == (:lat, :lon, :alt)
    c = Mercator(T(1), T(1))
    @test CoordRefSystems.cnames(c) == (:x, :y)
    c = ShiftedMercator(T(1), T(2))
    @test CoordRefSystems.cnames(c) == (:x, :y)
  end

  @testset "ndims" begin
    c = Cartesian(T(1), T(1))
    @test CoordRefSystems.ndims(c) == 2
    c = Cartesian(T(1), T(1), T(1))
    @test CoordRefSystems.ndims(c) == 3
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

  @testset "isapprox" begin
    c1 = Cartesian(T(1), T(2))
    c2 = Cartesian(T(1) + eps(T), T(2) + eps(T))
    @test isapprox(c1, c2)
    c1 = Polar(T(1), T(2))
    c2 = Polar(T(1) + eps(T), T(2) + eps(T))
    @test isapprox(c1, c2)
    c1 = LatLon(T(30), T(60))
    c2 = LatLon(T(30) + eps(T), T(60) + eps(T))
    @test isapprox(c1, c2)
    c1 = LatLonAlt(T(30), T(60), T(1))
    c2 = LatLonAlt(T(30) + eps(T), T(60) + eps(T), T(1) + eps(T))
    @test isapprox(c1, c2)
    c1 = ShiftedMercator(T(1), T(2))
    c2 = ShiftedMercator(T(1) + eps(T), T(2) + eps(T))
    @test isapprox(c1, c2)
  end

  @testset "allapprox" begin
    c1 = Cartesian(T(1), T(2))
    c2 = Cartesian(T(1) + eps(T), T(2) + eps(T))
    @test allapprox(c1, c2)
    c1 = Polar(T(1), T(2))
    c2 = Polar(T(1) + eps(T), T(2) + eps(T))
    @test allapprox(c1, c2)
    c1 = LatLon(T(30), T(60))
    c2 = LatLon(T(30) + eps(T), T(60) + eps(T))
    @test allapprox(c1, c2)
    c1 = LatLonAlt(T(30), T(60), T(1))
    c2 = LatLonAlt(T(30) + eps(T), T(60) + eps(T), T(1) + eps(T))
    @test allapprox(c1, c2)
    c1 = ShiftedMercator(T(1), T(2))
    c2 = ShiftedMercator(T(1) + eps(T), T(2) + eps(T))
    @test allapprox(c1, c2)
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
