# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    GeocentricHelmert(; δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0)

Geocentric Helmert transform with translation parameters `δx, δy, δz` in meters, 
rotation parameters `θx, θy, θz` in arc seconds, and scale parameter `s` in ppm (parts per million).

## References

* Section 4.3.3 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
struct GeocentricHelmert{T,R,S} <: GeocentricTransform
  δx::T
  δy::T
  δz::T
  θx::R
  θy::R
  θz::R
  s::S
end

GeocentricHelmert(; δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0) =
  GeocentricHelmert(δx * u"m", δy * u"m", δz * u"m", θx / 3600 * u"°", θy / 3600 * u"°", θz / 3600 * u"°", s * u"ppm")

function geocapply(transform::GeocentricHelmert, x)
  T = numtype(eltype(x))
  δ = translation(T, transform)
  R = rotation(T, transform)
  s = numconvert(T, transform.s)
  (1 + s) * R * x + δ
end

function geocapply(transform::Reverse{<:GeocentricHelmert}, x)
  T = numtype(eltype(x))
  δ = translation(T, transform)
  R = rotation(T, transform)
  s = numconvert(T, transform.s)
  (1 / (1 + s)) * inv(R) * (x - δ)
end
