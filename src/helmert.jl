# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    HelmertParams(tx, ty, tz, θx, θz, θy, s)

Helmert translation parameters `tx`, `ty` and `tz` in meters,
rotation parameters `θx`, `θy` and `θz` in arc seconds
and scale parameter `s` in ppm (parts per million).
"""
struct HelmertParams{T<:Met,R<:Deg,S<:PPM}
  tx::T
  ty::T
  tz::T
  θx::R
  θy::R
  θz::R
  s::S
end

function HelmertParams(tx, ty, tz, θx, θz, θy, s)
  utx = tx * u"m"
  uty = ty * u"m"
  utz = tz * u"m"
  uθx = θx / 3600 * u"°"
  uθy = θy / 3600 * u"°"
  uθz = θz / 3600 * u"°"
  us = s * u"ppm"
  HelmertParams(promote(utx, uty, utz)..., promote(uθx, uθy, uθz)..., us)
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
