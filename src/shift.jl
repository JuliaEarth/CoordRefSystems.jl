# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    CoordRefSystems.shift(CRS::Type{<:Projected}; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m)

Shifts the `CRS` with given longitude origin `lonₒ` in degrees, false easting `xₒ`
and false northing `yₒ` in meters.
"""
shift(CRS::Type{<:Projected}; lonₒ=0.0°, xₒ=0.0m, yₒ=0.0m) = ShiftedCRS{CRS,lonₒ,xₒ,yₒ}

"""
    CoordRefSystems.shift(Datum, epoch)

Shifts the `Datum` with a given `epoch` in decimalyear.
"""
shift(D::Type{<:Datum}, epoch) = ShiftedDatum{D,epoch}
