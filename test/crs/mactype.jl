@testset "Machine type conversion" begin
  @testset "Basic" begin
    C = Cartesian{NoDatum,2,Met{T}}
    c1 = Cartesian(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Cartesian(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    C = Cartesian{NoDatum,3,Met{T}}
    c1 = Cartesian(1.0, 1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = Cartesian(1.0f0, 1.0f0, 1.0f0)
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
    for C in geographic2D
      CT = C{WGS84Latest,Deg{T}}
      c1 = C(1.0, 1.0)
      c2 = convert(CT, c1)
      @test c2 isa CT
      c1 = C(1.0f0, 1.0f0)
      c2 = convert(CT, c1)
      @test c2 isa CT
    end

    for C in geographic3D
      CT = C{WGS84Latest,Deg{T},Met{T}}
      c1 = C(1.0, 1.0, 1.0)
      c2 = convert(CT, c1)
      @test c2 isa CT
      c1 = C(1.0f0, 1.0f0, 1.0f0)
      c2 = convert(CT, c1)
      @test c2 isa CT
    end
  end

  @testset "Projected" begin
    for C in projected
      CT = C{WGS84Latest,CoordRefSystems.Shift(),Met{T}}
      c1 = C(1.0, 1.0)
      c2 = convert(CT, c1)
      @test c2 isa CT
      c1 = C(1.0f0, 1.0f0)
      c2 = convert(CT, c1)
      @test c2 isa CT
    end

    ShiftedTM = CoordRefSystems.shift(TransverseMercator{0.9996,15.0°,WGS84Latest}, lonₒ=45.0°)
    C = ShiftedTM{Met{T}}
    c1 = ShiftedTM(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = ShiftedTM(1.0f0, 1.0f0)
    c2 = convert(C, c1)
    @test c2 isa C

    UTMNorth32 = utmnorth(32)
    C = UTMNorth32{Met{T}}
    c1 = UTMNorth32(1.0, 1.0)
    c2 = convert(C, c1)
    @test c2 isa C
    c1 = UTMNorth32(1.0f0, 1.0f0)
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
