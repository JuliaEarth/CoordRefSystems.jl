@testset "Random CRS" begin
  @testset "Basic" begin
    randtest(Cartesian{NoDatum,1})
    randtest(Cartesian{NoDatum,2})
    randtest(Cartesian{NoDatum,3})
    randtest(Cartesian2D)
    randtest(Cartesian3D)

    randtest(Polar{NoDatum})
    randtest(Polar)

    randtest(Cylindrical{NoDatum})
    randtest(Cylindrical)

    randtest(Spherical{NoDatum})
    randtest(Spherical)
  end

  @testset "Geographic" begin
    randtest(GeodeticLatLon{WGS84Latest})
    randtest(GeodeticLatLon)

    randtest(LatLon{WGS84Latest})
    randtest(LatLon)

    randtest(GeodeticLatLonAlt{WGS84Latest})
    randtest(GeodeticLatLonAlt)

    randtest(LatLonAlt{WGS84Latest})
    randtest(LatLonAlt)

    randtest(GeocentricLatLon{WGS84Latest})
    randtest(GeocentricLatLon)

    randtest(GeocentricLatLonAlt{WGS84Latest})
    randtest(GeocentricLatLonAlt)

    randtest(AuthalicLatLon{WGS84Latest})
    randtest(AuthalicLatLon)
  end

  @testset "Projected" begin
    randtest(Mercator{WGS84Latest})
    randtest(Mercator)

    randtest(WebMercator{WGS84Latest})
    randtest(WebMercator)

    randtest(PlateCarree{WGS84Latest})
    randtest(PlateCarree)

    randtest(Lambert{WGS84Latest})
    randtest(Lambert)

    randtest(Behrmann{WGS84Latest})
    randtest(Behrmann)

    randtest(GallPeters{WGS84Latest})
    randtest(GallPeters)

    randtest(WinkelTripel{WGS84Latest})
    randtest(WinkelTripel)

    randtest(Robinson{WGS84Latest})
    randtest(Robinson)

    randtest(OrthoNorth{WGS84Latest})
    randtest(OrthoNorth)

    randtest(OrthoSouth{WGS84Latest})
    randtest(OrthoSouth)

    randtest(Albers{23.0°,29.5°,45.5°,WGS84Latest})
    randtest(Albers{23.0°,29.5°,45.5°})
  end
end
