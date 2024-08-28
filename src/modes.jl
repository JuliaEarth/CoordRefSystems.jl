# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Mode

Mode (or variant) of a coordinate reference system.

See also [`EllipticalMode`](@ref), [`SphericalMode`](@ref).
"""
abstract type Mode end

"""
    EllipticalMode

Elliptical mode.
"""
abstract type EllipticalMode <: Mode end

"""
    SphericalMode

Spherical mode.
"""
abstract type SphericalMode <: Mode end
