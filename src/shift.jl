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

Shift(; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m) = Shift(asdeg(lonₒ), asmet(xₒ), asmet(yₒ))

"""
    CoordRefSystems.shift(CRS::Type{<:Projected}; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m)

Shifts the `CRS` with given longitude origin `lonₒ` in degrees, false easting `xₒ`
and false northing `yₒ` in meters.
"""
shift(CRS::Type{<:Projected}; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m) = CRS{Shift(;lonₒ,xₒ,yₒ)}

"""
    CoordRefSystems.shift(Datum, epoch)

Shifts the `Datum` with a given `epoch` in decimalyear.
"""
shift(D::Type{<:Datum}, epoch) = ShiftedDatum{D,epoch}
