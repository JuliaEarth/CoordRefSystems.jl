@testset "get" begin
  # EPSG/ESRI code
  gettest(
    EPSG{2157},
    CoordRefSystems.shift(TransverseMercator{0.99982,53.5°,IRENET95}, lonₒ=-8.0°, xₒ=600000.0m, yₒ=750000.0m)
  )
  gettest(EPSG{3395}, Mercator{WGS84Latest})
  gettest(EPSG{3857}, WebMercator{WGS84Latest})
  gettest(EPSG{4208}, LatLon{Aratu})
  gettest(EPSG{4269}, LatLon{NAD83})
  gettest(EPSG{4326}, LatLon{WGS84Latest})
  gettest(EPSG{4618}, LatLon{SAD69})
  gettest(EPSG{4674}, LatLon{SIRGAS2000})
  gettest(EPSG{4988}, Cartesian{CoordRefSystems.shift(ITRF{2000}, 2000.4),3})
  gettest(EPSG{4989}, LatLonAlt{CoordRefSystems.shift(ITRF{2000}, 2000.4)})
  gettest(EPSG{5527}, LatLon{SAD96})
  gettest(EPSG{9988}, Cartesian{ITRF{2020},3})
  gettest(EPSG{10176}, Cartesian{IGS20,3})
  gettest(
    EPSG{27700},
    CoordRefSystems.shift(TransverseMercator{0.9996012717,49.0°,OSGB36}, lonₒ=-2.0°, xₒ=400000.0m, yₒ=-100000.0m)
  )
  gettest(
    EPSG{29903},
    CoordRefSystems.shift(TransverseMercator{1.000035,53.5°,Ire65}, lonₒ=-8.0°, xₒ=200000.0m, yₒ=250000.0m)
  )
  gettest(EPSG{32662}, PlateCarree{WGS84Latest})
  gettest(ESRI{54017}, Behrmann{WGS84Latest})
  gettest(ESRI{54030}, Robinson{WGS84Latest})
  gettest(ESRI{54034}, Lambert{WGS84Latest})
  gettest(ESRI{54042}, WinkelTripel{WGS84Latest})
  gettest(ESRI{102035}, CoordRefSystems.Orthographic{CoordRefSystems.SphericalMode,90°,WGS84Latest})
  gettest(ESRI{102037}, CoordRefSystems.Orthographic{CoordRefSystems.SphericalMode,-90°,WGS84Latest})

  for zone in 1:60
    NorthCode = 32600 + zone
    SouthCode = 32700 + zone
    gettest(EPSG{NorthCode}, utmnorth(zone, datum=WGS84Latest))
    gettest(EPSG{SouthCode}, utmsouth(zone, datum=WGS84Latest))
  end

  # CRS string
  str = wktstring(EPSG{3395})
  @test CoordRefSystems.get(str) === Mercator{WGS84Latest}

  # error: the provided Code is not mapped to a CRS type yet
  @test_throws ArgumentError CoordRefSystems.get(EPSG{0})
  # error: the provided CRS type does not have an EPSG/ESRI code
  @test_throws ArgumentError CoordRefSystems.code(Mercator)
end
