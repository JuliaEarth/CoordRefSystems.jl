# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @helmert Datumₛ Datumₜ (δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0)

Helmert transform with translation parameters `δx, δy, δz` in meters, 
rotation parameters `θx, θy, θz` in arc seconds,
and scale parameter `s` in ppm (parts per million).

## References

* Section 4.3.3 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>

### Notes

* The convention used for rotation is the Position Vector. 
  To set rotation parameters that use the Coordinate Frame convention,
  simply invert the sign of the parameters.
"""
macro helmert(Datumₛ, Datumₜ, params)
  expr = quote
    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      x = SVector(values(coords))
      x′ = helmertfwd(x; $params...)
      Cartesian{Dₜ}(Tuple(x′))
    end

    function Base.convert(::Type{Cartesian{Dₛ}}, coords::Cartesian{Dₜ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      x = SVector(values(coords))
      x′ = helmertbwd(x; $params...)
      Cartesian{Dₛ}(Tuple(x′))
    end
  end
  esc(expr)
end

function helmertfwd(x; δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0)
  T = numtype(eltype(x))
  δ = SVector(T(δx) * m, T(δy) * m, T(δz) * m)
  R = RotXYZ(T(θx) / 3600 * °, T(θy) / 3600 * °, T(θz) / 3600 * °)
  S = T(s) * u"ppm"
  (1 + S) * R * x + δ
end

function helmertbwd(x; δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0)
  T = numtype(eltype(x))
  δ = SVector(T(δx) * m, T(δy) * m, T(δz) * m)
  R = RotXYZ(T(θx) / 3600 * °, T(θy) / 3600 * °, T(θz) / 3600 * °)
  S = T(s) * u"ppm"
  (1 / (1 + S)) * inv(R) * (x - δ)
end
