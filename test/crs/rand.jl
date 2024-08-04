@testset "Random CRS" begin
  @testset "Basic" begin
    rng = StableRNG(123)

    @test rand(rng, Cartesian{NoDatum,1}) isa Cartesian
    @test rand(rng, Cartesian{NoDatum,2}) isa Cartesian
    @test rand(rng, Cartesian{NoDatum,3}) isa Cartesian
    @test rand(rng, Cartesian2D) isa Cartesian
    @test rand(rng, Cartesian3D) isa Cartesian

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

    @test rand(rng, LatLon{WGS84Latest}) isa LatLon{WGS84Latest, Deg{Float64}}
    @test rand(rng, LatLon) isa LatLon{WGS84Latest, Deg{Float64}}
    @test rand(rng, LatLon{WGS84Latest}, 100) isa Vector{LatLon{WGS84Latest, Deg{Float64}}}
    @test rand(rng, LatLon, 100) isa Vector{LatLon{WGS84Latest, Deg{Float64}}}

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

    @test rand(rng, Mercator{WGS84Latest}) isa Mercator
    @test rand(rng, Mercator) isa Mercator{WGS84Latest}

    @test rand(rng, WebMercator{WGS84Latest}) isa WebMercator
    @test rand(rng, WebMercator) isa WebMercator{WGS84Latest}

    @test rand(rng, PlateCarree{WGS84Latest}) isa PlateCarree
    @test rand(rng, PlateCarree) isa PlateCarree{WGS84Latest}

    @test rand(rng, Lambert{WGS84Latest}) isa Lambert
    @test rand(rng, Lambert) isa Lambert{WGS84Latest}

    @test rand(rng, Behrmann{WGS84Latest}) isa Behrmann
    @test rand(rng, Behrmann) isa Behrmann{WGS84Latest}

    @test rand(rng, GallPeters{WGS84Latest}) isa GallPeters
    @test rand(rng, GallPeters) isa GallPeters{WGS84Latest}

    @test rand(rng, WinkelTripel{WGS84Latest}) isa WinkelTripel
    @test rand(rng, WinkelTripel) isa WinkelTripel{WGS84Latest}

    @test rand(rng, Robinson{WGS84Latest}) isa Robinson
    @test rand(rng, Robinson) isa Robinson{WGS84Latest}

    @test rand(rng, OrthoNorth{WGS84Latest}) isa OrthoNorth
    @test rand(rng, OrthoNorth) isa OrthoNorth{WGS84Latest}

    @test rand(rng, OrthoSouth{WGS84Latest}) isa OrthoSouth
    @test rand(rng, OrthoSouth) isa OrthoSouth{WGS84Latest}
  end
end
