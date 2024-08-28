# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    utm(hemisphere, zone; datum=WGS84Latest)

UTM (Universal Transverse Mercator) CRS in `hemisphere` (`:north` or `:south`)
with `zone` (1 ≤ zone ≤ 60) and a given `datum`.
"""
function utm(hemisphere, zone; datum=WGS84Latest)
  if hemisphere ∉ (:north, :south)
    throw(ArgumentError("invalid hemisphere, please use `:north` or `:south`"))
  end

  if !(1 ≤ zone ≤ 60)
    throw(ArgumentError("the UTM zone must be an integer between 1 and 60"))
  end

  k₀ = 0.9996
  latₒ = 0.0°
  lonₒ = (6 * zone - 183) * °
  xₒ = 500000.0m
  yₒ = hemisphere == :north ? 0.0m : 10000000.0m
  S = Shift(; lonₒ, xₒ, yₒ)
  TransverseMercator{k₀,latₒ,datum,S}
end

"""
    utmnorth(zone; datum=WGS84Latest)

UTM North CRS with `zone` (1 ≤ zone ≤ 60) and a given `datum`.
"""
utmnorth(zone; kwargs...) = utm(:north, zone; kwargs...)

"""
    utmsouth(zone; datum=WGS84Latest)

UTM South CRS with `zone` (1 ≤ zone ≤ 60) and a given `datum`.
"""
utmsouth(zone; kwargs...) = utm(:south, zone; kwargs...)
