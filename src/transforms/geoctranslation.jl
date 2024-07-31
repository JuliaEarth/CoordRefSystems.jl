# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    GeocentricTranslation(; δx=0.0, δy=0.0, δz=0.0)

Geocentric translation with parameters `δx, δy, δz` in meters.

## References

* Section 4.3.4 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
struct GeocentricTranslation{T} <: Transform
  δx::T
  δy::T
  δz::T
end

GeocentricTranslation(; δx=0.0, δy=0.0, δz=0.0) = GeocentricTranslation(δx * m, δy * m, δz * m)

function apply(transform::GeocentricTranslation, x)
  δ = translation(numtype(eltype(x)), transform)
  x + δ
end

function apply(transform::Reverse{<:GeocentricTranslation}, x)
  δ = translation(numtype(eltype(x)), transform)
  x - δ
end
