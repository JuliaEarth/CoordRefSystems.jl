@testset "Comparison between Geographic Coordinates" begin
  coord_latlon = LatLon{WGS84}(45, 45)
  coord_latlon_greater_lat = LatLon{WGS84}(46, 44)
  coord_latlon_greater_lon = LatLon{WGS84}(45, 46)
  coord_latlon_lower_lat = LatLon{WGS84}(44, 46)
  coord_latlon_lower_lon = LatLon{WGS84}(45, 44)
  coord_latlonalt = LatLonAlt{WGS84}(45, 45, 10)
  coord_latlonalt_greater_lat = LatLonAlt{WGS84}(46, 44, 10)
  coord_latlonalt_greater_lon = LatLonAlt{WGS84}(45, 46, 10)
  coord_latlonalt_greater_alt = LatLonAlt{WGS84}(45, 45, 11)
  coord_latlonalt_lower_lat = LatLonAlt{WGS84}(44, 46, 10)
  coord_latlonalt_lower_lon = LatLonAlt{WGS84}(45, 44, 10)
  coord_latlonalt_lower_alt = LatLonAlt{WGS84}(45, 45, 9)
  coord_geocentriclatlon = GeocentricLatLon{WGS84}(45, 45)
  coord_geocentriclatlon_greater_lat = GeocentricLatLon{WGS84}(46, 44)
  coord_geocentriclatlon_greater_lon = GeocentricLatLon{WGS84}(45, 46)
  coord_geocentriclatlon_lower_lat = GeocentricLatLon{WGS84}(44, 46)
  coord_geocentriclatlon_lower_lon = GeocentricLatLon{WGS84}(45, 44)
  coord_geocentriclatlonalt = GeocentricLatLonAlt{WGS84}(45, 45, 10)
  coord_geocentriclatlonalt_greater_lat = GeocentricLatLonAlt{WGS84}(46, 44, 10)
  coord_geocentriclatlonalt_greater_lon = GeocentricLatLonAlt{WGS84}(45, 46, 10)
  coord_geocentriclatlonalt_greater_alt = GeocentricLatLonAlt{WGS84}(45, 45, 11)
  coord_geocentriclatlonalt_lower_lat = GeocentricLatLonAlt{WGS84}(44, 46, 10)
  coord_geocentriclatlonalt_lower_lon = GeocentricLatLonAlt{WGS84}(45, 44, 10)
  coord_geocentriclatlonalt_lower_alt = GeocentricLatLonAlt{WGS84}(45, 45, 9)

  coord_latlon_datum = LatLon{WGS84{1796}}(45, 45)

  @test coord_latlon < coord_latlon_greater_lat
  @test coord_latlon < coord_latlon_greater_lon
  @test coord_latlon > coord_latlon_lower_lat
  @test coord_latlon > coord_latlon_lower_lon
  @test coord_latlonalt < coord_latlonalt_greater_lat
  @test coord_latlonalt < coord_latlonalt_greater_lon
  @test coord_latlonalt < coord_latlonalt_greater_alt
  @test coord_latlonalt > coord_latlonalt_lower_lat
  @test coord_latlonalt > coord_latlonalt_lower_lon
  @test coord_latlonalt > coord_latlonalt_lower_alt
  @test coord_geocentriclatlon < coord_geocentriclatlon_greater_lat
  @test coord_geocentriclatlon < coord_geocentriclatlon_greater_lon
  @test coord_geocentriclatlon > coord_geocentriclatlon_lower_lat
  @test coord_geocentriclatlon > coord_geocentriclatlon_lower_lon
  @test coord_geocentriclatlonalt < coord_geocentriclatlonalt_greater_lat
  # throw error if different datums
  @test_throws MethodError coord_latlon < coord_latlon_datum
end

@testset "Sort Coordinates" begin
  _lat= -90:10:90
  _lon= -180:10:180
  _alt= 0:10:100
  sorted_latlon = [LatLon(lat, lon) for lon in _lon,lat in _lat][:]
  sorted_latlonalt = [LatLonAlt(lat, lon, alt) for  alt in _alt,lon in _lon,lat in _lat ][:]
  sorted_geocentriclatlon = [GeocentricLatLon(lat, lon) for lon in _lon, lat in _lat][:]
  sorted_geocentriclatlonalt = [GeocentricLatLonAlt(lat, lon, alt) for alt in _alt, lon in _lon, lat in _lat  ][:]
  shuffled_latlon = sorted_latlon[randperm(length(sorted_latlon))]
  shuffled_latlonalt = sorted_latlonalt[randperm(length(sorted_latlonalt))]
  shuffled_geocentriclatlon = sorted_geocentriclatlon[randperm(length(sorted_geocentriclatlon))]
  shuffled_geocentriclatlonalt = sorted_geocentriclatlonalt[randperm(length(sorted_geocentriclatlonalt))]

  @test sort(shuffled_latlon) == sorted_latlon
  @test sort(shuffled_latlonalt) == sorted_latlonalt
  @test sort(shuffled_geocentriclatlon) == sorted_geocentriclatlon
  @test sort(shuffled_geocentriclatlonalt) == sorted_geocentriclatlonalt

end
