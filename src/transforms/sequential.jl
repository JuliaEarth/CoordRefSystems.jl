# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @sequential(Datum₁, Datum₂, ..., Datumₙ)

Create a Sequential transform using the intermediate transforms
between `Datum₁`, `Datum₂`, ..., `Datumₙ`.

See also [`Sequential`](@ref).
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
    Base.convert(::Type{Cartesian{Datumₜ}}, coords::Cartesian{Datumₛ,3}) = $fwdbody

    Base.convert(::Type{Cartesian{Datumₛ}}, coords::Cartesian{Datumₜ,3}) = $bwdbody
  end

  esc(expr)
end
