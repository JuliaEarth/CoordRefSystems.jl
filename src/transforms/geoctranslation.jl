# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @geoctranslation Datumₛ Datumₜ (δx=0.0, δy=0.0, δz=0.0)

Geocentric translation with parameters `δx, δy, δz` in meters.

## References

* Section 4.3.4 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
macro geoctranslation(Datumₛ, Datumₜ, params)
  expr = quote
    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      xyz = SVector(coords.x, coords.y, coords.z)
      xyz′ = geoctranslationfwd(xyz; $params...)
      Cartesian{Dₜ}(xyz′...)
    end

    function Base.convert(::Type{Cartesian{Dₛ}}, coords::Cartesian{Dₜ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      xyz = SVector(coords.x, coords.y, coords.z)
      xyz′ = geoctranslationbwd(xyz; $params...)
      Cartesian{Dₜ}(xyz′...)
    end
  end
  esc(expr)
end

function geoctranslationfwd(x; δx=0.0, δy=0.0, δz=0.0)
  T = numtype(eltype(x))
  δ = SVector(T(δx) * m, T(δy) * m, T(δz) * m)
  x + δ
end

geoctranslationbwd(x; δx=0.0, δy=0.0, δz=0.0) = geoctranslationfwd(x, δx=-δx, δy=-δy, δz=-δz)
