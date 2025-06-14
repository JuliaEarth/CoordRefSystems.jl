# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# we promote to Behrmann by default because
# it preserves area near +/-30° latitude, but this
# may change in the future after we have better
# support for LatLon in downstream packages
const DefaultCRS = Behrmann

# we promote to WGS84Latest by default because
# it is the most widely used datum nowadays
const DefaultDatum = WGS84Latest

function Base.promote_rule(C₁::Type{<:Projected{Datum}}, C₂::Type{<:Projected{Datum}}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  DefaultCRS{Datum,Shift(),Met{T}}
end

function Base.promote_rule(C₁::Type{<:Projected{Datum₁}}, C₂::Type{<:Projected{Datum₂}}) where {Datum₁,Datum₂}
  T = promote_type(mactype(C₁), mactype(C₂))
  DefaultCRS{DefaultDatum,Shift(),Met{T}}
end

function Base.promote_rule(C₁::Type{<:Projected{Datum}}, C₂::Type{<:Cartesian{Datum,2}}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  C = constructor(C₁)
  C{Met{T}}
end

function Base.promote_rule(C₁::Type{<:Projected}, C₂::Type{<:Cartesian{NoDatum,2}})
  T = promote_type(mactype(C₁), mactype(C₂))
  C = constructor(C₁)
  C{Met{T}}
end

function Base.promote_rule(C₁::Type{<:Projected{Datum}}, C₂::Type{<:Cartesian{Datum,3}}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  C = constructor(C₁)
  C{Met{T}}
end

function Base.promote_rule(C₁::Type{<:Projected}, C₂::Type{<:LatLon})
  T = promote_type(mactype(C₁), mactype(C₂))
  C = constructor(C₁)
  C{Met{T}}
end

function Base.promote_rule(C₁::Type{<:Polar{Datum}}, C₂::Type{<:Polar{Datum}}) where {Datum}
  L = promote_type(lentype(C₁), lentype(C₂))
  T = numtype(L)
  Polar{Datum,L,Rad{T}}
end

function Base.promote_rule(C₁::Type{<:Cylindrical{Datum}}, C₂::Type{<:Cylindrical{Datum}}) where {Datum}
  L = promote_type(lentype(C₁), lentype(C₂))
  T = numtype(L)
  Cylindrical{Datum,L,Rad{T}}
end

function Base.promote_rule(C₁::Type{<:Spherical{Datum}}, C₂::Type{<:Spherical{Datum}}) where {Datum}
  L = promote_type(lentype(C₁), lentype(C₂))
  T = numtype(L)
  Spherical{Datum,L,Rad{T}}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,N}}, C₂::Type{<:Cartesian{Datum,N}}) where {Datum,N}
  L = promote_type(lentype(C₁), lentype(C₂))
  Cartesian{Datum,N,L}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,3}}, C₂::Type{<:Cartesian{Datum,3}}) where {Datum}
  L = promote_type(lentype(C₁), lentype(C₂))
  Cartesian{Datum,3,L}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum₁,3}}, C₂::Type{<:Cartesian{Datum₂,3}}) where {Datum₁,Datum₂}
  L = promote_type(lentype(C₁), lentype(C₂))
  Cartesian{DefaultDatum,3,L}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,2}}, C₂::Type{<:Polar{Datum}}) where {Datum}
  L = promote_type(lentype(C₁), lentype(C₂))
  Cartesian{Datum,2,L}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,3}}, C₂::Type{<:Cylindrical{Datum}}) where {Datum}
  L = promote_type(lentype(C₁), lentype(C₂))
  Cartesian{Datum,3,L}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,3}}, C₂::Type{<:Spherical{Datum}}) where {Datum}
  L = promote_type(lentype(C₁), lentype(C₂))
  Cartesian{Datum,3,L}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,3}}, C₂::Type{<:LatLon}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  Cartesian{Datum,3,Met{T}}
end

function Base.promote_rule(C₁::Type{<:Geographic{Datum,2}}, C₂::Type{<:Geographic{Datum,2}}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  LatLon{Datum,Deg{T}}
end

function Base.promote_rule(C₁::Type{<:Geographic{Datum₁,2}}, C₂::Type{<:Geographic{Datum₂,2}}) where {Datum₁,Datum₂}
  T = promote_type(mactype(C₁), mactype(C₂))
  LatLon{DefaultDatum,Deg{T}}
end

function Base.promote_rule(C₁::Type{<:Geographic{Datum,3}}, C₂::Type{<:Geographic{Datum,3}}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  LatLonAlt{Datum,Deg{T},Met{T}}
end

function Base.promote_rule(C₁::Type{<:Geographic{Datum₁,3}}, C₂::Type{<:Geographic{Datum₂,3}}) where {Datum₁,Datum₂}
  T = promote_type(mactype(C₁), mactype(C₂))
  LatLonAlt{DefaultDatum,Deg{T},Met{T}}
end
