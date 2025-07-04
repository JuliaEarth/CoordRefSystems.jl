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

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/265
    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/268
    PRJ <: LambertAzimuthal && continue

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/272
    PRJ <: OrthoNorth && continue
    PRJ <: OrthoSouth && continue

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/295
    PRJ <: Sinusoidal && continue

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/296
    PRJ <: Albers && continue

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/297
    PRJ <: GallPeters && continue

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/298
    PRJ <: Behrmann && continue

    # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/299
    PRJ <: LambertCylindrical && continue

    # loop over all possible latitude and longitude values
    # that should be recovered by the given PRJ type
    success = true
    for (lat, lon) in Iterators.product(T.(-90:90), T.(-180:180))
      # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/243
      PRJ <: EqualEarth && abs(lat) == T(90) && continue

      # the LambertConic projection maps all values of the form (90, lon) to (xₒ, y)
      # therefore we cannot recover the original lon value when lat=90
      PRJ <: LambertConic && lat == T(90) && continue

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
