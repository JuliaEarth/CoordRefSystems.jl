@testset "Promotion" begin
  # Projected and Projected
  c1 = Mercator(T(1), T(1))
  c2 = PlateCarree(1.0, 1.0)
  c3 = Lambert(1.0f0, 1.0f0)
  cs = promote(c1, c2)
  @test all(c -> c isa Behrmann, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == Float64
  cs = promote(c1, c3)
  @test all(c -> c isa Behrmann, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Projected and Projected (different datums)
  c1 = Mercator(T(1), T(1))
  c2 = PlateCarree{NAD83}(T(1), T(1))
  cs = promote(c1, c2)
  @test all(c -> c isa Behrmann, cs)
  @test all(c -> datum(c) == WGS84Latest, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Projected and Cartesian2D
  c1 = Mercator(T(1), T(1))
  c2 = convert(Cartesian2D, c1)
  cs = promote(c1, c2)
  @test all(c -> c isa Mercator, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Projected and Cartesian2D{NoDatum}
  c1 = Mercator(T(1), T(1))
  c2 = Cartesian(T(1), T(1))
  cs = promote(c1, c2)
  @test all(c -> c isa Mercator, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Projected and Cartesian3D
  c1 = Mercator(T(1), T(1))
  c2 = convert(Cartesian3D, c1)
  cs = promote(c1, c2)
  @test all(c -> c isa Mercator, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Projected and LatLon
  c1 = Mercator(T(1), T(1))
  c2 = convert(LatLon, c1)
  @test all(c -> c isa Mercator, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Polar and Polar
  c1 = Polar(T(1), T(1))
  c2 = Polar(1.0, 1.0)
  c3 = Polar(1.0f0, 1.0f0)
  cs = promote(c1, c2)
  @test all(c -> c isa Polar, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == Float64
  cs = promote(c1, c3)
  @test all(c -> c isa Polar, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cylindrical and Cylindrical
  c1 = Cylindrical(T(1), T(1), T(1))
  c2 = Cylindrical(1.0, 1.0, 1.0)
  c3 = Cylindrical(1.0f0, 1.0f0, 1.0f0)
  cs = promote(c1, c2)
  @test all(c -> c isa Cylindrical, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == Float64
  cs = promote(c1, c3)
  @test all(c -> c isa Cylindrical, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Spherical and Spherical
  c1 = Spherical(T(1), T(1), T(1))
  c2 = Spherical(1.0, 1.0, 1.0)
  c3 = Spherical(1.0f0, 1.0f0, 1.0f0)
  cs = promote(c1, c2)
  @test all(c -> c isa Spherical, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == Float64
  cs = promote(c1, c3)
  @test all(c -> c isa Spherical, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cartesian2D and Cartesian2D
  c1 = Cartesian(T(1), T(1))
  c2 = Cartesian(1.0, 1.0)
  c3 = Cartesian(1.0f0, 1.0f0)
  cs = promote(c1, c2)
  @test all(c -> c isa Cartesian2D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == Float64
  cs = promote(c1, c3)
  @test all(c -> c isa Cartesian2D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cartesian3D and Cartesian3D
  c1 = Cartesian(T(1), T(1), T(1))
  c2 = Cartesian(1.0, 1.0, 1.0)
  c3 = Cartesian(1.0f0, 1.0f0, 1.0f0)
  cs = promote(c1, c2)
  @test all(c -> c isa Cartesian3D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == Float64
  cs = promote(c1, c3)
  @test all(c -> c isa Cartesian3D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cartesian3D and Cartesian3D (different datums)
  c1 = Cartesian{WGS84Latest}(T(1), T(1), T(1))
  c2 = Cartesian{NAD83}(T(1), T(1), T(1))
  cs = promote(c1, c2)
  @test all(c -> c isa Cartesian3D, cs)
  @test all(c -> datum(c) == WGS84Latest, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cartesian2D and Polar
  c1 = Cartesian(T(1), T(1))
  c2 = convert(Polar, c1)
  cs = promote(c1, c2)
  @test all(c -> c isa Cartesian2D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cartesian3D and Cylindrical
  c1 = Cartesian(T(1), T(1), T(1))
  c2 = convert(Cylindrical, c1)
  cs = promote(c1, c2)
  @test all(c -> c isa Cartesian3D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cartesian3D and Spherical
  c1 = Cartesian(T(1), T(1), T(1))
  c2 = convert(Spherical, c1)
  cs = promote(c1, c2)
  @test all(c -> c isa Cartesian3D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # Cartesian3D and LatLon
  c1 = Cartesian{WGS84Latest}(T(6378137.0), T(0), T(0))
  c2 = convert(LatLon, c1)
  cs = promote(c1, c2)
  @test all(c -> c isa Cartesian3D, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # LatLon and LatLon
  c1 = LatLon(T(30), T(60))
  c2 = LatLon(30.0, 60.0)
  c3 = LatLon(30.0f0, 60.0f0)
  cs = promote(c1, c2)
  @test all(c -> c isa LatLon, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == Float64
  cs = promote(c1, c3)
  @test all(c -> c isa LatLon, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # LatLon and LatLon (different datums)
  c1 = LatLon(T(30), T(60))
  c2 = LatLon{NAD83}(T(30), T(60))
  cs = promote(c1, c2)
  @test all(c -> c isa LatLon, cs)
  @test all(c -> datum(c) == WGS84Latest, cs)
  @test allequal(CoordRefSystems.mactype.(cs))
  @test CoordRefSystems.mactype(first(cs)) == T

  # type stability
  c1 = LatLon(T(30), T(60))
  c2 = convert(Mercator, c1)
  c3 = convert(Cartesian, c1)
  @inferred promote(c1, c2)
  @inferred promote(c1, c3)
  @inferred promote(c2, c3)
  @inferred promote(c1, c2, c3)
end
