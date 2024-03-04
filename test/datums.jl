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
end
