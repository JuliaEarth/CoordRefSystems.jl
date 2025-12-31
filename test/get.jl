@testset "get" begin
  # EPSG/ESRI code
  gettest(
    CoordRefSystems.shift(
      TransverseMercator{1.0000067,31.734394°,Israel1993},
      lonₒ=35.204517°,
      xₒ=219529.584m,
      yₒ=626907.39m
    ),
    EPSG{2039}
  )
  gettest(
    CoordRefSystems.shift(TransverseMercator{0.99982,53.5°,IRENET95}, lonₒ=-8.0°, xₒ=600000.0m, yₒ=750000.0m),
    EPSG{2157}
  )
  gettest(
    CoordRefSystems.shift(TransverseMercator{0.9993,0.0°,ETRF{2000}}, lonₒ=19.0°, xₒ=500000.0m, yₒ=-5300000.0m),
    EPSG{2180}
  )
  gettest(
    CoordRefSystems.shift(TransverseMercator{0.9996,0.0°,NZGD2000}, lonₒ=173.0°, xₒ=1600000.0m, yₒ=10000000.0m),
    EPSG{2193}
  )
  gettest(
    CoordRefSystems.shift(LambertAzimuthal{52.0°,ETRFLatest}, lonₒ=10.0°, xₒ=4321000.0m, yₒ=3210000.0m),
    EPSG{3035}
  )
  gettest(CoordRefSystems.shift(Albers{0.0°,34.0°,40.5°,NAD83}, lonₒ=-120.0°, yₒ=-4000000.0m), EPSG{3310})
  gettest(CoordRefSystems.shift(Albers{50.0°,55.0°,65.0°,NAD83}, lonₒ=-154.0°), EPSG{3338})
  gettest(Mercator{WGS84Latest}, EPSG{3395})
  gettest(CoordRefSystems.shift(Albers{0.0°,-18.0°,-36.0°,GDA94}, lonₒ=132.0°), EPSG{3577})
  gettest(WebMercator{WGS84Latest}, EPSG{3857})
  gettest(LatLon{RGF93v1}, EPSG{4171})
  gettest(LatLon{Lisbon1937}, EPSG{4207})
  gettest(LatLon{Aratu}, EPSG{4208})
  gettest(LatLon{ED50}, EPSG{4230})
  gettest(LatLon{ED87}, EPSG{4231})
  gettest(LatLon{NAD27}, EPSG{4267})
  gettest(LatLon{NAD83}, EPSG{4269})
  gettest(LatLon{Datum73}, EPSG{4274})
  gettest(LatLon{NTF}, EPSG{4275})
  gettest(LatLon{OSGB36}, EPSG{4277})
  gettest(LatLon{GDA94}, EPSG{4283})
  gettest(LatLon{DHDN}, EPSG{4314})
  gettest(LatLon{WGS84Latest}, EPSG{4326})
  gettest(LatLon{SAD69}, EPSG{4618})
  gettest(LatLon{ISN93}, EPSG{4659})
  gettest(LatLon{Lisbon1890}, EPSG{4666})
  gettest(LatLon{ED79}, EPSG{4668})
  gettest(LatLon{SIRGAS2000}, EPSG{4674})
  gettest(LatLon{RD83}, EPSG{4745})
  gettest(LatLon{PD83}, EPSG{4746})
  gettest(LatLonAlt{WGS84Latest}, EPSG{4979})
  gettest(Cartesian{CoordRefSystems.shift(ITRF{2000}, 2000.4),3}, EPSG{4988})
  gettest(LatLonAlt{CoordRefSystems.shift(ITRF{2000}, 2000.4)}, EPSG{4989})
  gettest(CoordRefSystems.shift(Albers{23.0°,29.5°,45.5°,NAD83}, lonₒ=-96.0°), EPSG{5070})
  gettest(LatLon{ISN2004}, EPSG{5324})
  gettest(LatLon{SAD96}, EPSG{5527})
  gettest(LatLon{ISN2016}, EPSG{8086})
  gettest(LatLon{NAD83CSRS{1}}, EPSG{8232})
  gettest(LatLon{NAD83CSRS{2}}, EPSG{8237})
  gettest(LatLon{NAD83CSRS{3}}, EPSG{8240})
  gettest(LatLon{NAD83CSRS{4}}, EPSG{8246})
  gettest(LatLon{NAD83CSRS{5}}, EPSG{8249})
  gettest(LatLon{NAD83CSRS{6}}, EPSG{8252})
  gettest(LatLon{NAD83CSRS{7}}, EPSG{8255})
  gettest(LatLon{RGF93v2}, EPSG{9777})
  gettest(LatLon{RGF93v2b}, EPSG{9782})
  gettest(Cartesian{ITRF{2020},3}, EPSG{9988})
  gettest(Cartesian{IGS20,3}, EPSG{10176})
  gettest(LatLon{NAD83CSRS{8}}, EPSG{10414})
  gettest(
    CoordRefSystems.shift(TransverseMercator{0.9996,0.0°,ETRFLatest}, lonₒ=9.0°, xₒ=500000.0m, yₒ=0.0m),
    EPSG{25832}
  )
  gettest(
    CoordRefSystems.shift(TransverseMercator{0.9996012717,49.0°,OSGB36}, lonₒ=-2.0°, xₒ=400000.0m, yₒ=-100000.0m),
    EPSG{27700}
  )
  gettest(
    CoordRefSystems.shift(TransverseMercator{0.9996,0.0°,GDA94}, lonₒ=147.0°, xₒ=500000.0m, yₒ=10000000.0m),
    EPSG{28355}
  )
  gettest(
    CoordRefSystems.shift(TransverseMercator{1.000035,53.5°,Ire65}, lonₒ=-8.0°, xₒ=200000.0m, yₒ=250000.0m),
    EPSG{29902},
    EPSG{29903}
  )
  gettest(
    CoordRefSystems.shift(
      LambertConic{90.0°,51.1666672333333°,49.8333339°,BD72},
      lonₒ=4.36748666666667°,
      xₒ=150000.013m,
      yₒ=5400088.438m
    ),
    EPSG{31370}
  )
  gettest(PlateCarree{WGS84Latest}, EPSG{32662})
  gettest(Behrmann{WGS84Latest}, ESRI{54017})
  gettest(Robinson{WGS84Latest}, ESRI{54030})
  gettest(LambertCylindrical{WGS84Latest}, ESRI{54034})
  gettest(WinkelTripel{WGS84Latest}, ESRI{54042})
  gettest(CoordRefSystems.Orthographic{CoordRefSystems.SphericalMode,90°,WGS84Latest}, ESRI{102035})
  gettest(CoordRefSystems.Orthographic{CoordRefSystems.SphericalMode,-90°,WGS84Latest}, ESRI{102037})

  for zone in 1:60
    NorthCode = 32600 + zone
    SouthCode = 32700 + zone
    gettest(utmnorth(zone, datum=WGS84Latest), EPSG{NorthCode})
    gettest(utmsouth(zone, datum=WGS84Latest), EPSG{SouthCode})
  end

  for zone in 11:22
    NorthCode = 31954 + zone
    gettest(utmnorth(zone, datum=SIRGAS2000), EPSG{NorthCode})
  end

  for zone in 17:25
    SouthCode = 31960 + zone
    gettest(utmsouth(zone, datum=SIRGAS2000), EPSG{SouthCode})
  end

  gettest(utmnorth(23, datum=SIRGAS2000), EPSG{6210})
  gettest(utmnorth(24, datum=SIRGAS2000), EPSG{6211})
  gettest(utmsouth(26, datum=SIRGAS2000), EPSG{5396})

  # CRS string
  str = wktstring(EPSG{3395})
  @test CoordRefSystems.get(str) === Mercator{WGS84Latest}

  # error: the provided Code is not mapped to a CRS type yet
  @test_throws ArgumentError CoordRefSystems.get(EPSG{0})
  # error: the provided CRS type does not have an EPSG/ESRI code
  @test_throws ArgumentError CoordRefSystems.code(Mercator)
end
