# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct GeocentricTranslation{T} <: GeocentricTransform
  δx::T
  δy::T
  δz::T
end

GeocentricTranslation(; δx=0.0, δy=0.0, δz=0.0) = GeocentricTranslation(δx * u"m", δy * u"m", δz * u"m")

function (transform::GeocentricTranslation)(x)
  δ = translation(numtype(eltype(x)), transform)
  x + δ
end

# ----------------
# IMPLEMENTATIONS
# ----------------

# source of parameters: 
# EPSG Database: https://epsg.org/search/by-name

geoctransform(::Type{<:WGS84}, ::Type{SAD69}) = GeocentricTranslation(δx=-57.0, δy=1.0, δz=-41.0)
geoctransform(::Type{SAD69}, ::Type{<:WGS84}) = GeocentricTranslation(δx=57.0, δy=-1.0, δz=41.0)
