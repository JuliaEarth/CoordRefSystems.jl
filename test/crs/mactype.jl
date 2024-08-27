@testset "Machine type conversion" begin
  @testset "Basic" begin
    C = Cartesian{NoDatum,2,Met{T}}
    c1 = Cartesian(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Cartesian(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = Polar{NoDatum,Met{T},Rad{T}}
    c1 = Polar(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Polar(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = Cylindrical{NoDatum,Met{T},Rad{T}}
    c1 = Cylindrical(1.0, 1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Cylindrical(1.0f0, 1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = Spherical{NoDatum,Met{T},Rad{T}}
    c1 = Spherical(1.0, 1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Spherical(1.0f0, 1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C
  end

  @testset "Geographic" begin
    C = LatLon{WGS84Latest,Deg{T}}
    c1 = LatLon(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = LatLon(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = LatLonAlt{WGS84Latest,Deg{T},Met{T}}
    c1 = LatLonAlt(1.0, 1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = LatLonAlt(1.0f0, 1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = GeocentricLatLon{WGS84Latest,Deg{T}}
    c1 = GeocentricLatLon(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = GeocentricLatLon(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = AuthalicLatLon{WGS84Latest,Deg{T}}
    c1 = AuthalicLatLon(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = AuthalicLatLon(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C
  end

  @testset "Projected" begin
    C = Mercator{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
    c1 = Mercator(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Mercator(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = WebMercator{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
    c1 = WebMercator(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = WebMercator(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = PlateCarree{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
    c1 = PlateCarree(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = PlateCarree(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = Lambert{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
    c1 = Lambert(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Lambert(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = WinkelTripel{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
    c1 = WinkelTripel(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = WinkelTripel(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = Robinson{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
    c1 = Robinson(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Robinson(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = OrthoNorth{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
    c1 = OrthoNorth(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = OrthoNorth(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    TransverseMercator = CoordRefSystems.shift(
      CoordRefSystems.TransverseMercator{WGS84Latest,CoordRefSystems.TransverseMercatorParams(k₀ = 0.9996, latₒ = 15.0°)},
      lonₒ=45.0°
    )
    C = TransverseMercator{Met{T}}
    c1 = TransverseMercator(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = TransverseMercator(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    ShiftedMercator = CoordRefSystems.shift(Mercator{WGS84Latest}, lonₒ=15.0°, xₒ=200.0m, yₒ=200.0m)
    C = ShiftedMercator{Met{T}}
    c1 = ShiftedMercator(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = ShiftedMercator(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C
  end
end
