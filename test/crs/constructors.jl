@testset "Constructors" begin
  @testset "Basic" begin
    @testset "Cartesian" begin
      @test Cartesian(T(1)) == Cartesian(T(1) * u"m")
      @test Cartesian(T(1), T(1)) == Cartesian(T(1) * u"m", T(1) * u"m")
      @test Cartesian(T(1), T(1), T(1)) == Cartesian(T(1) * u"m", T(1) * u"m", T(1) * u"m")
      @test Cartesian(T(1) * u"m", 1 * u"m") == Cartesian(T(1) * u"m", T(1) * u"m")
      @test Cartesian((T(1), T(1))) == Cartesian((T(1) * u"m", T(1) * u"m"))
      @test Cartesian((T(1), T(1), T(1))) == Cartesian((T(1) * u"m", T(1) * u"m", T(1) * u"m"))
      @test Cartesian((T(1) * u"m", 1 * u"m")) == Cartesian((T(1) * u"m", T(1) * u"m"))

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
      @test allapprox(Polar(T(1) * u"m", T(45) * u"°"), Polar(T(1) * u"m", T(π / 4) * u"rad"))

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
      @test allapprox(
        Cylindrical(T(1) * u"m", T(45) * u"°", T(1) * u"m"),
        Cylindrical(T(1) * u"m", T(π / 4) * u"rad", T(1) * u"m")
      )

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
      @test allapprox(
        Spherical(T(1) * u"m", T(45) * u"°", T(45) * u"°"),
        Spherical(T(1) * u"m", T(π / 4) * u"rad", T(π / 4) * u"rad")
      )

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
  end

  @testset "Geographic" begin
    @testset "GeodeticLatLon" begin
      @test LatLon(T(1), T(1)) == LatLon(T(1) * u"°", T(1) * u"°")
      @test LatLon(T(1) * u"°", 1 * u"°") == LatLon(T(1) * u"°", T(1) * u"°")
      @test allapprox(LatLon(T(π / 4) * u"rad", T(π / 4) * u"rad"), LatLon(T(45) * u"°", T(45) * u"°"))

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
      @test allapprox(
        LatLonAlt(T(π / 4) * u"rad", T(π / 4) * u"rad", T(1) * u"km"),
        LatLonAlt(T(45) * u"°", T(45) * u"°", T(1000) * u"m")
      )

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
      @test allapprox(
        GeocentricLatLon(T(π / 4) * u"rad", T(π / 4) * u"rad"),
        GeocentricLatLon(T(45) * u"°", T(45) * u"°")
      )

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

    @testset "AuthalicLatLon" begin
      @test AuthalicLatLon(T(1), T(1)) == AuthalicLatLon(T(1) * u"°", T(1) * u"°")
      @test AuthalicLatLon(T(1) * u"°", 1 * u"°") == AuthalicLatLon(T(1) * u"°", T(1) * u"°")
      @test allapprox(AuthalicLatLon(T(π / 4) * u"rad", T(π / 4) * u"rad"), AuthalicLatLon(T(45) * u"°", T(45) * u"°"))

      c = AuthalicLatLon(T(1), T(1))
      @test sprint(show, c) == "AuthalicLatLon{WGS84Latest}(lat: 1.0°, lon: 1.0°)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        AuthalicLatLon{WGS84Latest} coordinates
        ├─ lat: 1.0f0°
        └─ lon: 1.0f0°"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        AuthalicLatLon{WGS84Latest} coordinates
        ├─ lat: 1.0°
        └─ lon: 1.0°"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError AuthalicLatLon(T(1), T(1) * u"°")
      @test_throws ArgumentError AuthalicLatLon(T(1) * u"s", T(1) * u"°")
      @test_throws ArgumentError AuthalicLatLon(T(1) * u"°", T(1) * u"s")
      @test_throws ArgumentError AuthalicLatLon(T(1) * u"s", T(1) * u"s")
    end
  end

  @testset "Projected" begin
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

    @testset "TransverseMercator" begin
      TM = CoordRefSystems.TransverseMercator{0.9996,15.0u"°",25.0u"°"}
      @test TM(T(1), T(1)) == TM(T(1) * u"m", T(1) * u"m")
      @test TM(T(1) * u"m", 1 * u"m") == TM(T(1) * u"m", T(1) * u"m")
      @test TM(T(1) * u"km", T(1) * u"km") == TM(T(1000) * u"m", T(1000) * u"m")

      c = TM(T(1), T(1))
      @test sprint(show, c) == "TransverseMercator{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        TransverseMercator{WGS84Latest} coordinates
        ├─ x: 1.0f0 m
        └─ y: 1.0f0 m"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        TransverseMercator{WGS84Latest} coordinates
        ├─ x: 1.0 m
        └─ y: 1.0 m"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError TM(T(1), T(1) * u"m")
      @test_throws ArgumentError TM(T(1) * u"s", T(1) * u"m")
      @test_throws ArgumentError TM(T(1) * u"m", T(1) * u"s")
      @test_throws ArgumentError TM(T(1) * u"s", T(1) * u"s")
    end

    @testset "UTMNorth" begin
      @test UTMNorth{32}(T(1), T(1)) == UTMNorth{32}(T(1) * u"m", T(1) * u"m")
      @test UTMNorth{32}(T(1) * u"m", 1 * u"m") == UTMNorth{32}(T(1) * u"m", T(1) * u"m")
      @test UTMNorth{32}(T(1) * u"km", T(1) * u"km") == UTMNorth{32}(T(1000) * u"m", T(1000) * u"m")

      c = UTMNorth{32}(T(1), T(1))
      @test sprint(show, c) == "UTMNorth{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        UTMNorth{WGS84Latest} coordinates
        ├─ x: 1.0f0 m
        └─ y: 1.0f0 m"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        UTMNorth{WGS84Latest} coordinates
        ├─ x: 1.0 m
        └─ y: 1.0 m"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError UTMNorth{32}(T(1), T(1) * u"m")
      @test_throws ArgumentError UTMNorth{32}(T(1) * u"s", T(1) * u"m")
      @test_throws ArgumentError UTMNorth{32}(T(1) * u"m", T(1) * u"s")
      @test_throws ArgumentError UTMNorth{32}(T(1) * u"s", T(1) * u"s")
      # error: the UTM zone must be an integer between 1 and 60
      @test_throws ArgumentError UTMNorth{61}(T(1), T(1))
    end

    @testset "UTMSouth" begin
      @test UTMSouth{59}(T(1), T(1)) == UTMSouth{59}(T(1) * u"m", T(1) * u"m")
      @test UTMSouth{59}(T(1) * u"m", 1 * u"m") == UTMSouth{59}(T(1) * u"m", T(1) * u"m")
      @test UTMSouth{59}(T(1) * u"km", T(1) * u"km") == UTMSouth{59}(T(1000) * u"m", T(1000) * u"m")

      c = UTMSouth{59}(T(1), T(1))
      @test sprint(show, c) == "UTMSouth{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        UTMSouth{WGS84Latest} coordinates
        ├─ x: 1.0f0 m
        └─ y: 1.0f0 m"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        UTMSouth{WGS84Latest} coordinates
        ├─ x: 1.0 m
        └─ y: 1.0 m"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError UTMSouth{59}(T(1), T(1) * u"m")
      @test_throws ArgumentError UTMSouth{59}(T(1) * u"s", T(1) * u"m")
      @test_throws ArgumentError UTMSouth{59}(T(1) * u"m", T(1) * u"s")
      @test_throws ArgumentError UTMSouth{59}(T(1) * u"s", T(1) * u"s")
      # error: the UTM zone must be an integer between 1 and 60
      @test_throws ArgumentError UTMSouth{61}(T(1), T(1))
    end

    @testset "ShiftedCRS" begin
      ShiftedMercator = CoordRefSystems.shift(Mercator, lonₒ=15.0u"°", xₒ=200.0u"m", yₒ=200.0u"m")
      @test ShiftedMercator(T(1), T(1)) == ShiftedMercator(T(1) * u"m", T(1) * u"m")
      @test ShiftedMercator(T(1) * u"m", 1 * u"m") == ShiftedMercator(T(1) * u"m", T(1) * u"m")
      @test ShiftedMercator(T(1) * u"km", T(1) * u"km") == ShiftedMercator(T(1000) * u"m", T(1000) * u"m")

      c = ShiftedMercator(T(1), T(1))
      @test sprint(show, c) == "ShiftedMercator{WGS84Latest}(x: 1.0 m, y: 1.0 m)"
      if T === Float32
        @test sprint(show, MIME("text/plain"), c) == """
        ShiftedMercator{WGS84Latest} coordinates with lonₒ: 15.0°, xₒ: 200.0 m, yₒ: 200.0 m
        ├─ x: 1.0f0 m
        └─ y: 1.0f0 m"""
      else
        @test sprint(show, MIME("text/plain"), c) == """
        ShiftedMercator{WGS84Latest} coordinates with lonₒ: 15.0°, xₒ: 200.0 m, yₒ: 200.0 m
        ├─ x: 1.0 m
        └─ y: 1.0 m"""
      end

      # error: invalid units for coordinates
      @test_throws ArgumentError ShiftedMercator(T(1), T(1) * u"m")
      @test_throws ArgumentError ShiftedMercator(T(1) * u"s", T(1) * u"m")
      @test_throws ArgumentError ShiftedMercator(T(1) * u"m", T(1) * u"s")
      @test_throws ArgumentError ShiftedMercator(T(1) * u"s", T(1) * u"s")
    end
  end
end
