@testset "Datums" begin
  @test ellipsoid(WGS84Latest) === CoordRefSystems.WGS84🌎
  @test epoch(WGS84{0}) == 1984.0
  @test epoch(WGS84{730}) == 1994.0
  @test epoch(WGS84{873}) == 1997.0
  @test epoch(WGS84{1150}) == 2001.0
  @test epoch(WGS84{1674}) == 2005.0
  @test epoch(WGS84{1762}) == 2005.0
  @test epoch(WGS84{2139}) == 2016.0
  @test epoch(WGS84{2296}) == 2020.0

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

  @test ellipsoid(ETRFLatest) === CoordRefSystems.GRS80🌎
  @test epoch(ETRF{1989}) == 1989.0
  @test epoch(ETRF{1990}) == 1989.0
  @test epoch(ETRF{1991}) == 1989.0
  @test epoch(ETRF{1992}) == 1989.0
  @test epoch(ETRF{1993}) == 1989.0
  @test epoch(ETRF{1994}) == 1989.0
  @test epoch(ETRF{1996}) == 1989.0
  @test epoch(ETRF{1997}) == 1989.0
  @test epoch(ETRF{2000}) == 1989.0
  @test epoch(ETRF{2005}) == 2000.0
  @test epoch(ETRF{2014}) == 2010.0
  @test epoch(ETRF{2020}) == 2015.0

  @test ellipsoid(NAD83CSRSLatest) === CoordRefSystems.GRS80🌎
  @test epoch(NAD83CSRS{2}) == 1997.0
  @test epoch(NAD83CSRS{3}) == 1997.0
  @test epoch(NAD83CSRS{4}) == 2002.0
  @test epoch(NAD83CSRS{5}) == 2006.0
  @test epoch(NAD83CSRS{6}) == 2010.0
  @test epoch(NAD83CSRS{7}) == 2010.0
  @test epoch(NAD83CSRS{8}) == 2010.0

  @test ellipsoid(Aratu) === CoordRefSystems.Intl🌎

  @test ellipsoid(Carthage) === CoordRefSystems.Clrk80IGN🌎

  @test ellipsoid(GGRS87) === CoordRefSystems.GRS80🌎

  @test ellipsoid(GRS80S) === CoordRefSystems.GRS80S🌎

  @test ellipsoid(Hermannskogel) === CoordRefSystems.Bessel🌎

  @test ellipsoid(IGS20) === CoordRefSystems.GRS80🌎

  @test ellipsoid(Ire65) === CoordRefSystems.ModAiry🌎

  @test ellipsoid(IRENET95) === CoordRefSystems.GRS80🌎

  @test ellipsoid(ISN93) === CoordRefSystems.GRS80🌎

  @test ellipsoid(ISN2004) === CoordRefSystems.GRS80🌎

  @test ellipsoid(ISN2016) === CoordRefSystems.GRS80🌎

  @test ellipsoid(NAD27) === CoordRefSystems.Clrk66🌎

  @test ellipsoid(NAD83) === CoordRefSystems.GRS80🌎

  @test ellipsoid(NZGD1949) === CoordRefSystems.Intl🌎

  @test ellipsoid(OSGB36) === CoordRefSystems.Airy🌎

  @test ellipsoid(Potsdam) === CoordRefSystems.Bessel🌎

  @test ellipsoid(SAD69) === CoordRefSystems.GRS67Modified🌎

  @test ellipsoid(SAD96) === CoordRefSystems.GRS67Modified🌎

  @test ellipsoid(SIRGAS2000) === CoordRefSystems.GRS80🌎

  ShiftedWGS84 = CoordRefSystems.shift(WGS84Latest, 2024.0)
  @test ellipsoid(ShiftedWGS84) === CoordRefSystems.WGS84🌎
  @test epoch(ShiftedWGS84) == 2024.0
end
