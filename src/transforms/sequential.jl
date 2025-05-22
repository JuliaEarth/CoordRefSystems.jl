# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @sequential(Datumₛ, Datum₁, ..., Datumₙ, Datumₜ)

Create a sequential transform that converts source `Datumₛ` to target `Datumₜ` 
using the intermediate transforms between `Datumₛ`, `Datum₁`, ..., `Datumₙ`, `Datumₜ`.
"""
macro sequential(Datums...)
  function bodyexpr(datums)
    init = :(convert(Cartesian{$(datums[2])}, coords))
    foldl(3:length(datums); init) do acc, i
      :(convert(Cartesian{$(datums[i])}, $acc))
    end
  end

  fwdbody = bodyexpr(Datums)
  bwdbody = bodyexpr(reverse(Datums))

  Datumₛ = first(Datums)
  Datumₜ = last(Datums)

  expr = quote
    Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} = $fwdbody

    Base.convert(::Type{Cartesian{Dₛ}}, coords::Cartesian{Dₜ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} = $bwdbody

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
