@testset "CRS" begin
  @testset "Datum" begin
    c = Cartesian(T(1), T(1))
    @test datum(c) === NoDatum

    c = LatLon(T(1), T(1))
    @test datum(c) === WGS84Latest
  end

  @testset "Cartesian" begin
    @test Cartesian(T(1)) == Cartesian(T(1) * u"m")
    @test Cartesian(T(1), T(1)) == Cartesian(T(1) * u"m", T(1) * u"m")
    @test Cartesian(T(1), T(1), T(1)) == Cartesian(T(1) * u"m", T(1) * u"m", T(1) * u"m")
    @test Cartesian(T(1) * u"m", 1 * u"m") == Cartesian(T(1) * u"m", T(1) * u"m")

    c = Cartesian(T(1))
    @test sprint(show, c) == "Cartesian{NoDatum}(x: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      └─ x: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      └─ x: 1.0 m"""
    end

    c = Cartesian(T(1), T(1))
    @test sprint(show, c) == "Cartesian{NoDatum}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    c = Cartesian(T(1), T(1), T(1))
    @test sprint(show, c) == "Cartesian{NoDatum}(x: 1.0 m, y: 1.0 m, z: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0f0 m
      ├─ y: 1.0f0 m
      └─ z: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x: 1.0 m
      ├─ y: 1.0 m
      └─ z: 1.0 m"""
    end

    c = Cartesian(T(1), T(1), T(1), T(1))
    @test sprint(show, c) == "Cartesian{NoDatum}(x1: 1.0 m, x2: 1.0 m, x3: 1.0 m, x4: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x1: 1.0f0 m
      ├─ x2: 1.0f0 m
      ├─ x3: 1.0f0 m
      └─ x4: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cartesian{NoDatum} coordinates
      ├─ x1: 1.0 m
      ├─ x2: 1.0 m
      ├─ x3: 1.0 m
      └─ x4: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Cartesian(T(1), T(1) * u"m")
    @test_throws ArgumentError Cartesian(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError Cartesian(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError Cartesian(T(1) * u"s", T(1) * u"s")
  end

  @testset "Polar" begin
    @test Polar(T(1), T(1)) == Polar(T(1) * u"m", T(1) * u"rad")
    @test Polar(T(1) * u"m", T(45) * u"°") ≈ Polar(T(1) * u"m", T(π / 4) * u"rad")

    c = Polar(T(1), T(1))
    @test sprint(show, c) == "Polar{NoDatum}(ρ: 1.0 m, ϕ: 1.0 rad)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Polar{NoDatum} coordinates
      ├─ ρ: 1.0f0 m
      └─ ϕ: 1.0f0 rad"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Polar{NoDatum} coordinates
      ├─ ρ: 1.0 m
      └─ ϕ: 1.0 rad"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Polar(T(1), T(1) * u"rad")
    @test_throws ArgumentError Polar(T(1) * u"s", T(1) * u"rad")
    @test_throws ArgumentError Polar(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError Polar(T(1) * u"s", T(1) * u"s")
  end

  @testset "Cylindrical" begin
    @test Cylindrical(T(1), T(1), T(1)) == Cylindrical(T(1) * u"m", T(1) * u"rad", T(1) * u"m")
    @test Cylindrical(T(1) * u"m", T(1) * u"rad", 1 * u"m") == Cylindrical(T(1) * u"m", T(1) * u"rad", T(1) * u"m")
    @test Cylindrical(T(1) * u"m", T(45) * u"°", T(1) * u"m") ≈ Cylindrical(T(1) * u"m", T(π / 4) * u"rad", T(1) * u"m")

    c = Cylindrical(T(1), T(1), T(1))
    @test sprint(show, c) == "Cylindrical{NoDatum}(ρ: 1.0 m, ϕ: 1.0 rad, z: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Cylindrical{NoDatum} coordinates
      ├─ ρ: 1.0f0 m
      ├─ ϕ: 1.0f0 rad
      └─ z: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Cylindrical{NoDatum} coordinates
      ├─ ρ: 1.0 m
      ├─ ϕ: 1.0 rad
      └─ z: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Cylindrical(T(1), T(1) * u"rad", T(1))
    @test_throws ArgumentError Cylindrical(T(1) * u"s", T(1) * u"rad", T(1) * u"m")
    @test_throws ArgumentError Cylindrical(T(1) * u"m", T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError Cylindrical(T(1) * u"m", T(1) * u"rad", T(1) * u"s")
    @test_throws ArgumentError Cylindrical(T(1) * u"s", T(1) * u"s", T(1) * u"s")
  end

  @testset "Spherical" begin
    @test Spherical(T(1), T(1), T(1)) == Spherical(T(1) * u"m", T(1) * u"rad", T(1) * u"rad")
    @test Spherical(T(1) * u"m", T(1) * u"rad", 1 * u"rad") == Spherical(T(1) * u"m", T(1) * u"rad", T(1) * u"rad")
    @test Spherical(T(1) * u"m", T(45) * u"°", T(45) * u"°") ≈
          Spherical(T(1) * u"m", T(π / 4) * u"rad", T(π / 4) * u"rad")

    c = Spherical(T(1), T(1), T(1))
    @test sprint(show, c) == "Spherical{NoDatum}(r: 1.0 m, θ: 1.0 rad, ϕ: 1.0 rad)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Spherical{NoDatum} coordinates
      ├─ r: 1.0f0 m
      ├─ θ: 1.0f0 rad
      └─ ϕ: 1.0f0 rad"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Spherical{NoDatum} coordinates
      ├─ r: 1.0 m
      ├─ θ: 1.0 rad
      └─ ϕ: 1.0 rad"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Spherical(T(1) * u"m", T(1), T(1))
    @test_throws ArgumentError Spherical(T(1) * u"s", T(1) * u"rad", T(1) * u"rad")
    @test_throws ArgumentError Spherical(T(1) * u"m", T(1) * u"s", T(1) * u"rad")
    @test_throws ArgumentError Spherical(T(1) * u"m", T(1) * u"rad", T(1) * u"s")
    @test_throws ArgumentError Spherical(T(1) * u"s", T(1) * u"s", T(1) * u"s")
  end

  @testset "GeodeticLatLon" begin
    @test LatLon(T(1), T(1)) == LatLon(T(1) * u"°", T(1) * u"°")
    @test LatLon(T(1) * u"°", 1 * u"°") == LatLon(T(1) * u"°", T(1) * u"°")
    @test LatLon(T(π / 4) * u"rad", T(π / 4) * u"rad") ≈ LatLon(T(45) * u"°", T(45) * u"°")

    c = LatLon(T(1), T(1))
    @test sprint(show, c) == "GeodeticLatLon{WGS84Latest}(lat: 1.0°, lon: 1.0°)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      GeodeticLatLon{WGS84Latest} coordinates
      ├─ lat: 1.0f0°
      └─ lon: 1.0f0°"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      GeodeticLatLon{WGS84Latest} coordinates
      ├─ lat: 1.0°
      └─ lon: 1.0°"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError LatLon(T(1), T(1) * u"°")
    @test_throws ArgumentError LatLon(T(1) * u"s", T(1) * u"°")
    @test_throws ArgumentError LatLon(T(1) * u"°", T(1) * u"s")
    @test_throws ArgumentError LatLon(T(1) * u"s", T(1) * u"s")
  end

  @testset "GeodeticLatLonAlt" begin
    @test LatLonAlt(T(1), T(1), T(1)) == LatLonAlt(T(1) * u"°", T(1) * u"°", T(1) * u"m")
    @test LatLonAlt(T(1) * u"°", 1 * u"°", T(1) * u"m") == LatLonAlt(T(1) * u"°", T(1) * u"°", T(1) * u"m")
    @test LatLonAlt(T(π / 4) * u"rad", T(π / 4) * u"rad", T(1) * u"km") ≈
          LatLonAlt(T(45) * u"°", T(45) * u"°", T(1000) * u"m")

    c = LatLonAlt(T(1), T(1), T(1))
    @test sprint(show, c) == "GeodeticLatLonAlt{WGS84Latest}(lat: 1.0°, lon: 1.0°, alt: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      GeodeticLatLonAlt{WGS84Latest} coordinates
      ├─ lat: 1.0f0°
      ├─ lon: 1.0f0°
      └─ alt: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      GeodeticLatLonAlt{WGS84Latest} coordinates
      ├─ lat: 1.0°
      ├─ lon: 1.0°
      └─ alt: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError LatLonAlt(T(1), T(1) * u"°", T(1) * u"m")
    @test_throws ArgumentError LatLonAlt(T(1) * u"s", T(1) * u"°", T(1) * u"m")
    @test_throws ArgumentError LatLonAlt(T(1) * u"°", T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError LatLonAlt(T(1) * u"°", T(1) * u"°", T(1) * u"s")
    @test_throws ArgumentError LatLonAlt(T(1) * u"s", T(1) * u"s", T(1) * u"s")
  end

  @testset "GeocentricLatLon" begin
    @test GeocentricLatLon(T(1), T(1)) == GeocentricLatLon(T(1) * u"°", T(1) * u"°")
    @test GeocentricLatLon(T(1) * u"°", 1 * u"°") == GeocentricLatLon(T(1) * u"°", T(1) * u"°")
    @test GeocentricLatLon(T(π / 4) * u"rad", T(π / 4) * u"rad") ≈ GeocentricLatLon(T(45) * u"°", T(45) * u"°")

    c = GeocentricLatLon(T(1), T(1))
    @test sprint(show, c) == "GeocentricLatLon{WGS84Latest}(lat: 1.0°, lon: 1.0°)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      GeocentricLatLon{WGS84Latest} coordinates
      ├─ lat: 1.0f0°
      └─ lon: 1.0f0°"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      GeocentricLatLon{WGS84Latest} coordinates
      ├─ lat: 1.0°
      └─ lon: 1.0°"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError GeocentricLatLon(T(1), T(1) * u"°")
    @test_throws ArgumentError GeocentricLatLon(T(1) * u"s", T(1) * u"°")
    @test_throws ArgumentError GeocentricLatLon(T(1) * u"°", T(1) * u"s")
    @test_throws ArgumentError GeocentricLatLon(T(1) * u"s", T(1) * u"s")
  end

  @testset "Mercator" begin
    @test Mercator(T(1), T(1)) == Mercator(T(1) * u"m", T(1) * u"m")
    @test Mercator(T(1) * u"m", 1 * u"m") == Mercator(T(1) * u"m", T(1) * u"m")
    @test Mercator(T(1) * u"km", T(1) * u"km") == Mercator(T(1000) * u"m", T(1000) * u"m")

    c = Mercator(T(1), T(1))
    @test sprint(show, c) == "Mercator{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Mercator{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Mercator{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Mercator(T(1), T(1) * u"m")
    @test_throws ArgumentError Mercator(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError Mercator(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError Mercator(T(1) * u"s", T(1) * u"s")
  end

  @testset "WebMercator" begin
    @test WebMercator(T(1), T(1)) == WebMercator(T(1) * u"m", T(1) * u"m")
    @test WebMercator(T(1) * u"m", 1 * u"m") == WebMercator(T(1) * u"m", T(1) * u"m")
    @test WebMercator(T(1) * u"km", T(1) * u"km") == WebMercator(T(1000) * u"m", T(1000) * u"m")

    c = WebMercator(T(1), T(1))
    @test sprint(show, c) == "WebMercator{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      WebMercator{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      WebMercator{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError WebMercator(T(1), T(1) * u"m")
    @test_throws ArgumentError WebMercator(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError WebMercator(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError WebMercator(T(1) * u"s", T(1) * u"s")
  end

  @testset "PlateCarree" begin
    @test PlateCarree(T(1), T(1)) == PlateCarree(T(1) * u"m", T(1) * u"m")
    @test PlateCarree(T(1) * u"m", 1 * u"m") == PlateCarree(T(1) * u"m", T(1) * u"m")
    @test PlateCarree(T(1) * u"km", T(1) * u"km") == PlateCarree(T(1000) * u"m", T(1000) * u"m")

    c = PlateCarree(T(1), T(1))
    @test sprint(show, c) == "PlateCarree{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      PlateCarree{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      PlateCarree{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError PlateCarree(T(1), T(1) * u"m")
    @test_throws ArgumentError PlateCarree(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError PlateCarree(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError PlateCarree(T(1) * u"s", T(1) * u"s")
  end

  @testset "Lambert" begin
    @test Lambert(T(1), T(1)) == Lambert(T(1) * u"m", T(1) * u"m")
    @test Lambert(T(1) * u"m", 1 * u"m") == Lambert(T(1) * u"m", T(1) * u"m")
    @test Lambert(T(1) * u"km", T(1) * u"km") == Lambert(T(1000) * u"m", T(1000) * u"m")

    c = Lambert(T(1), T(1))
    @test sprint(show, c) == "Lambert{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Lambert{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Lambert{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Lambert(T(1), T(1) * u"m")
    @test_throws ArgumentError Lambert(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError Lambert(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError Lambert(T(1) * u"s", T(1) * u"s")
  end

  @testset "Behrmann" begin
    @test Behrmann(T(1), T(1)) == Behrmann(T(1) * u"m", T(1) * u"m")
    @test Behrmann(T(1) * u"m", 1 * u"m") == Behrmann(T(1) * u"m", T(1) * u"m")
    @test Behrmann(T(1) * u"km", T(1) * u"km") == Behrmann(T(1000) * u"m", T(1000) * u"m")

    c = Behrmann(T(1), T(1))
    @test sprint(show, c) == "Behrmann{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Behrmann{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Behrmann{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Behrmann(T(1), T(1) * u"m")
    @test_throws ArgumentError Behrmann(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError Behrmann(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError Behrmann(T(1) * u"s", T(1) * u"s")
  end

  @testset "GallPeters" begin
    @test GallPeters(T(1), T(1)) == GallPeters(T(1) * u"m", T(1) * u"m")
    @test GallPeters(T(1) * u"m", 1 * u"m") == GallPeters(T(1) * u"m", T(1) * u"m")
    @test GallPeters(T(1) * u"km", T(1) * u"km") == GallPeters(T(1000) * u"m", T(1000) * u"m")

    c = GallPeters(T(1), T(1))
    @test sprint(show, c) == "GallPeters{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      GallPeters{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      GallPeters{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError GallPeters(T(1), T(1) * u"m")
    @test_throws ArgumentError GallPeters(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError GallPeters(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError GallPeters(T(1) * u"s", T(1) * u"s")
  end

  @testset "WinkelTripel" begin
    @test WinkelTripel(T(1), T(1)) == WinkelTripel(T(1) * u"m", T(1) * u"m")
    @test WinkelTripel(T(1) * u"m", 1 * u"m") == WinkelTripel(T(1) * u"m", T(1) * u"m")
    @test WinkelTripel(T(1) * u"km", T(1) * u"km") == WinkelTripel(T(1000) * u"m", T(1000) * u"m")

    c = WinkelTripel(T(1), T(1))
    @test sprint(show, c) == "WinkelTripel{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      WinkelTripel{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      WinkelTripel{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError WinkelTripel(T(1), T(1) * u"m")
    @test_throws ArgumentError WinkelTripel(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError WinkelTripel(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError WinkelTripel(T(1) * u"s", T(1) * u"s")
  end

  @testset "Robinson" begin
    @test Robinson(T(1), T(1)) == Robinson(T(1) * u"m", T(1) * u"m")
    @test Robinson(T(1) * u"m", 1 * u"m") == Robinson(T(1) * u"m", T(1) * u"m")
    @test Robinson(T(1) * u"km", T(1) * u"km") == Robinson(T(1000) * u"m", T(1000) * u"m")

    c = Robinson(T(1), T(1))
    @test sprint(show, c) == "Robinson{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      Robinson{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      Robinson{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError Robinson(T(1), T(1) * u"m")
    @test_throws ArgumentError Robinson(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError Robinson(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError Robinson(T(1) * u"s", T(1) * u"s")
  end

  @testset "OrthoNorth" begin
    @test OrthoNorth(T(1), T(1)) == OrthoNorth(T(1) * u"m", T(1) * u"m")
    @test OrthoNorth(T(1) * u"m", 1 * u"m") == OrthoNorth(T(1) * u"m", T(1) * u"m")
    @test OrthoNorth(T(1) * u"km", T(1) * u"km") == OrthoNorth(T(1000) * u"m", T(1000) * u"m")

    c = OrthoNorth(T(1), T(1))
    @test sprint(show, c) == "OrthoNorth{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      OrthoNorth{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      OrthoNorth{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError OrthoNorth(T(1), T(1) * u"m")
    @test_throws ArgumentError OrthoNorth(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError OrthoNorth(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError OrthoNorth(T(1) * u"s", T(1) * u"s")
  end

  @testset "OrthoSouth" begin
    @test OrthoSouth(T(1), T(1)) == OrthoSouth(T(1) * u"m", T(1) * u"m")
    @test OrthoSouth(T(1) * u"m", 1 * u"m") == OrthoSouth(T(1) * u"m", T(1) * u"m")
    @test OrthoSouth(T(1) * u"km", T(1) * u"km") == OrthoSouth(T(1000) * u"m", T(1000) * u"m")

    c = OrthoSouth(T(1), T(1))
    @test sprint(show, c) == "OrthoSouth{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
    if T === Float32
      @test sprint(show, MIME("text/plain"), c) == """
      OrthoSouth{WGS84Latest} coordinates
      ├─ x: 1.0f0 m
      └─ y: 1.0f0 m"""
    else
      @test sprint(show, MIME("text/plain"), c) == """
      OrthoSouth{WGS84Latest} coordinates
      ├─ x: 1.0 m
      └─ y: 1.0 m"""
    end

    # error: invalid units for coordinates
    @test_throws ArgumentError OrthoSouth(T(1), T(1) * u"m")
    @test_throws ArgumentError OrthoSouth(T(1) * u"s", T(1) * u"m")
    @test_throws ArgumentError OrthoSouth(T(1) * u"m", T(1) * u"s")
    @test_throws ArgumentError OrthoSouth(T(1) * u"s", T(1) * u"s")
  end

  @testset "conversions" begin
    atol = Cartography.atol(T) * u"m"
    @testset "Cartesian <> Polar" begin
      c1 = Cartesian(T(1), T(1))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(√2), T(π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(-T(1), T(1))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(√2), T(3π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(-T(1), -T(1))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(√2), T(5π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(T(1), -T(1))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(√2), T(7π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(T(0), T(1))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(1), T(π / 2))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(0), -T(1))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(1), T(3π / 2))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(1), T(0))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(1), T(0))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(-T(1), T(0))
      c2 = convert(Polar, c1)
      @test c2 ≈ Polar(T(1), T(π))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      # type stability
      c1 = Cartesian(T(1), T(1))
      c2 = Polar(T(√2), T(π / 4))
      @inferred convert(Polar, c1)
      @inferred convert(Cartesian, c2)
    end

    @testset "Cartesian <> Cylindrical" begin
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(√2), T(π / 4), T(1))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(-T(1), T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(√2), T(3π / 4), T(1))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(-T(1), -T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(√2), T(5π / 4), T(1))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(T(1), -T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(√2), T(7π / 4), T(1))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(T(0), T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(1), T(π / 2), T(1))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(0), -T(1), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(1), T(3π / 2), T(1))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(1), T(0), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(1), T(0), T(1))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(-T(1), T(0), T(1))
      c2 = convert(Cylindrical, c1)
      @test c2 ≈ Cylindrical(T(1), T(π), T(1))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      # type stability
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = Cylindrical(T(√2), T(π / 4), T(1))
      @inferred convert(Cylindrical, c1)
      @inferred convert(Cartesian, c2)
    end

    @testset "Cartesian <> Spherical" begin
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√3), atan(T(√2)), T(π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(-T(1), T(1), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√3), atan(T(√2)), T(3π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(-T(1), -T(1), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√3), atan(T(√2)), T(5π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(T(1), -T(1), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√3), atan(T(√2)), T(7π / 4))
      c3 = convert(Cartesian, c2)
      @test c3 ≈ c1

      c1 = Cartesian(T(0), T(1), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√2), T(π / 4), T(π / 2))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(0), -T(1), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√2), T(π / 4), T(3π / 2))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(T(1), T(0), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√2), T(π / 4), T(0))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      c1 = Cartesian(-T(1), T(0), T(1))
      c2 = convert(Spherical, c1)
      @test c2 ≈ Spherical(T(√2), T(π / 4), T(π))
      c3 = convert(Cartesian, c2)
      @test isapprox(c3, c1; atol)

      # type stability
      c1 = Cartesian(T(1), T(1), T(1))
      c2 = Spherical(T(√3), atan(T(√2)), T(π / 4))
      @inferred convert(Spherical, c1)
      @inferred convert(Cartesian, c2)
    end

    @testset "Cartesian: Datum conversion" begin
      # WGS84 (G1762) to ITRF2008
      c1 = Cartesian{WGS84Latest}(T(0), T(0), T(0))
      c2 = convert(Cartesian{ITRF{2008}}, c1)
      @test c2 ≈ Cartesian{ITRF{2008}}(T(0), T(0), T(0))

      c1 = Cartesian{WGS84Latest}(T(1), T(1), T(1))
      c2 = convert(Cartesian{ITRF{2008}}, c1)
      @test c2 ≈ Cartesian{ITRF{2008}}(T(1), T(1), T(1))

      # ITRF2008 to ITRF2020
      c1 = Cartesian{ITRF{2008}}(T(0), T(0), T(0))
      c2 = convert(Cartesian{ITRFLatest}, c1)
      @test c2 ≈ Cartesian{ITRFLatest}(T(-0.0002), T(-0.002), T(-0.0023))

      c1 = Cartesian{ITRF{2008}}(T(1), T(1), T(1))
      c2 = convert(Cartesian{ITRFLatest}, c1)
      @test c2 ≈ Cartesian{ITRFLatest}(T(0.9998000005900001), T(0.99800000059), T(0.9977000005900001))

      c1 = Cartesian{WGS84Latest}(T(0), T(0), T(0))
      c2 = Cartesian{ITRF{2008}}(T(0), T(0), T(0))
      @inferred convert(Cartesian{ITRF{2008}}, c1)
      @inferred convert(Cartesian{ITRFLatest}, c2)
    end

    @testset "GeodeticLatLon <> GeocentricLatLon" begin
      c1 = LatLon(T(30), T(40))
      c2 = convert(GeocentricLatLon{WGS84Latest}, c1)
      @test c2 ≈ GeocentricLatLon(T(29.833635809829065), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(35), T(40))
      c2 = convert(GeocentricLatLon{WGS84Latest}, c1)
      @test c2 ≈ GeocentricLatLon(T(34.819388702349606), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(40), T(40))
      c2 = convert(GeocentricLatLon{WGS84Latest}, c1)
      @test c2 ≈ GeocentricLatLon(T(39.810610551928434), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(30), T(40))
      c2 = convert(GeocentricLatLon{WGS84Latest}, c1)
      @test c2 ≈ GeocentricLatLon(-T(29.833635809829065), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(35), T(40))
      c2 = convert(GeocentricLatLon{WGS84Latest}, c1)
      @test c2 ≈ GeocentricLatLon(-T(34.819388702349606), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(40), T(40))
      c2 = convert(GeocentricLatLon{WGS84Latest}, c1)
      @test c2 ≈ GeocentricLatLon(-T(39.810610551928434), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(30), T(40))
      c2 = GeocentricLatLon(T(29.833635809829065), T(40))
      @inferred convert(GeocentricLatLon{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "GeodeticLatLon <> AuthalicLatLon" begin
      c1 = LatLon(T(30), T(40))
      c2 = convert(AuthalicLatLon{WGS84Latest}, c1)
      @test c2 ≈ AuthalicLatLon(T(29.888997034459567), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(35), T(40))
      c2 = convert(AuthalicLatLon{WGS84Latest}, c1)
      @test c2 ≈ AuthalicLatLon(T(34.87951854973729), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(40), T(40))
      c2 = convert(AuthalicLatLon{WGS84Latest}, c1)
      @test c2 ≈ AuthalicLatLon(T(39.87369373453432), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(30), T(40))
      c2 = convert(AuthalicLatLon{WGS84Latest}, c1)
      @test c2 ≈ AuthalicLatLon(-T(29.888997034459567), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(35), T(40))
      c2 = convert(AuthalicLatLon{WGS84Latest}, c1)
      @test c2 ≈ AuthalicLatLon(-T(34.87951854973729), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(40), T(40))
      c2 = convert(AuthalicLatLon{WGS84Latest}, c1)
      @test c2 ≈ AuthalicLatLon(-T(39.87369373453432), T(40))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(30), T(40))
      c2 = AuthalicLatLon(T(29.888997034459567), T(40))
      @inferred convert(AuthalicLatLon{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> Cartesian" begin
      c1 = LatLon(T(30), T(40))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c2 ≈ Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(35), T(45))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c2 ≈ Cartesian{WGS84Latest}(T(3698470.287205801), T(3698470.2872058), T(3637866.909378095))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(40), T(50))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c2 ≈ Cartesian{WGS84Latest}(T(3144971.82314589), T(3748031.468841677), T(4077985.572200376))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(30), -T(40))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c2 ≈ Cartesian{WGS84Latest}(T(4234890.278665873), -T(3553494.8709047823), -T(3170373.735383637))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(35), T(45))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c2 ≈ Cartesian{WGS84Latest}(T(3698470.287205801), T(3698470.2872058), -T(3637866.909378095))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(40), -T(50))
      c2 = convert(Cartesian{WGS84Latest}, c1)
      @test c2 ≈ Cartesian{WGS84Latest}(T(3144971.82314589), -T(3748031.468841677), T(4077985.572200376))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(30), T(40))
      c2 = Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637))
      @inferred convert(Cartesian{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    if T === Float64
      # altitude can only be calculated accurately using Float64
      @testset "LatLonAlt <> Cartesian" begin
        c1 = LatLonAlt(T(30), T(40), T(0))
        c2 = convert(Cartesian{WGS84Latest}, c1)
        @test c2 ≈ Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637))
        c3 = convert(LatLonAlt{WGS84Latest}, c2)
        @test c3 ≈ c1

        c1 = LatLonAlt(T(35), T(45), T(100))
        c2 = convert(Cartesian{WGS84Latest}, c1)
        @test c2 ≈ Cartesian{WGS84Latest}(T(3698528.2100023343), T(3698528.2100023334), T(3637924.26702173))
        c3 = convert(LatLonAlt{WGS84Latest}, c2)
        @test c3 ≈ c1

        c1 = LatLonAlt(T(40), T(50), T(200))
        c2 = convert(Cartesian{WGS84Latest}, c1)
        @test c2 ≈ Cartesian{WGS84Latest}(T(3145070.3039211915), T(3748148.8336594435), T(4078114.1297223135))
        c3 = convert(LatLonAlt{WGS84Latest}, c2)
        @test c3 ≈ c1

        c1 = LatLonAlt(-T(30), -T(40), T(0))
        c2 = convert(Cartesian{WGS84Latest}, c1)
        @test c2 ≈ Cartesian{WGS84Latest}(T(4234890.278665873), -T(3553494.8709047823), -T(3170373.735383637))
        c3 = convert(LatLonAlt{WGS84Latest}, c2)
        @test c3 ≈ c1

        c1 = LatLonAlt(-T(35), T(45), T(100))
        c2 = convert(Cartesian{WGS84Latest}, c1)
        @test c2 ≈ Cartesian{WGS84Latest}(T(3698528.2100023343), T(3698528.2100023334), -T(3637924.26702173))
        c3 = convert(LatLonAlt{WGS84Latest}, c2)
        @test c3 ≈ c1

        c1 = LatLonAlt(T(40), -T(50), T(200))
        c2 = convert(Cartesian{WGS84Latest}, c1)
        @test c2 ≈ Cartesian{WGS84Latest}(T(3145070.3039211915), -T(3748148.8336594435), T(4078114.1297223135))
        c3 = convert(LatLonAlt{WGS84Latest}, c2)
        @test c3 ≈ c1

        # type stability
        c1 = LatLonAlt(T(30), T(40), T(0))
        c2 = Cartesian{WGS84Latest}(T(4234890.278665873), T(3553494.8709047823), T(3170373.735383637))
        @inferred convert(Cartesian{WGS84Latest}, c1)
        @inferred convert(LatLonAlt{WGS84Latest}, c2)
      end
    end

    @testset "LatLon: Datum conversion" begin
      # WGS84 (G1762) to ITRF2008
      c1 = LatLon(T(30), T(40))
      c2 = convert(LatLon{ITRF{2008}}, c1)
      @test c2 ≈ LatLon{ITRF{2008}}(T(30), T(40))

      c1 = LatLon(T(35), T(45))
      c2 = convert(LatLon{ITRF{2008}}, c1)
      @test c2 ≈ LatLon{ITRF{2008}}(T(35), T(45))

      # ITRF2008 to ITRF2020
      c1 = LatLon{ITRF{2008}}(T(30), T(40))
      c2 = convert(LatLon{ITRFLatest}, c1)
      @test c2 ≈ LatLon{ITRFLatest}(T(29.999999988422587), T(39.99999998545356))

      c1 = LatLon{ITRF{2008}}(T(35), T(45))
      c2 = convert(LatLon{ITRFLatest}, c1)
      @test c2 ≈ LatLon{ITRFLatest}(T(34.99999999095351), T(44.99999998605742))

      # GGRS87 to WGS84
      c1 = LatLon{GGRS87}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(T(30.00192882268015), T(40.002486991945155))

      c1 = LatLon{GGRS87}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(T(35.00223103195274), T(45.00233792216629))

      # NAD83 to WGS84
      c1 = LatLon{NAD83}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(T(30), T(40))

      c1 = LatLon{NAD83}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(T(35), T(45))

      # Potsdam to WGS84
      c1 = LatLon{Potsdam}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(29.996517848254378, 40.00027867741483)

      c1 = LatLon{Potsdam}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(34.995680137764744, 44.99989350030216)

      # Potsdam to WGS84
      c1 = LatLon{Potsdam}(T(30), T(40))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(29.996517848254378, 40.00027867741483)

      c1 = LatLon{Potsdam}(T(35), T(45))
      c2 = convert(LatLon{WGS84Latest}, c1)
      @test c2 ≈ LatLon{WGS84Latest}(34.995680137764744, 44.99989350030216)

      c1 = LatLon(T(30), T(40))
      c2 = LatLon{ITRF{2008}}(T(30), T(40))
      @inferred convert(LatLon{ITRF{2008}}, c1)
      @inferred convert(LatLon{ITRFLatest}, c2)
    end

    @testset "LatLon <> Mercator" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Mercator{WGS84Latest}, c1)
      @test c2 ≈ Mercator(T(10018754.171394622), T(5591295.9185533915))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Mercator{WGS84Latest}, c1)
      @test c2 ≈ Mercator(T(10018754.171394622), -T(5591295.9185533915))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Mercator{WGS84Latest}, c1)
      @test c2 ≈ Mercator(-T(10018754.171394622), T(5591295.9185533915))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Mercator{WGS84Latest}, c1)
      @test c2 ≈ Mercator(-T(10018754.171394622), -T(5591295.9185533915))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Mercator(T(10018754.171394622), T(5591295.9185533915))
      @inferred convert(Mercator{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> WebMercator" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(WebMercator{WGS84Latest}, c1)
      @test c2 ≈ WebMercator(T(10018754.171394622), T(5621521.486192066))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(WebMercator{WGS84Latest}, c1)
      @test c2 ≈ WebMercator(T(10018754.171394622), -T(5621521.486192066))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(WebMercator{WGS84Latest}, c1)
      @test c2 ≈ WebMercator(-T(10018754.171394622), T(5621521.486192066))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(WebMercator{WGS84Latest}, c1)
      @test c2 ≈ WebMercator(-T(10018754.171394622), -T(5621521.486192066))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = WebMercator(T(10018754.171394622), T(5621521.486192066))
      @inferred convert(WebMercator{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> PlateCarree" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(PlateCarree{WGS84Latest}, c1)
      @test c2 ≈ PlateCarree(T(10018754.171394622), T(5009377.085697311))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(PlateCarree{WGS84Latest}, c1)
      @test c2 ≈ PlateCarree(T(10018754.171394622), -T(5009377.085697311))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(PlateCarree{WGS84Latest}, c1)
      @test c2 ≈ PlateCarree(-T(10018754.171394622), T(5009377.085697311))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(PlateCarree{WGS84Latest}, c1)
      @test c2 ≈ PlateCarree(-T(10018754.171394622), -T(5009377.085697311))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = PlateCarree(T(10018754.171394622), T(5009377.085697311))
      @inferred convert(PlateCarree{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> Lambert" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Lambert{WGS84Latest}, c1)
      @test c2 ≈ Lambert(T(10018754.171394622), T(4489858.8869480025))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Lambert{WGS84Latest}, c1)
      @test c2 ≈ Lambert(T(10018754.171394622), -T(4489858.8869480025))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Lambert{WGS84Latest}, c1)
      @test c2 ≈ Lambert(-T(10018754.171394622), T(4489858.8869480025))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Lambert{WGS84Latest}, c1)
      @test c2 ≈ Lambert(-T(10018754.171394622), -T(4489858.8869480025))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Lambert(T(10018754.171394622), T(4489858.8869480025))
      @inferred convert(Lambert{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> Behrmann" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Behrmann{WGS84Latest}, c1)
      @test c2 ≈ Behrmann(T(8683765.222580686), T(5180102.328839251))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Behrmann{WGS84Latest}, c1)
      @test c2 ≈ Behrmann(T(8683765.222580686), -T(5180102.328839251))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Behrmann{WGS84Latest}, c1)
      @test c2 ≈ Behrmann(-T(8683765.222580686), T(5180102.328839251))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Behrmann{WGS84Latest}, c1)
      @test c2 ≈ Behrmann(-T(8683765.222580686), -T(5180102.328839251))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Behrmann(T(8683765.222580686), T(5180102.328839251))
      @inferred convert(Behrmann{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> GallPeters" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(GallPeters{WGS84Latest}, c1)
      @test c2 ≈ GallPeters(T(7096215.158458031), T(6338983.732612475))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(GallPeters{WGS84Latest}, c1)
      @test c2 ≈ GallPeters(T(7096215.158458031), -T(6338983.732612475))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(GallPeters{WGS84Latest}, c1)
      @test c2 ≈ GallPeters(-T(7096215.158458031), T(6338983.732612475))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(GallPeters{WGS84Latest}, c1)
      @test c2 ≈ GallPeters(-T(7096215.158458031), -T(6338983.732612475))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = GallPeters(T(7096215.158458031), T(6338983.732612475))
      @inferred convert(GallPeters{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> WinkelTripel" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(WinkelTripel{WGS84Latest}, c1)
      @test c2 ≈ WinkelTripel(T(7044801.6979576545), T(5231448.051548355))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(WinkelTripel{WGS84Latest}, c1)
      @test c2 ≈ WinkelTripel(T(7044801.6979576545), -T(5231448.051548355))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(WinkelTripel{WGS84Latest}, c1)
      @test c2 ≈ WinkelTripel(-T(7044801.6979576545), T(5231448.051548355))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(WinkelTripel{WGS84Latest}, c1)
      @test c2 ≈ WinkelTripel(-T(7044801.6979576545), -T(5231448.051548355))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(0), T(0))
      c2 = convert(WinkelTripel{WGS84Latest}, c1)
      @test c2 ≈ WinkelTripel(T(0), T(0))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = WinkelTripel(T(7044801.6979576545), T(5231448.051548355))
      @inferred convert(WinkelTripel{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> Robinson" begin
      c1 = LatLon(T(45), T(90))
      c2 = convert(Robinson{WGS84Latest}, c1)
      @test c2 ≈ Robinson(T(7620313.925950073), T(4805073.646653474))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), T(90))
      c2 = convert(Robinson{WGS84Latest}, c1)
      @test c2 ≈ Robinson(T(7620313.925950073), -T(4805073.646653474))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(45), -T(90))
      c2 = convert(Robinson{WGS84Latest}, c1)
      @test c2 ≈ Robinson(-T(7620313.925950073), T(4805073.646653474))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(45), -T(90))
      c2 = convert(Robinson{WGS84Latest}, c1)
      @test c2 ≈ Robinson(-T(7620313.925950073), -T(4805073.646653474))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(45), T(90))
      c2 = Robinson(T(7620313.925950073), T(4805073.646653474))
      @inferred convert(Robinson{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> OrthoNorth" begin
      c1 = LatLon(T(30), T(60))
      c2 = convert(OrthoNorth{WGS84Latest}, c1)
      @test c2 ≈ OrthoNorth(T(4787610.688267582), T(-2764128.319646418))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(30), -T(60))
      c2 = convert(OrthoNorth{WGS84Latest}, c1)
      @test c2 ≈ OrthoNorth(-T(4787610.688267582), T(-2764128.319646418))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(30), T(60))
      c2 = OrthoNorth(T(4787610.688267582), T(-2764128.319646418))
      @inferred convert(OrthoNorth{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> OrthoSouth" begin
      c1 = LatLon(-T(30), T(60))
      c2 = convert(OrthoSouth{WGS84Latest}, c1)
      @test c2 ≈ OrthoSouth(T(4787610.688267582), T(2764128.319646418))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(30), -T(60))
      c2 = convert(OrthoSouth{WGS84Latest}, c1)
      @test c2 ≈ OrthoSouth(-T(4787610.688267582), T(2764128.319646418))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(-T(30), T(60))
      c2 = OrthoSouth(T(4787610.688267582), T(2764128.319646418))
      @inferred convert(OrthoSouth{WGS84Latest}, c1)
      @inferred convert(LatLon{WGS84Latest}, c2)
    end

    @testset "LatLon <> OrthoSpherical" begin
      OrthoNorthSpherical = Cartography.crs(ESRI{102035})
      OrthoSouthSpherical = Cartography.crs(ESRI{102037})

      c1 = LatLon(T(30), T(60))
      c2 = convert(OrthoNorthSpherical, c1)
      @test c2 ≈ OrthoNorthSpherical(T(4783602.75), T(-2761814.335408735))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(T(30), -T(60))
      c2 = convert(OrthoNorthSpherical, c1)
      @test c2 ≈ OrthoNorthSpherical(-T(4783602.75), T(-2761814.335408735))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(30), T(60))
      c2 = convert(OrthoSouthSpherical, c1)
      @test c2 ≈ OrthoSouthSpherical(T(4783602.75), T(2761814.335408735))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      c1 = LatLon(-T(30), -T(60))
      c2 = convert(OrthoSouthSpherical, c1)
      @test c2 ≈ OrthoSouthSpherical(-T(4783602.75), T(2761814.335408735))
      c3 = convert(LatLon{WGS84Latest}, c2)
      @test c3 ≈ c1

      # type stability
      c1 = LatLon(T(30), T(60))
      c2 = LatLon(-T(30), T(60))
      c3 = OrthoNorthSpherical(T(4783602.75), T(-2761814.335408735))
      c4 = OrthoSouthSpherical(T(4783602.75), T(2761814.335408735))
      @inferred convert(OrthoNorthSpherical, c1)
      @inferred convert(OrthoSouthSpherical, c2)
      @inferred convert(LatLon{WGS84Latest}, c3)
      @inferred convert(LatLon{WGS84Latest}, c4)
    end

    @testset "Projection conversion" begin
      # same datum
      c1 = Lambert(T(10018754.171394622), T(4489858.8869480025))
      c2 = convert(WinkelTripel{WGS84Latest}, c1)
      @test c2 ≈ WinkelTripel(T(7044801.69820402), T(5231448.051016482))

      c1 = WinkelTripel(T(7044801.6979576545), T(5231448.051548355))
      c2 = convert(Robinson{WGS84Latest}, c1)
      @test c2 ≈ Robinson(T(7620313.9259500755), T(4805073.646653474))

      # different datums
      c1 = Lambert{ITRF{2008}}(T(10018754.171394622), T(4489858.886849141))
      c2 = convert(WinkelTripel{ITRFLatest}, c1)
      @test c2 ≈ WinkelTripel{ITRFLatest}(T(7044801.699171027), T(5231448.049360464))

      c1 = WinkelTripel{ITRF{2008}}(T(7044801.697957653), T(5231448.051548355))
      c2 = convert(Robinson{ITRFLatest}, c1)
      @test c2 ≈ Robinson{ITRFLatest}(T(7620313.811209339), T(4805075.1317550065))

      c1 = Lambert(T(10018754.171394622), T(4489858.8869480025))
      c2 = Lambert{ITRF{2008}}(T(10018754.171394622), T(4489858.886849141))
      @inferred convert(WinkelTripel{WGS84Latest}, c1)
      @inferred convert(WinkelTripel{ITRFLatest}, c2)
    end
  end

  @testset "Projection domain" begin
    @testset "Mercator" begin
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(Mercator, c1)
          c2 = convert(Mercator{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test c3 ≈ c1
        else
          @test_throws ArgumentError convert(Mercator{WGS84Latest}, c1)
        end
      end
    end

    @testset "WebMercator" begin
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(WebMercator, c1)
          c2 = convert(WebMercator{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test c3 ≈ c1
        else
          @test_throws ArgumentError convert(WebMercator{WGS84Latest}, c1)
        end
      end
    end

    @testset "PlateCarree" begin
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(PlateCarree, c1)
          c2 = convert(PlateCarree{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test c3 ≈ c1
        else
          @test_throws ArgumentError convert(PlateCarree{WGS84Latest}, c1)
        end
      end
    end

    @testset "Lambert" begin
      atol = T === Float32 ? 1.0f-2u"°" : 1e-4u"°"
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(Lambert, c1)
          c2 = convert(Lambert{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test isapprox(c3, c1; atol)
        else
          @test_throws ArgumentError convert(Lambert{WGS84Latest}, c1)
        end
      end
    end

    @testset "Behrmann" begin
      atol = T === Float32 ? 1.0f-2u"°" : 1e-4u"°"
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(Behrmann, c1)
          c2 = convert(Behrmann{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test isapprox(c3, c1; atol)
        else
          @test_throws ArgumentError convert(Behrmann{WGS84Latest}, c1)
        end
      end
    end

    @testset "GallPeters" begin
      atol = T === Float32 ? 1.0f-2u"°" : 1e-4u"°"
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(GallPeters, c1)
          c2 = convert(GallPeters{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test isapprox(c3, c1; atol)
        else
          @test_throws ArgumentError convert(GallPeters{WGS84Latest}, c1)
        end
      end
    end

    @testset "WinkelTripel" begin
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(WinkelTripel, c1)
          c2 = convert(WinkelTripel{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test c3 ≈ c1
        else
          @test_throws ArgumentError convert(WinkelTripel{WGS84Latest}, c1)
        end
      end
    end

    @testset "Robinson" begin
      atol = T(1e-3) * u"°"
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(Robinson, c1)
          c2 = convert(Robinson{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test isapprox(c3, c1; atol)
        else
          @test_throws ArgumentError convert(Robinson{WGS84Latest}, c1)
        end
      end
    end

    @testset "OrthoNorth forward" begin
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(OrthoNorth, c1)
          c2 = convert(OrthoNorth{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
        else
          @test_throws ArgumentError convert(OrthoNorth{WGS84Latest}, c1)
        end
      end
    end

    @testset "OrthoNorth inverse" begin
      # coordinates at the singularity of the projection (lat ≈ 90) cannot be inverted
      for lat in T.(1:89), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(OrthoNorth, c1)
          c2 = convert(OrthoNorth{WGS84Latest}, c1)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test c3 ≈ c1
        end
      end

      # coordinates at the edge of the projection (lat ≈ 0)
      # cannot be accurately inverted by numerical problems
      atol = T(0.5) * u"°"
      for lon in T.(-180:180)
        c1 = LatLon(T(0), lon)
        if indomain(OrthoNorth, c1)
          c2 = convert(OrthoNorth{WGS84Latest}, c1)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test isapprox(c3, c1; atol)
        end
      end
    end

    @testset "OrthoSouth forward" begin
      for lat in T.(-90:90), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(OrthoSouth, c1)
          c2 = convert(OrthoSouth{WGS84Latest}, c1)
          @test isnum(c2.x)
          @test isnum(c2.y)
        else
          @test_throws ArgumentError convert(OrthoSouth{WGS84Latest}, c1)
        end
      end
    end

    @testset "OrthoSouth inverse" begin
      # coordinates at the singularity of the projection (lat ≈ -90) cannot be inverted
      for lat in T.(-89:-1), lon in T.(-180:180)
        c1 = LatLon(lat, lon)
        if indomain(OrthoSouth, c1)
          c2 = convert(OrthoSouth{WGS84Latest}, c1)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test c3 ≈ c1
        end
      end

      # coordinates at the edge of the projection (lat ≈ 0)
      # cannot be accurately inverted by numerical problems
      atol = T(0.5) * u"°"
      for lon in T.(-180:180)
        c1 = LatLon(T(0), lon)
        if indomain(OrthoSouth, c1)
          c2 = convert(OrthoSouth{WGS84Latest}, c1)
          c3 = convert(LatLon{WGS84Latest}, c2)
          @test isapprox(c3, c1; atol)
        end
      end
    end
  end
end
