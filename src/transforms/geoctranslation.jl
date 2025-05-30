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

function geoctranslationfwd(xyz; kwargs...)
  δ = geoctranslationparams(xyz; kwargs...)
  xyz + δ
end

function geoctranslationbwd(xyz; kwargs...)
  δ = geoctranslationparams(xyz; kwargs...)
  xyz - δ
end

function geoctranslationparams(xyz; δx=0.0, δy=0.0, δz=0.0)
  T = numtype(eltype(xyz))
  SVector(T(δx) * m, T(δy) * m, T(δz) * m)
end
