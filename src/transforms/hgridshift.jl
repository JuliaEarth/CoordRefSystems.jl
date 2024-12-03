# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @hgridshift Datumₛ Datumₜ

Horizontal Grid Shift transform that uses grid interpolation
to calculate coordinate offsets.

## References

* Section 4.4.6 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
macro hgridshift(Datumₛ, Datumₜ)
  expr = quote
    function Base.convert(::Type{LatLon{Dₜ}}, coords::LatLon{Dₛ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      latlon = (coords.lat, coords.lon)
      latlon′ = hgridshiftfwd(Dₛ, Dₜ, latlon)
      LatLon{Dₜ}(latlon′...)
    end
  end
  esc(expr)
end

function hgridshiftfwd(Datumₛ, Datumₜ, (lat, lon))
  latshift, lonshift = hgridshiftparams(Datumₛ, Datumₜ, (lat, lon))
  lat + latshift, lon + lonshift
end

function hgridshiftparams(Datumₛ, Datumₜ, (lat, lon))
  T = numtype(lon)
  interp = interpolator(Datumₛ, Datumₜ)
  itp = interp(ustrip(lon), ustrip(lat))
  # type assertion is necessary for type stability
  latshift::T = T(itp[1])
  lonshift::T = T(itp[2])
  # convert arc seconds to degrees
  latshift′ = latshift / 3600 * °
  lonshift′ = lonshift / 3600 * °
  latshift′, lonshift′
end
