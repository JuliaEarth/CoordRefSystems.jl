# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct HelmertParams{T,S,R}
  x::T
  y::T
  z::T
  s::S
  rx::R
  ry::R
  rz::R
end

"""
    helmertparams(Datumₛ, Datumₜ)

Returns the Helmert transform parameters that convert the source `Datumₛ` to target `Datumₜ`.
"""
function helmertparams end

"""
    rotation(T, params::HelmertParams)

Returns the `RotZYX` rotation from Helmert `params` with machine type `T`.
"""
rotation(::Type{T}, params::HelmertParams) where {T} =
  RotZYX(numconvert(T, params.rz), numconvert(T, params.ry), numconvert(T, params.rz))

"""
    translation(T, params::HelmertParams)

Returns the translation vector from Helmert `params` with machine type `T`.
"""
translation(::Type{T}, params::HelmertParams) where {T} =
  SVector(numconvert(T, params.x), numconvert(T, params.y), numconvert(T, params.z))

"""
    scale(T, params::HelmertParams)

Returns the scale parameter from Helmert `params` with machine type `T`.
"""
scale(::Type{T}, params::HelmertParams) where {T} = numconvert(T, params.s)
