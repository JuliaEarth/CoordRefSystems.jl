@testset "get" begin
  # EPSG/ESRI code
  @test CoordRefSystems.get(EPSG{3395}) === Mercator{WGS84Latest}
  @test CoordRefSystems.get(EPSG{3857}) === WebMercator{WGS84Latest}
  @test CoordRefSystems.get(EPSG{4326}) === LatLon{WGS84Latest}
  @test CoordRefSystems.get(EPSG{32662}) === PlateCarree{WGS84Latest}
  @test CoordRefSystems.get(EPSG{32633}) === UTM{North,33,WGS84Latest}
  @test CoordRefSystems.get(ESRI{54017}) === Behrmann{WGS84Latest}
  @test CoordRefSystems.get(ESRI{54030}) === Robinson{WGS84Latest}
  @test CoordRefSystems.get(ESRI{54034}) === Lambert{WGS84Latest}
  @test CoordRefSystems.get(ESRI{54042}) === WinkelTripel{WGS84Latest}
  @test CoordRefSystems.get(ESRI{102035}) === CoordRefSystems.Orthographic{90.0u"°",0.0u"°",true,WGS84Latest}
  @test CoordRefSystems.get(ESRI{102037}) === CoordRefSystems.Orthographic{-90.0u"°",0.0u"°",true,WGS84Latest}
  @test_throws ArgumentError CoordRefSystems.get(EPSG{1})

  # CRS string
  str = wktstring(EPSG{3395})
  @test CoordRefSystems.get(str) === Mercator{WGS84Latest}
end
