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
    helmertparams(Datumₛ, Datumₜ, t)

Returns the Helmert transform parameters that convert the source `Datumₛ` to target `Datumₜ`
with a given observation time `t` in decimalyear.
"""
function helmertparams end

"""
    rotation(T, params::HelmertParams)

Returns the `RotZYX` rotation from Helmert `params` with machine type `T`.
"""
rotation(::Type{T}, params::HelmertParams) where {T} =
  RotZYX(numconvert(T, params.θz), numconvert(T, params.θy), numconvert(T, params.θz))

"""
    translation(T, params::HelmertParams)

Returns the translation vector from Helmert `params` with machine type `T`.
"""
translation(::Type{T}, params::HelmertParams) where {T} =
  SVector(numconvert(T, params.tx), numconvert(T, params.ty), numconvert(T, params.tz))

"""
    scale(T, params::HelmertParams)

Returns the scale parameter from Helmert `params` with machine type `T`.
"""
scale(::Type{T}, params::HelmertParams) where {T} = numconvert(T, params.s)

function helmerttimedep(tx, ty, tz, θx, θz, θy, s, dtx, dty, dtz, dθx, dθy, dθz, ds, t, t₀)
  Δt = (t - t₀)
  tx′ = tx + dtx * Δt
  ty′ = ty + dty * Δt
  tz′ = tz + dtz * Δt
  θx′ = θx + dθx * Δt
  θy′ = θy + dθy * Δt
  θz′ = θz + dθz * Δt
  s′ = s + ds * Δt
  HelmertParams(tx′, ty′, tz′, θx′, θz′, θy′, s′)
end

# parameters source: EPSG Database (https://epsg.org/search/by-name)

helmertparams(::Type{WGS84{1762}}, ::Type{ITRF{2008}}, t) = HelmertParams(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
function helmertparams(::Type{ITRF{2008}}, ::Type{ITRF{2020}}, t)
  t₀ = epoch(ITRF{2020})
  helmerttimedep(-0.2e-3, -1e-3, -3.3e-3, 0.0, 0.0, 0.0, 0.29e-3, 0.0, 0.1e-3, -0.1e-3, 0.0, 0.0, 0.0, -0.03e-3, t, t₀)
end
