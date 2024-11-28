# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @hgridshift Datumₛ Datumₜ

Horizontal Grid Shift transform that uses grid interpolation
to calculate coordinate offsets.
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
  D = typeof(lon)
  T = numtype(D)
  interp = interpolation(Datumₛ, Datumₜ)
  itp = interp(ustrip(lon), ustrip(lat))
  latshift::D = T(itp[1]) / 3600 * °
  lonshift::D = T(itp[2]) / 3600 * °
  latshift, lonshift
end
