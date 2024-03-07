@testset "Datums" begin
  @testset "NoDatum" begin
    @test isnothing(ellipsoid(NoDatum))
    @test isnothing(latitudeₒ(NoDatum))
    @test isnothing(longitudeₒ(NoDatum))
    @test isnothing(altitudeₒ(NoDatum))
  end

  @testset "WGS84" begin
    🌎 = ellipsoid(WGS84Latest)
    @test majoraxis(🌎) == 6378137.0u"m"
    @test minoraxis(🌎) == 6356752.314245179u"m"
    @test eccentricity(🌎) == 0.08181919084262149
    @test eccentricity²(🌎) == 0.0066943799901413165
    @test flattening(🌎) == 0.0033528106647474805
    @test flattening⁻¹(🌎) == 298.257223563

    @test latitudeₒ(WGS84Latest) == 0.0u"°"
    @test longitudeₒ(WGS84Latest) == 0.0u"°"
    @test altitudeₒ(WGS84Latest) == 0.0u"m"

    @test isnothing(epoch(WGS84{0}))
    @test epoch(WGS84{730}) == 1994.0
    @test epoch(WGS84{873}) == 1997.0
    @test epoch(WGS84{1150}) == 2001.0
    @test epoch(WGS84{1674}) == 2005.0
    @test epoch(WGS84{1762}) == 2005.0
  end

  @testset "ITRF" begin
    🌎 = ellipsoid(ITRFLatest)
    @test majoraxis(🌎) == 6378137.0u"m"
    @test minoraxis(🌎) == 6356752.314140356u"m"
    @test eccentricity(🌎) == 0.08181919104281579
    @test eccentricity²(🌎) == 0.006694380022900787
    @test flattening(🌎) == 0.003352810681182319
    @test flattening⁻¹(🌎) == 298.257222101

    @test latitudeₒ(ITRFLatest) == 0.0u"°"
    @test longitudeₒ(ITRFLatest) == 0.0u"°"
    @test altitudeₒ(ITRFLatest) == 0.0u"m"

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
    @test ellipsoid(GGRS87) === Cartography.GRS80🌎
    @test latitudeₒ(GGRS87) == 0.0u"°"
    @test longitudeₒ(GGRS87) == 0.0u"°"
    @test altitudeₒ(GGRS87) == 0.0u"m"
    @test isnothing(epoch(GGRS87))
  end

  @testset "NAD83" begin
    @test ellipsoid(NAD83) === Cartography.GRS80🌎
    @test latitudeₒ(NAD83) == 0.0u"°"
    @test longitudeₒ(NAD83) == 0.0u"°"
    @test altitudeₒ(NAD83) == 0.0u"m"
    @test isnothing(epoch(NAD83))
  end

  @testset "Potsdam" begin
    @test ellipsoid(Potsdam) === Cartography.Bessel🌎
    @test latitudeₒ(Potsdam) == 0.0u"°"
    @test longitudeₒ(Potsdam) == 0.0u"°"
    @test altitudeₒ(Potsdam) == 0.0u"m"
    @test isnothing(epoch(Potsdam))
  end

  @testset "Carthage" begin
    @test ellipsoid(Carthage) === Cartography.Clrk80IGN🌎
    @test latitudeₒ(Carthage) == 0.0u"°"
    @test longitudeₒ(Carthage) == 0.0u"°"
    @test altitudeₒ(Carthage) == 0.0u"m"
    @test isnothing(epoch(Carthage))
  end

  @testset "Hermannskogel" begin
    @test ellipsoid(Hermannskogel) === Cartography.Bessel🌎
    @test latitudeₒ(Hermannskogel) == 0.0u"°"
    @test longitudeₒ(Hermannskogel) == 0.0u"°"
    @test altitudeₒ(Hermannskogel) == 0.0u"m"
    @test isnothing(epoch(Hermannskogel))
  end

  @testset "Ire65" begin
    @test ellipsoid(Ire65) === Cartography.ModAiry🌎
    @test latitudeₒ(Ire65) == 0.0u"°"
    @test longitudeₒ(Ire65) == 0.0u"°"
    @test altitudeₒ(Ire65) == 0.0u"m"
    @test isnothing(epoch(Ire65))
  end

  @testset "NZGD1949" begin
    @test ellipsoid(NZGD1949) === Cartography.Intl🌎
    @test latitudeₒ(NZGD1949) == 0.0u"°"
    @test longitudeₒ(NZGD1949) == 0.0u"°"
    @test altitudeₒ(NZGD1949) == 0.0u"m"
    @test isnothing(epoch(NZGD1949))
  end

  @testset "OSGB36" begin
    @test ellipsoid(OSGB36) === Cartography.Airy🌎
    @test latitudeₒ(OSGB36) == 0.0u"°"
    @test longitudeₒ(OSGB36) == 0.0u"°"
    @test altitudeₒ(OSGB36) == 0.0u"m"
    @test isnothing(epoch(OSGB36))
  end
end
