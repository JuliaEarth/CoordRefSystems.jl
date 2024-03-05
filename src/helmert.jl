# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    helmertparams(Datumₛ, Datumₜ, T, t)

Returns the translation, rotation and scale of the Helmert transform 
that convert the source `Datumₛ` to target `Datumₜ` with machine type `T`
and a given coordinate epoch `t` in decimalyear.
"""
function helmertparams(::Type{Datumₛ}, ::Type{Datumₜ}, ::Type{T}, t) where {Datumₜ,Datumₛ,T}
  rates = helmertrate(Datumₛ, Datumₜ)
  δ, θ, s = if isnothing(rates)
    helmertinit(Datumₛ, Datumₜ)
  else
    δ, θ, s = helmertinit(Datumₛ, Datumₜ)
    t₀ = epoch(Datumₜ)
    dt = t - t₀
    dδ, dθ, ds = rates
    δ′ = δ .+ dδ .* dt
    θ′ = θ .+ dθ .* dt
    s′ = s + ds * dt
    δ′, θ′, s′
  end
  translation(T, δ), rotation(T, θ), scale(T, s)
end

"""
    helmertinit(Datumₛ, Datumₜ)

Returns the Helmert translation parameters `(δx, δy, δz)` in meters, 
rotation parameters `(θx, θy, θz)` in arc seconds 
and scale parameter `s` in ppm (parts per million).
"""
function helmertinit end

"""
    helmertrate(Datumₛ, Datumₜ)

Returns the Helmert translation rate `(dδx, dty, dtz)` in meters per year, 
rotation rate `(dθx, dθy, dθz)` in arc seconds per year 
and scale rate `ds` in ppm (parts per million) per year.

Must be defined only for Time-dependent Helmert transforms.
"""
function helmertrate end

helmertrate(::Type{Datumₛ}, ::Type{Datumₜ}) where {Datumₜ,Datumₛ} = nothing

"""
    translation(T, δ)

Returns the translation vector from parameters `δ = (δx, δy, δz)` with machine type `T`.
"""
function translation(::Type{T}, (δx, δy, δz)) where {T}
  uδx = T(δx) * u"m"
  uty = T(δy) * u"m"
  utz = T(δz) * u"m"
  SVector(uδx, uty, utz)
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
