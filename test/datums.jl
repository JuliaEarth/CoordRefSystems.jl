@testset "Datums" begin
  @testset "WGS84" begin
    @test ellipsoid(WGS84Latest) === CoordRefSystems.WGS84🌎
    @test epoch(WGS84{0}) == 1984.0
    @test epoch(WGS84{730}) == 1994.0
    @test epoch(WGS84{873}) == 1997.0
    @test epoch(WGS84{1150}) == 2001.0
    @test epoch(WGS84{1674}) == 2005.0
    @test epoch(WGS84{1762}) == 2005.0
  end

  @testset "ITRF" begin
    @test ellipsoid(ITRFLatest) === CoordRefSystems.GRS80🌎
    @test epoch(ITRF{1991}) == 1988.0
    @test epoch(ITRF{1992}) == 1988.0
    @test epoch(ITRF{1993}) == 1988.0
    @test epoch(ITRF{1994}) == 1993.0
    @test epoch(ITRF{1996}) == 1997.0
    @test epoch(ITRF{1997}) == 1997.0
    @test epoch(ITRF{2000}) == 1997.0
    @test epoch(ITRF{2005}) == 2000.0
    @test epoch(ITRF{2008}) == 2005.0
    @test epoch(ITRF{2014}) == 2010.0
    @test epoch(ITRF{2020}) == 2015.0
  end

  @testset "GGRS87" begin
    @test ellipsoid(GGRS87) === CoordRefSystems.GRS80🌎
  end

  @testset "NAD83" begin
    @test ellipsoid(NAD83) === CoordRefSystems.GRS80🌎
  end

  @testset "Potsdam" begin
    @test ellipsoid(Potsdam) === CoordRefSystems.Bessel🌎
  end

  @testset "Carthage" begin
    @test ellipsoid(Carthage) === CoordRefSystems.Clrk80IGN🌎
  end

  @testset "Hermannskogel" begin
    @test ellipsoid(Hermannskogel) === CoordRefSystems.Bessel🌎
  end

  @testset "Ire65" begin
    @test ellipsoid(Ire65) === CoordRefSystems.ModAiry🌎
  end

  @testset "NZGD1949" begin
    @test ellipsoid(NZGD1949) === CoordRefSystems.Intl🌎
  end

  @testset "OSGB36" begin
    @test ellipsoid(OSGB36) === CoordRefSystems.Airy🌎
  end

  @testset "ShiftedDatum" begin
    ShiftedWGS84 = CoordRefSystems.shift(WGS84Latest, 2024.0)
    @test ellipsoid(ShiftedWGS84) === CoordRefSystems.WGS84🌎
    @test epoch(ShiftedWGS84) == 2024.0
  end
end
