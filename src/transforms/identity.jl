# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @identity Datumₛ Datumₜ

Identity transform.
"""
macro identity(Datumₛ, Datumₜ)
  expr = quote
    Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      Cartesian{Dₜ}(coords.x, coords.y, coords.z)

    Base.convert(::Type{Cartesian{Dₛ}}, coords::Cartesian{Dₜ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      Cartesian{Dₛ}(coords.x, coords.y, coords.z)

    Base.convert(::Type{Cylindrical{Dₜ}}, coords::Cylindrical{Dₛ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      Cylindrical{Dₜ}(coords.ρ, coords.ϕ, coords.z)

    Base.convert(::Type{Cylindrical{Dₛ}}, coords::Cylindrical{Dₜ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      Cylindrical{Dₛ}(coords.ρ, coords.ϕ, coords.z)

    Base.convert(::Type{Spherical{Dₜ}}, coords::Spherical{Dₛ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      Spherical{Dₜ}(coords.r, coords.θ, coords.ϕ)

    Base.convert(::Type{Spherical{Dₛ}}, coords::Spherical{Dₜ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      Spherical{Dₛ}(coords.r, coords.θ, coords.ϕ)
  end
  esc(expr)
end
