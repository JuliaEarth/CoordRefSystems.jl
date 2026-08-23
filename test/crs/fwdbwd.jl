@testset "Forward/Backward" begin
  # projections that flip the sign of lon=180°=-180°
  prjflip = Set{String}()

  @testset for PRJ in projected
    # latitude and longitude values that are not recovered
    latfail = Set{T}()
    lonfail = Set{T}()

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/40
    PRJ <: TransverseMercator && continue

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/55
    PRJ <: Robinson && continue

    # loop over all possible latitude and longitude values
    # that should be recovered by the given PRJ type
    success = true
    for (lat, lon) in Iterators.product(T.(-90:90), T.(-180:180))
      # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/243
      PRJ <: EqualEarth && abs(lat) == T(90) && continue

      # the LambertConic projection maps all values of the form (90, lon) to (xₒ, y)
      # therefore we cannot recover the original lon value when lat=90
      PRJ <: LambertConic && lat == T(90) && continue

      # the Orthographic projection maps all values of the form (90, lon) to (xₒ, yₒ)
      # therefore we cannot recover the original lon value at the pole
      PRJ <: OrthoNorth && lat == T(90) && continue
      PRJ <: OrthoSouth && lat == T(-90) && continue

      # at the limb of the Orthographic projection the derivative of the radius
      # with respect to the latitude vanishes, so only half of the significant
      # digits of the latitude can be recovered
      PRJ <: OrthoNorth && lat == T(0) && continue
      PRJ <: OrthoSouth && lat == T(0) && continue

      # the Sinusoidal projection maps all values of the form (±90, lon) to (0, y)
      # therefore we cannot recover the original lon value at the poles
      PRJ <: Sinusoidal && abs(lat) == T(90) && continue

      # the EqualAreaCylindrical projections compress the latitude near the poles,
      # so only half of the significant digits of the latitude can be recovered
      PRJ <: LambertCylindrical && abs(lat) == T(90) && continue
      PRJ <: Behrmann && abs(lat) == T(90) && continue
      PRJ <: GallPeters && abs(lat) == T(90) && continue

      # the Albers projection compresses the latitude near the poles,
      # so only half of the significant digits of the latitude can be recovered
      PRJ <: Albers && abs(lat) == T(90) && continue

      # at the poles the argument of the arcsine in the LambertAzimuthal inverse
      # approaches one, so only half of the significant digits of the latitude
      # can be recovered
      PRJ <: LambertAzimuthal && abs(lat) == T(90) && continue

      # the LambertAzimuthal projection above is centered at lat=15, so its antipode
      # is the point (-15, 180). The derivative of the radius with respect to the
      # angular distance vanishes there, and within one degree of it the latitude
      # loses half of its significant digits in Float32
      PRJ <: LambertAzimuthal && abs(lon) == T(180) && abs(lat + T(15)) ≤ T(1) && continue

      ll = LatLon(lat, lon)
      LL = typeof(ll)
      if indomain(PRJ, ll)
        ll′ = convert(LL, convert(PRJ, ll))
        if isapprox(ll′, ll)
          # we are in the ideal case where the original
          # latitude and longitude were fully recovered
          continue
        elseif isapprox(ll′, LL(ll.lat, -ll.lon))
          # the round trip conversion led to an incorrect
          # sign for the longitude coordinate and we have
          # to investigate if we are near lon=180°=-180°
          rtol = CoordRefSystems.rtol(ll′.lon)
          atol = CoordRefSystems.atol(ll′.lon)
          if isapprox(abs(ll′.lon), T(180)°; rtol, atol)
            # in that case we have exchanged lon=180°=-180°
            # which is is ok for most practical purposes
            push!(prjflip, string(PRJ))
            continue
          else
            # we returned the incorrect sign for a longitude
            # that is far from lon=180=-180 and this is not
            # the expected result, certainly a bug to fix
            push!(latfail, lat)
            push!(lonfail, lon)
            success = false
          end
        else
          # we failed to recover the original latitude and longitude
          # coordinates due to unknown reasons that are likely bugs
          push!(latfail, lat)
          push!(lonfail, lon)
          success = false
        end
      end
    end

    # report PRJ status
    @test success

    # display problematic latitude and longitude values in case of failure
    if !success
      @info "$PRJ failed with lat in $(sort(collect(latfail)))"
      @info "$PRJ failed with lon in $(sort(collect(lonfail)))"
    end
  end

  # warn maintainers about the behavior of some projections near lon=180=-180
  @warn "$(join(prjflip, ", ", " and ")) flipped the sign near lon=180°=-180°"
end
