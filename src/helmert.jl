# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    HelmertParams(; tx, ty, tz, θx, θz, θy, s)

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

function HelmertParams(; tx, ty, tz, θx, θz, θy, s)
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
    helmerttimedep(; tx, ty, tz, θx, θz, θy, s, dtx, dty, dtz, dθx, dθy, dθz, ds, t, t₀)

Returns the Time-dependent Helmert ajusted parameters (`tx`, `ty`, `tz`, `θx`, `θz`, `θy`, `s`)
using their rates (`dtx`, `dty`, `dtz`, `dθx`, `dθy`, `dθz`, `ds`) in parameter unit per year,
the coordinate epoch `t` and the reference epoch `t₀` in years.
"""
function helmerttimedep(; tx, ty, tz, θx, θz, θy, s, dtx, dty, dtz, dθx, dθy, dθz, ds, t, t₀)
  dt = (t - t₀)
  tx′ = tx + dtx * dt
  ty′ = ty + dty * dt
  tz′ = tz + dtz * dt
  θx′ = θx + dθx * dt
  θy′ = θy + dθy * dt
  θz′ = θz + dθz * dt
  s′ = s + ds * dt
  HelmertParams(tx=tx′, ty=ty′, tz=tz′, θx=θx′, θz=θz′, θy=θy′, s=s′)
end

"""
    helmertparams(Datumₛ, Datumₜ, t)

Returns the Helmert transform parameters that convert the source `Datumₛ` to target `Datumₜ`
with a given coordinate epoch `t` in year.
"""
helmertparams(::Type{Datumₛ}, ::Type{Datumₜ}, t) where {Datumₜ,Datumₛ} = helmertparams(Datumₛ, Datumₜ, t, epoch(Datumₜ))

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

# ----------------
# IMPLEMENTATIONS
# ----------------

# source of parameters: EPSG Database (https://epsg.org/search/by-name)

helmertparams(::Type{WGS84{1762}}, ::Type{ITRF{2008}}, t, t₀) =
  HelmertParams(tx=0.0, ty=0.0, tz=0.0, θx=0.0, θz=0.0, θy=0.0, s=0.0)

function helmertparams(::Type{ITRF{2008}}, ::Type{ITRF{2020}}, t, t₀)
  helmerttimedep(;
    tx=-0.2e-3,
    ty=-1e-3,
    tz=-3.3e-3,
    θx=0.0,
    θz=0.0,
    θy=0.0,
    s=0.29e-3,
    dtx=0.0,
    dty=0.1e-3,
    dtz=-0.1e-3,
    dθx=0.0,
    dθy=0.0,
    dθz=0.0,
    ds=-0.03e-3,
    t,
    t₀
  )
end
