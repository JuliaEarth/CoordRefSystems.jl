# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Shift(; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m)

Shift parameters with a given longitude origin `lonₒ` in degrees, false easting `xₒ`
and false northing `yₒ` in meters.
"""
struct Shift{D<:Deg,M<:Met}
  lonₒ::D
  xₒ::M
  yₒ::M
end

Shift(; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m) = Shift(float(asdeg(lonₒ)), float(asmet(xₒ)), float(asmet(yₒ)))

"""
    CoordRefSystems.shift(CRS::Type{<:Projected}; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m)

Shifts the `CRS` with given longitude origin `lonₒ` in degrees, false easting `xₒ`
and false northing `yₒ` in meters.
"""
shift(CRS::Type{<:Projected}; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m) = CRS{Shift(; lonₒ, xₒ, yₒ)}
