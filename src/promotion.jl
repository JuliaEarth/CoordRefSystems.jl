# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

const DefaultDatum = WGS84Latest

const DefaultCRS = Behrmann

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

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,N}}, C₂::Type{<:Cartesian{Datum,N}}) where {Datum,N}
  T = promote_type(mactype(C₁), mactype(C₂))
  Cartesian{Datum,N,Met{T}}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,3}}, C₂::Type{<:Cartesian{Datum,3}}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  Cartesian{Datum,3,Met{T}}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum₁,3}}, C₂::Type{<:Cartesian{Datum₂,3}}) where {Datum₁,Datum₂}
  T = promote_type(mactype(C₁), mactype(C₂))
  Cartesian{DefaultDatum,3,Met{T}}
end

function Base.promote_rule(C₁::Type{<:Cartesian{Datum,3}}, C₂::Type{<:LatLon}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  Cartesian{Datum,3,Met{T}}
end

function Base.promote_rule(C₁::Type{<:LatLon{Datum}}, C₂::Type{<:LatLon{Datum}}) where {Datum}
  T = promote_type(mactype(C₁), mactype(C₂))
  LatLon{Datum,Deg{T}}
end

function Base.promote_rule(C₁::Type{<:LatLon{Datum₁}}, C₂::Type{<:LatLon{Datum₂}}) where {Datum₁,Datum₂}
  T = promote_type(mactype(C₁), mactype(C₂))
  LatLon{DefaultDatum,Deg{T}}
end