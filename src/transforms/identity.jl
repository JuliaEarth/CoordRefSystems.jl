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
      Cartesian{Dₜ,3}(values(coords))

    Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₜ,Dₜ<:$Datumₛ} =
      Cartesian{Dₜ,3}(values(coords))
  end
  esc(expr)
end
