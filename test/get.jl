@testset "get" begin
  TM = CoordRefSystems.TransverseMercator

  # EPSG/ESRI code
  @test CoordRefSystems.get(EPSG{3395}) === Mercator{WGS84Latest}
  @test CoordRefSystems.get(EPSG{3857}) === WebMercator{WGS84Latest}
  @test CoordRefSystems.get(EPSG{4208}) === LatLon{Aratu}
  @test CoordRefSystems.get(EPSG{4618}) === LatLon{SAD69}
  @test CoordRefSystems.get(EPSG{4674}) === LatLon{SIRGAS2000}
  @test CoordRefSystems.get(EPSG{4326}) === LatLon{WGS84Latest}
  @test CoordRefSystems.get(EPSG{4988}) === Cartesian{CoordRefSystems.shift(ITRF{2000}, 2000.4),3}
  @test CoordRefSystems.get(EPSG{4989}) === LatLonAlt{CoordRefSystems.shift(ITRF{2000}, 2000.4)}
  @test CoordRefSystems.get(EPSG{5527}) === LatLon{SAD96}
  @test CoordRefSystems.get(EPSG{9988}) === Cartesian{ITRF{2020},3}
  @test CoordRefSystems.get(EPSG{10176}) === Cartesian{IGS20,3}
  @test CoordRefSystems.get(EPSG{27700}) === CoordRefSystems.shift(TM{0.9996012717,49u"°",-2u"°",OSGB36}, xₒ=400000u"m", yₒ=-100000u"m")
  @test CoordRefSystems.get(EPSG{32662}) === PlateCarree{WGS84Latest}
  @test CoordRefSystems.get(ESRI{54017}) === Behrmann{WGS84Latest}
  @test CoordRefSystems.get(ESRI{54030}) === Robinson{WGS84Latest}
  @test CoordRefSystems.get(ESRI{54034}) === Lambert{WGS84Latest}
  @test CoordRefSystems.get(ESRI{54042}) === WinkelTripel{WGS84Latest}
  @test CoordRefSystems.get(ESRI{102035}) === CoordRefSystems.Orthographic{90.0u"°",0.0u"°",true,WGS84Latest}
  @test CoordRefSystems.get(ESRI{102037}) === CoordRefSystems.Orthographic{-90.0u"°",0.0u"°",true,WGS84Latest}

  for Zone in 1:60
    NorthCode = 32600 + Zone
    SouthCode = 32700 + Zone
    @test CoordRefSystems.get(EPSG{NorthCode}) === UTM{North,Zone,WGS84Latest}
    @test CoordRefSystems.get(EPSG{SouthCode}) === UTM{South,Zone,WGS84Latest}
  end

  # CRS string
  str = wktstring(EPSG{3395})
  @test CoordRefSystems.get(str) === Mercator{WGS84Latest}
end
