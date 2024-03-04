@testset "EPSG/ESRI Codes" begin
  @test Cartography.crs(EPSG{3395}) === Mercator{WGS84Latest}
  @test Cartography.crs(EPSG{3857}) === WebMercator{WGS84Latest}
  @test Cartography.crs(EPSG{4326}) === LatLon{WGS84Latest}
  @test Cartography.crs(EPSG{32662}) === PlateCarree{WGS84Latest}
  @test Cartography.crs(ESRI{54017}) === Behrmann{WGS84Latest}
  @test Cartography.crs(ESRI{54030}) === Robinson{WGS84Latest}
  @test Cartography.crs(ESRI{54034}) === Lambert{WGS84Latest}
  @test Cartography.crs(ESRI{54042}) === WinkelTripel{WGS84Latest}
  @test Cartography.crs(ESRI{102035}) === Cartography.Orthographic{90.0u"°",0.0u"°",true,WGS84Latest}
  @test Cartography.crs(ESRI{102037}) === Cartography.Orthographic{-90.0u"°",0.0u"°",true,WGS84Latest}
end
