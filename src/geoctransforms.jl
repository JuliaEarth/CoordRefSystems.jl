# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

abstract type GeocentricTransform end

function geoctransform end

"""
    translation(T, transform)

Translation vector from parameters of `transform` with machine type `T`.
"""
function translation(::Type{T}, transform::GeocentricTransform) where {T}
  δx = numconvert(T, transform.δx)
  δy = numconvert(T, transform.δy)
  δz = numconvert(T, transform.δz)
  SVector(δx, δy, δz)
end

include("geoctransforms/helmert.jl")
include("geoctransforms/timedephelmert.jl")
include("geoctransforms/geoctranslation.jl")
