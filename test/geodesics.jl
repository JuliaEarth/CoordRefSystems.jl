@testset "geodesics" begin
  # the azimuth is only defined for points on the ellipsoid
  @test_throws ArgumentError geodesicfwd(Cartesian(0, 0), 90, 1000)
  @test_throws ArgumentError geodesicbwd(Cartesian(0, 0), Cartesian(1, 1))

  # walking nowhere leaves the point where it is
  c = LatLon(T(45), T(10))
  @test geodesicfwd(c, 30, 0) ≈ c

  # a quarter of the equator to the east
  a = majoraxis(ellipsoid(WGS84Latest))
  @test isapprox(geodesicfwd(LatLon(T(0), T(0)), 90u"°", π * a / 2), LatLon(T(0), T(90)))

  # the azimuth of a meridian is due north or due south
  @test geodesicbwd(LatLon(T(10), T(20)), LatLon(T(30), T(20))) ≈ T(0) * u"°" atol = 1e-6u"°"
  @test geodesicbwd(LatLon(T(30), T(20)), LatLon(T(10), T(20))) ≈ T(180) * u"°" atol = 1e-6u"°"

  # the azimuth along the equator is due east or due west
  @test geodesicbwd(LatLon(T(0), T(0)), LatLon(T(0), T(10))) ≈ T(90) * u"°" atol = 1e-6u"°"
  @test geodesicbwd(LatLon(T(0), T(10)), LatLon(T(0), T(0))) ≈ T(-90) * u"°" atol = 1e-6u"°"

  # units are optional, and the result carries them
  @test geodesicfwd(c, 30u"°", 100u"km") ≈ geodesicfwd(c, 30, 100000)
  ϕ = geodesicbwd(c, LatLon(T(46), T(11)))
  @test unit(ϕ) == u"°"
  @test Unitful.numtype(ϕ) === T

  # walking along the azimuth that connects two points lands on the second one
  c₁ = LatLon(T(-33.8688), T(151.2093))
  c₂ = LatLon(T(51.5074), T(-0.1278))
  @test isapprox(geodesicfwd(c₁, geodesicbwd(c₁, c₂), geodesicdistance(c₁, c₂)), c₂)

  if T === Float64
    # the ellipsoid comes from the datum
    c₁ = LatLon(T(-33.8688), T(151.2093))
    c₂ = LatLon(T(51.5074), T(-0.1278))
    c₁′ = LatLon{ITRF{2008}}(T(-33.8688), T(151.2093))
    c₂′ = LatLon{ITRF{2008}}(T(51.5074), T(-0.1278))
    @test geodesicbwd(c₁′, c₂′) ≠ geodesicbwd(c₁, c₂)

    # reference values from the test set of Karney (2013)
    # https://geographiclib.sourceforge.io/C++/doc/geodesic.html#testgeod
    τϕ = 1e-9u"°"
    cases = [
      (
        2.881248229541,
        0.0,
        27.763592972746,
        53.997072295385487,
        44.520619105667620,
        52.159486739947740,
        6958264.1576889
      ),
      (
        65.656162297631,
        0.0,
        176.971135321064,
        -6.529066987956306,
        2.895923948124536,
        178.740350145953805,
        8009999.3798375
      ),
      (
        75.511482283510,
        0.0,
        83.078727908415,
        55.600487151982554,
        75.128743229495482,
        153.896688535571762,
        3723062.6140266
      )
    ]
    for (lat₁, lon₁, azi₁, lat₂, lon₂, azi₂, s₁₂) in cases
      ll₁ = LatLon(lat₁, lon₁)
      ll₂ = LatLon(lat₂, lon₂)
      # inverse problem: the azimuth at each end
      @test isapprox(geodesicbwd(ll₁, ll₂), azi₁ * u"°", atol=τϕ)
      @test isapprox(geodesicbwd(ll₂, ll₁), (azi₂ - 180) * u"°", atol=τϕ)
      # direct problem: the point reached and the distance to it
      @test isapprox(geodesicfwd(ll₁, azi₁, s₁₂), ll₂)
      @test isapprox(geodesicdistance(ll₁, geodesicfwd(ll₁, azi₁, s₁₂)), s₁₂ * u"m", atol=1e-7u"m")
    end

    # on a datum with a spherical ellipsoid the azimuth is the great circle one
    c₁ = LatLon{GRS80S}(T(10), T(20))
    c₂ = LatLon{GRS80S}(T(30), T(50))
    Δ = deg2rad(50 - 20)
    greatcircle = atand(
      cos(deg2rad(30)) * sin(Δ),
      cos(deg2rad(10)) * sin(deg2rad(30)) - sin(deg2rad(10)) * cos(deg2rad(30)) * cos(Δ)
    )
    @test isapprox(geodesicbwd(c₁, c₂), greatcircle * u"°", atol=1e-9u"°")
  end

  # taking the direction from a chord differences two geocentric vectors of
  # about 6400 km, which leaves little of a Float32 mantissa for a short chord
  τϕ = T === Float64 ? 1e-2u"°" : 1u"°"

  # tangent vectors and azimuths are only defined on the ellipsoid
  @test_throws MethodError geodesictangent(Cartesian(0, 0, 0), 90)
  @test_throws MethodError geodesicazimuth(Cartesian(0, 0, 0), (0, 1, 0))

  # the frame at the origin of the coordinates is aligned with the axes
  c = LatLon(T(0), T(0))
  @test geodesictangent(c, 0) ≈ [0, 0, 1] * u"m"
  @test geodesictangent(c, 90) ≈ [0, 1, 0] * u"m"
  @test geodesictangent(c, 180) ≈ [0, 0, -1] * u"m"

  # the vector is a unit vector in the length unit of the point
  for ϕ in (T(0), T(37), T(90), T(143), T(180), T(-75))
    @test isapprox(norm(geodesictangent(LatLon(T(43), T(-21)), ϕ)), oneunit(T) * u"m", atol=1e-6u"m")
  end

  # units are optional, and the numeric type follows the point and not the angle
  @test geodesictangent(LatLon(T(30), T(40)), 25u"°") ≈ geodesictangent(LatLon(T(30), T(40)), 25)
  @test Unitful.numtype(eltype(geodesictangent(LatLon(T(30), T(40)), 25))) === T
  @test Unitful.numtype(typeof(geodesicazimuth(LatLon(T(30), T(40)), geodesictangent(LatLon(T(30), T(40)), 25)))) === T

  # the vector can mix plain numbers and quantities
  @test geodesicazimuth(LatLon(T(0), T(0)), (0, 1.0, 0)) ≈ T(90) * u"°"
  @test geodesicazimuth(LatLon(T(0), T(0)), (0u"m", 1.0u"m", 0u"m")) ≈ T(90) * u"°"

  # azimuth inverts tangent
  for lat in T.(-80:20:80), lon in T.(-150:50:150), ϕ in T.(-150:50:150)
    ll = LatLon(lat, lon)
    @test isapprox(geodesicazimuth(ll, geodesictangent(ll, ϕ)), ϕ * u"°", atol=1e-4u"°")
  end

  # the tangent points in the direction that geodesicfwd walks
  for ϕ in T.((-120, -30, 15, 88, 170))
    ll₁ = LatLon(T(-12), T(77))
    ll₂ = geodesicfwd(ll₁, ϕ, T(1000))
    cc₁ = convert(Cartesian, ll₁)
    cc₂ = convert(Cartesian, ll₂)
    v = [cc₂.x - cc₁.x, cc₂.y - cc₁.y, cc₂.z - cc₁.z]
    @test isapprox(geodesicazimuth(ll₁, v), ϕ * u"°", atol=τϕ)
  end

  # the tangent is consistent with the azimuth of the inverse problem
  c₁ = LatLon(T(-33.8688), T(151.2093))
  c₂ = LatLon(T(51.5074), T(-0.1278))
  @test isapprox(geodesicazimuth(c₁, geodesictangent(c₁, geodesicbwd(c₁, c₂))), geodesicbwd(c₁, c₂), atol=1e-4u"°")

  # tests with other coordinate reference systems
  ll₁ = LatLon(T(0), T(0))
  ll₂ = LatLon(T(0), T(1))
  me₁ = convert(Mercator, ll₁)
  me₂ = convert(Mercator, ll₂)
  @test isapprox(geodesicfwd(ll₁, T(0), T(1000)), geodesicfwd(me₁, T(0), T(1000)))
  @test isapprox(geodesicfwd(ll₂, T(0), T(1000)), geodesicfwd(me₂, T(0), T(1000)))
  @test isapprox(geodesicbwd(ll₁, ll₂), geodesicbwd(me₁, me₂))
  @test isapprox(geodesicdistance(ll₁, ll₂), geodesicdistance(me₁, me₂))
  @test isapprox(geodesictangent(ll₁, 0), geodesictangent(me₁, 0))
  @test isapprox(geodesictangent(ll₂, 0), geodesictangent(me₂, 0))
  @test isapprox(geodesicazimuth(ll₁, geodesictangent(ll₁, 0)), geodesicazimuth(me₁, geodesictangent(me₁, 0)))
  @test isapprox(geodesicazimuth(ll₂, geodesictangent(ll₂, 0)), geodesicazimuth(me₂, geodesictangent(me₂, 0)))
end
