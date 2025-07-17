@testset "get" begin
  # EPSG/ESRI code
  gettest(
    EPSG{2157},
    CoordRefSystems.shift(TransverseMercator{0.99982,53.5°,IRENET95}, lonₒ=-8.0°, xₒ=600000.0m, yₒ=750000.0m)
  )
  gettest(
    EPSG{2180},
    CoordRefSystems.shift(TransverseMercator{0.9993,0.0°,ETRF{2000}}, lonₒ=19.0°, xₒ=500000.0m, yₒ=-5300000.0m)
  )
  gettest(
    EPSG{2193},
    CoordRefSystems.shift(TransverseMercator{0.9996,0.0°,NZGD2000}, lonₒ=173.0°, xₒ=1600000.0m, yₒ=10000000.0m)
  )
  gettest(
    EPSG{3035},
    CoordRefSystems.shift(LambertAzimuthal{52.0°,ETRFLatest}, lonₒ=10.0°, xₒ=4321000.0m, yₒ=3210000.0m)
  )
  gettest(EPSG{3310}, CoordRefSystems.shift(Albers{0.0°,34.0°,40.5°,NAD83}, lonₒ=-120.0°, yₒ=-4000000.0m))
  gettest(EPSG{3338}, CoordRefSystems.shift(Albers{50.0°,55.0°,65.0°,NAD83}, lonₒ=-154.0°))
  gettest(EPSG{3395}, Mercator{WGS84Latest})
  gettest(EPSG{3857}, WebMercator{WGS84Latest})
  gettest(EPSG{4171}, LatLon{RGF93v1})
  gettest(EPSG{4207}, LatLon{Lisbon1937})
  gettest(EPSG{4208}, LatLon{Aratu})
  gettest(EPSG{4230}, LatLon{ED50})
  gettest(EPSG{4231}, LatLon{ED87})
  gettest(EPSG{4267}, LatLon{NAD27})
  gettest(EPSG{4269}, LatLon{NAD83})
  gettest(EPSG{4274}, LatLon{Datum73})
  gettest(EPSG{4275}, LatLon{NTF})
  gettest(EPSG{4277}, LatLon{OSGB36})
  gettest(EPSG{4314}, LatLon{DHDN})
  gettest(EPSG{4326}, LatLon{WGS84Latest})
  gettest(EPSG{4618}, LatLon{SAD69})
  gettest(EPSG{4659}, LatLon{ISN93})
  gettest(EPSG{4666}, LatLon{Lisbon1890})
  gettest(EPSG{4668}, LatLon{ED79})
  gettest(EPSG{4674}, LatLon{SIRGAS2000})
  gettest(EPSG{4745}, LatLon{RD83})
  gettest(EPSG{4746}, LatLon{PD83})
  gettest(EPSG{4988}, Cartesian{CoordRefSystems.shift(ITRF{2000}, 2000.4),3})
  gettest(EPSG{4989}, LatLonAlt{CoordRefSystems.shift(ITRF{2000}, 2000.4)})
  gettest(EPSG{5070}, CoordRefSystems.shift(Albers{23.0°,29.5°,45.5°,NAD83}, lonₒ=-96.0°))
  gettest(EPSG{5324}, LatLon{ISN2004})
  gettest(EPSG{5527}, LatLon{SAD96})
  gettest(EPSG{8086}, LatLon{ISN2016})
  gettest(EPSG{8232}, LatLon{NAD83CSRS{1}})
  gettest(EPSG{8237}, LatLon{NAD83CSRS{2}})
  gettest(EPSG{8240}, LatLon{NAD83CSRS{3}})
  gettest(EPSG{8246}, LatLon{NAD83CSRS{4}})
  gettest(EPSG{8249}, LatLon{NAD83CSRS{5}})
  gettest(EPSG{8252}, LatLon{NAD83CSRS{6}})
  gettest(EPSG{8255}, LatLon{NAD83CSRS{7}})
  gettest(EPSG{9777}, LatLon{RGF93v2})
  gettest(EPSG{9782}, LatLon{RGF93v2b})
  gettest(EPSG{9988}, Cartesian{ITRF{2020},3})
  gettest(EPSG{10176}, Cartesian{IGS20,3})
  gettest(EPSG{10414}, LatLon{NAD83CSRS{8}})
  gettest(
    EPSG{25832},
    CoordRefSystems.shift(TransverseMercator{0.9996,0.0°,ETRFLatest}, lonₒ=9.0°, xₒ=500000.0m, yₒ=0.0m)
  )
  gettest(
    EPSG{27700},
    CoordRefSystems.shift(TransverseMercator{0.9996012717,49.0°,OSGB36}, lonₒ=-2.0°, xₒ=400000.0m, yₒ=-100000.0m)
  )
  gettest(
    EPSG{28355},
    CoordRefSystems.shift(TransverseMercator{0.9996,0.0°,GDA94}, lonₒ=147.0°, xₒ=500000.0m, yₒ=10000000.0m)
  )
  gettest(
    EPSG{29903},
    CoordRefSystems.shift(TransverseMercator{1.000035,53.5°,Ire65}, lonₒ=-8.0°, xₒ=200000.0m, yₒ=250000.0m)
  )
  gettest(
    EPSG{31370},
    CoordRefSystems.shift(
      LambertConic{90.0°,51.1666672333333°,49.8333339°,BD72},
      lonₒ=4.36748666666667°,
      xₒ=150000.013m,
      yₒ=5400088.438m
    )
  )
  gettest(EPSG{32662}, PlateCarree{WGS84Latest})
  gettest(ESRI{54017}, Behrmann{WGS84Latest})
  gettest(ESRI{54030}, Robinson{WGS84Latest})
  gettest(ESRI{54034}, LambertCylindrical{WGS84Latest})
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
