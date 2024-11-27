# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @geocentrictranslation Datumₛ Datumₜ (δx=0.0, δy=0.0, δz=0.0)

Geocentric translation with parameters `δx, δy, δz` in meters.

## References

* Section 4.3.4 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
macro geocentrictranslation(Datumₛ, Datumₜ, params)
  expr = quote
    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      x = SVector(values(coords))
      x′ = geocentrictranslationfwd(x; $params...)
      Cartesian{Dₜ,3}(Tuple(x′))
    end

    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₜ,Dₜ<:$Datumₛ}
      x = SVector(values(coords))
      x′ = geocentrictranslationbwd(x; $params...)
      Cartesian{Dₜ,3}(Tuple(x′))
    end
  end
  esc(expr)
end

function geocentrictranslationfwd(x; δx=0.0, δy=0.0, δz=0.0)
  T = numtype(eltype(x))
  δ = SVector(T(δx) * m, T(δy) * m, T(δz) * m)
  x + δ
end

geocentrictranslationbwd(x; δx=0.0, δy=0.0, δz=0.0) = geocentrictranslationfwd(x, δx=-δx, δy=-δy, δz=-δz)
