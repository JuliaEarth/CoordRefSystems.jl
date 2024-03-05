# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    RevolutionEllipsoid

Parent type of all revolution ellipsoids.
"""
abstract type RevolutionEllipsoid end

"""
    majoraxis(E)

Returns the semi-major axis of the ellipsoid type `E`.
"""
function majoraxis end

"""
    minoraxis(E)

Returns the semi-minor axis of the ellipsoid type `E`.
"""
function minoraxis end

"""
    eccentricity(E)

Returns the eccentricity of the ellipsoid type `E`.
"""
function eccentricity end

"""
    eccentricity²(E)

Returns the eccentricity squared of the ellipsoid type `E`.
"""
function eccentricity² end

"""
    flattening(E)

Returns the flattening of the ellipsoid type `E`.
"""
function flattening end

"""
    flattening⁻¹(E)

Returns the inverse flattening of the ellipsoid type `E`.
"""
function flattening⁻¹ end

# ----------------
# IMPLEMENTATIONS
# ----------------

abstract type WGS84🌎 <: RevolutionEllipsoid end

const _WGS84 = ellipfromaf⁻¹(6378137.0u"m", 298.257223563)

majoraxis(::Type{WGS84🌎}) = _WGS84.a
minoraxis(::Type{WGS84🌎}) = _WGS84.b
eccentricity(::Type{WGS84🌎}) = _WGS84.e
eccentricity²(::Type{WGS84🌎}) = _WGS84.e²
flattening(::Type{WGS84🌎}) = _WGS84.f
flattening⁻¹(::Type{WGS84🌎}) = _WGS84.f⁻¹

abstract type GRS80🌎 <: RevolutionEllipsoid end

const _GRS80 = ellipfromaf⁻¹(6378137.0u"m", 298.257222101)

majoraxis(::Type{GRS80🌎}) = _GRS80.a
minoraxis(::Type{GRS80🌎}) = _GRS80.b
eccentricity(::Type{GRS80🌎}) = _GRS80.e
eccentricity²(::Type{GRS80🌎}) = _GRS80.e²
flattening(::Type{GRS80🌎}) = _GRS80.f
flattening⁻¹(::Type{GRS80🌎}) = _GRS80.f⁻¹
