# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    translation(T, transform)

Translation vector from parameters of `transform` with machine type `T`.
"""
function translation(::Type{T}, transform::Transform) where {T}
  δx = numconvert(T, transform.δx)
  δy = numconvert(T, transform.δy)
  δz = numconvert(T, transform.δz)
  SVector(δx, δy, δz)
end

"""
    rotation(T, transform)

`RotZYX` rotation from parameters of `transform` with machine type `T`.
"""
function rotation(::Type{T}, transform::Transform) where {T}
  θx = numconvert(T, transform.θx)
  θy = numconvert(T, transform.θy)
  θz = numconvert(T, transform.θz)
  RotXYZ(θx, θy, θz)
end
