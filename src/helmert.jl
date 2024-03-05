# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    helmertparams(Datumₛ, Datumₜ, T, e)

Returns the translation, rotation and scale of the Helmert transform 
that convert the source `Datumₛ` to target `Datumₜ` with machine type `T`
and a given coordinate epoch `e` in decimalyear.
"""
function helmertparams(::Type{Datumₛ}, ::Type{Datumₜ}, ::Type{T}, e) where {Datumₜ,Datumₛ,T}
  t, θ, s = helmertinit(Datumₛ, Datumₜ)
  rates = helmertrate(Datumₛ, Datumₜ)
  if isnothing(rates)
    translation(T, t), rotation(T, θ), scale(T, s)
  else
    e₀ = epoch(Datumₜ)
    de = e - e₀
    dt, dθ, ds = rates
    t′ = t .+ dt .* de
    θ′ = θ .+ dθ .* de
    s′ = s + ds * de
    translation(T, t′), rotation(T, θ′), scale(T, s′)
  end
end

"""
    helmertinit(Datumₛ, Datumₜ)

Returns the Helmert translation parameters `(tx, ty, tz)` in meters, 
rotation parameters `(θx, θy, θz)` in arc seconds 
and scale parameter `s` in ppm (parts per million).
"""
function helmertinit end

"""
    helmertrate(Datumₛ, Datumₜ)

Returns the Helmert translation rate `(dtx, dty, dtz)` in meters per year, 
rotation rate `(dθx, dθy, dθz)` in arc seconds per year 
and scale rate `ds` in ppm (parts per million) per year.

Must be defined only for Time-dependent Helmert transforms.
"""
function helmertrate end

helmertrate(::Type{Datumₛ}, ::Type{Datumₜ}) where {Datumₜ,Datumₛ} = nothing

"""
    translation(T, t)

Returns the translation vector from parameters `t = (tx, ty, tz)` with machine type `T`.
"""
function translation(::Type{T}, (tx, ty, tz)) where {T}
  utx = T(tx) * u"m"
  uty = T(ty) * u"m"
  utz = T(tz) * u"m"
  SVector(utx, uty, utz)
end

"""
    rotation(T, θ)

Returns the `RotZYX` rotation from parameters `θ = (θx, θy, θz)` with machine type `T`.
"""
function rotation(::Type{T}, (θx, θy, θz)) where {T}
  uθx = T(θx) / 3600 * u"°"
  uθy = T(θy) / 3600 * u"°"
  uθz = T(θz) / 3600 * u"°"
  RotZYX(uθz, uθy, uθx)
end

"""
    scale(T, s)

Returns the scale parameter from parameter `s` with machine type `T`.
"""
scale(::Type{T}, s) where {T} = T(s) * u"ppm"

# ----------------
# IMPLEMENTATIONS
# ----------------

# source of parameters: EPSG Database (https://epsg.org/search/by-name)

helmertinit(::Type{WGS84{1762}}, ::Type{ITRF{2008}}) = (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0.0

helmertinit(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = (-0.2e-3, -1e-3, -3.3e-3), (0.0, 0.0, 0.0), 0.29e-3
helmertrate(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = (0.0, 0.1e-3, -0.1e-3), (0.0, 0.0, 0.0), -0.03e-3
