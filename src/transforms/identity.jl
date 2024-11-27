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
  end
  esc(expr)
end
