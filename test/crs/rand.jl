@testset "Random CRS" begin
  @testset "Basic" begin
    rng = StableRNG(123)

    @test rand(rng, Cartesian{NoDatum,1}) isa Cartesian
    @test rand(rng, Cartesian{NoDatum,2}) isa Cartesian
    @test rand(rng, Cartesian{NoDatum,3}) isa Cartesian

    @test rand(rng, Polar{NoDatum}) isa Polar
    @test rand(rng, Polar) isa Polar

    @test rand(rng, Cylindrical{NoDatum}) isa Cylindrical
    @test rand(rng, Cylindrical) isa Cylindrical

    @test rand(rng, Spherical{NoDatum}) isa Spherical
    @test rand(rng, Spherical) isa Spherical
  end

  @testset "Geographic" begin
    rng = StableRNG(123)

    @test rand(rng, GeodeticLatLon{WGS84Latest}) isa GeodeticLatLon
    @test rand(rng, GeodeticLatLon) isa GeodeticLatLon{WGS84Latest}

    @test rand(rng, LatLon{WGS84Latest}) isa LatLon
    @test rand(rng, LatLon) isa LatLon{WGS84Latest}

    @test rand(rng, GeodeticLatLonAlt{WGS84Latest}) isa GeodeticLatLonAlt
    @test rand(rng, GeodeticLatLonAlt) isa GeodeticLatLonAlt{WGS84Latest}

    @test rand(rng, LatLonAlt{WGS84Latest}) isa LatLonAlt
    @test rand(rng, LatLonAlt) isa LatLonAlt{WGS84Latest}

    @test rand(rng, GeocentricLatLon{WGS84Latest}) isa GeocentricLatLon
    @test rand(rng, GeocentricLatLon) isa GeocentricLatLon{WGS84Latest}

    @test rand(rng, AuthalicLatLon{WGS84Latest}) isa AuthalicLatLon
    @test rand(rng, AuthalicLatLon) isa AuthalicLatLon{WGS84Latest}
  end

  @testset "Projected" begin
    rng = StableRNG(123)


  end
end
