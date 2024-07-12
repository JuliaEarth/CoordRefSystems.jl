# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    GeocentricTranslation(; δx=0.0, δy=0.0, δz=0.0)

Geocentric translation with parameters `δx, δy, δz` in meters.

## References

* Section 4.3.4 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
struct GeocentricTranslation{T} <: GeocentricTransform
  δx::T
  δy::T
  δz::T
end

GeocentricTranslation(; δx=0.0, δy=0.0, δz=0.0) = GeocentricTranslation(δx * u"m", δy * u"m", δz * u"m")

function geocapply(transform::GeocentricTranslation, x)
  δ = translation(numtype(eltype(x)), transform)
  x + δ
end

function geocapply(transform::Reverse{<:GeocentricTranslation}, x)
  δ = translation(numtype(eltype(x)), transform)
  x - δ
end
