@testset "CRS API" begin
  ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")

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
