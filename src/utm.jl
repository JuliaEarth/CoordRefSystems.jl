# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Hemisphere

Hemisphere of the Earth.
"""
abstract type Hemisphere end

"""
    North

Northern hemisphere.
"""
abstract type North <: Hemisphere end

"""
    South

Southern hemisphere.
"""
abstract type South <: Hemisphere end

"""
    utm(H::Type{<:Hemisphere}, zone; datum=WGS84Latest)

UTM (Universal Transverse Mercator) CRS in hemisphere `H` with `zone` (1 ≤ zone ≤ 60) and a given `datum`.
"""
function utm(H::Type{<:Hemisphere}, zone; datum=WGS84Latest)
  if !(1 ≤ zone ≤ 60)
    throw(ArgumentError("the UTM zone must be an integer between 1 and 60"))
  end
  k₀ = 0.9996
  latₒ = 0.0°
  lonₒ = (6 * zone - 183) * °
  xₒ = falseeasting(H)
  yₒ = falsenorthing(H)
  TransverseMercator{datum,TransverseMercatorParams(; k₀, latₒ),Shift(; lonₒ, xₒ, yₒ)}
end

# -----------------
# HELPER FUNCTIONS
# -----------------

falseeasting(::Type{<:Hemisphere}) = 500000.0m

falsenorthing(::Type{<:North}) = 0.0m
falsenorthing(::Type{<:South}) = 10000000.0m
