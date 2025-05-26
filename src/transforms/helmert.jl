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

The convention used for rotation is the Position Vector. 
To set rotation parameters that use the Coordinate Frame
convention, simply invert the sign of the parameters.
"""
macro helmert(Datumₛ, Datumₜ, params)
  expr = quote
    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      xyz = SVector(coords.x, coords.y, coords.z)
      xyz′ = helmertfwd(xyz; $params...)
      Cartesian{Dₜ}(xyz′...)
    end

    function Base.convert(::Type{Cartesian{Dₛ}}, coords::Cartesian{Dₜ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      xyz = SVector(coords.x, coords.y, coords.z)
      xyz′ = helmertbwd(xyz; $params...)
      Cartesian{Dₛ}(xyz′...)
    end

    Base.convert(::Type{Cylindrical{Dₜ}}, coords::Cylindrical{Dₛ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Cylindrical{Dₜ}, convert(Cartesian{Dₜ}, convert(Cartesian{Dₛ}, coords)))

    Base.convert(::Type{Cylindrical{Dₛ}}, coords::Cylindrical{Dₜ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Cylindrical{Dₛ}, convert(Cartesian{Dₛ}, convert(Cartesian{Dₜ}, coords)))

    Base.convert(::Type{Spherical{Dₜ}}, coords::Spherical{Dₛ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Spherical{Dₜ}, convert(Cartesian{Dₜ}, convert(Cartesian{Dₛ}, coords)))

    Base.convert(::Type{Spherical{Dₛ}}, coords::Spherical{Dₜ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Spherical{Dₛ}, convert(Cartesian{Dₛ}, convert(Cartesian{Dₜ}, coords)))
  end
  esc(expr)
end

function helmertfwd(xyz; kwargs...)
  δ, R, S = helmertparams(xyz; kwargs...)
  (1 + S) * R * xyz + δ
end

function helmertbwd(xyz; kwargs...)
  δ, R, S = helmertparams(xyz; kwargs...)
  (1 / (1 + S)) * inv(R) * (xyz - δ)
end

function helmertparams(xyz; δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0)
  T = numtype(eltype(xyz))
  δ = SVector(T(δx) * m, T(δy) * m, T(δz) * m)
  R = RotXYZ(T(θx) / 3600 * °, T(θy) / 3600 * °, T(θz) / 3600 * °)
  S = T(s) * ppm
  δ, R, S
end
