@testset "Approximation" begin
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
    ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
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
    ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
    c1 = ShiftedMercator(T(1), T(2))
    c2 = ShiftedMercator(T(1) + eps(T), T(2) + eps(T))
    @test allapprox(c1, c2)
  end
end
