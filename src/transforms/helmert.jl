# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @helmert Datumₛ Datumₜ (δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0)

Helmert transform with translation parameters `δx`, `δy` and `δz` in meters,
rotation parameters `θx`, `θy` and `θz` in arc seconds, and scale parameter
`s` in ppm (parts per million).

The EPSG database includes two rotation conventions:

1. "Coordinate Frame Rotation"
2. "Position Vector transformation"

In the convention (1), the rotation parameters `θx`, `θy` and `θz` are copied
without modification. Consider the NZGD49 <> WGSG84 transform as an example:

https://epsg.org/transformation_1564/NZGD49-to-WGS-84-2.html

The rotation parameters are given by `θx=-0.47`, `θy=0.1` and `θz=-1.024`.

In the convention (2), the sign of the rotation parameters must be flipped.
Consider the OSGB36 <> WGS84 transform as an example:

https://epsg.org/transformation_1314/OSGB36-to-WGS-84-6.html

The rotation parameters are given by `θx=-0.15`, `θy=-0.247` and `θz=-0.842`.

It is worth noting that convention (1) is the most frequent convention in the
EPSG database, and that convention (2) is the one adopted by the C PROJ library:

https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp

## References

* Section 4.3.3 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
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
  R = RotXYZ(-T(θx) / 3600 * °, -T(θy) / 3600 * °, -T(θz) / 3600 * °)
  S = T(s) * ppm
  δ, R, S
end
