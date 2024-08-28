# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Mode

Mode of a CRS formula.
"""
abstract type Mode end

"""
    EllipticalMode <: Mode

Elliptical mode of a CRS formula.
"""
abstract type EllipticalMode <: Mode end

"""
    SphericalMode <: Mode

Spherical mode of a CRS formula.
"""
abstract type SphericalMode <: Mode end
