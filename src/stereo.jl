# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    stereo(hemisphere, latₜₛ; lonₒ=0.0°, datum=WGS84Latest)

Polar Stereographic CRS in `hemisphere` (`:north` or `:south`) with latitude of
true scale `latₜₛ`, central meridian `lonₒ` and a given `datum`.

EPSG defines polar stereographic CRSs with a latitude of true scale, while the
[`Stereographic`](@ref) type is parametrized by the scale factor `k₀` that also
covers the oblique aspect. This function converts between the two.

Only the magnitude of `latₜₛ` is used, the `hemisphere` selects the pole.

See also [`stereonorth`](@ref), [`stereosouth`](@ref).
"""
function stereo(hemisphere, latₜₛ; lonₒ=0.0°, datum=WGS84Latest)
  if hemisphere ∉ (:north, :south)
    throw(ArgumentError("invalid hemisphere, please use `:north` or `:south`"))
  end

  ϕₜₛ = abs(asdeg(latₜₛ))

  if !(0° < ϕₜₛ ≤ 90°)
    throw(ArgumentError("the latitude of true scale must be greater than 0° and at most 90°"))
  end

  k₀ = scalefactor(ϕₜₛ, ellipsoid(datum))
  latₒ = hemisphere == :north ? 90.0° : -90.0°
  S = Shift(; lonₒ)
  Stereographic{EllipticalMode,k₀,latₒ,datum,S}
end

"""
    stereonorth(latₜₛ; lonₒ=0.0°, datum=WGS84Latest)

North Polar Stereographic CRS with latitude of true scale `latₜₛ`.
"""
stereonorth(latₜₛ; kwargs...) = stereo(:north, latₜₛ; kwargs...)

"""
    stereosouth(latₜₛ; lonₒ=0.0°, datum=WGS84Latest)

South Polar Stereographic CRS with latitude of true scale `latₜₛ`.
"""
stereosouth(latₜₛ; kwargs...) = stereo(:south, latₜₛ; kwargs...)

# scale factor at the pole for a given latitude of true scale,
# equation 21-35 of Snyder, with true scale at the pole itself
# corresponding to a unit scale factor
function scalefactor(ϕₜₛ, 🌎)
  ϕₜₛ == 90° && return 1.0
  e = eccentricity(🌎)
  esinϕ = e * sin(ϕₜₛ)
  m = cos(ϕₜₛ) / sqrt(1 - esinϕ^2)
  t = tan(45° - ϕₜₛ / 2) / ((1 - esinϕ) / (1 + esinϕ))^(e / 2)
  m * sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e)) / 2t
end
