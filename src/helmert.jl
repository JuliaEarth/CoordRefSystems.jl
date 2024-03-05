# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    helmert(T, Datumₛ, Datumₜ, t)

Returns the translation, rotation and scale of the Helmert transform 
that convert the source `Datumₛ` to target `Datumₜ` with machine type `T`
and a given coordinate epoch `t` in decimalyear.
"""
function helmert(::Type{T}, ::Type{Datumₛ}, ::Type{Datumₜ}, t) where {T,Datumₜ,Datumₛ}
  params = helmertparams(Datumₛ, Datumₜ)
  rates = helmertrates(Datumₛ, Datumₜ)
  δ, θ, s = if isnothing(rates)
    params
  else
    dt = t - epoch(Datumₜ)
    map((p, dp) -> p .+ dp .* dt, params, rates)
  end
  translation(T, δ), rotation(T, θ), scale(T, s)
end

"""
    helmertparams(Datumₛ, Datumₜ)

Helmert translation parameters `(δx, δy, δz)` in meters, 
rotation parameters `(θx, θy, θz)` in arc seconds 
and scale parameter `s` in ppm (parts per million).
"""
function helmertparams end

"""
    helmertrates(Datumₛ, Datumₜ)

Helmert translation rate `(dδx, dδy, dδz)` in meters per year, 
rotation rate `(dθx, dθy, dθz)` in arc seconds per year 
and scale rate `ds` in ppm (parts per million) per year.

### Notes

Must be defined only for Time-dependent Helmert transforms.
"""
function helmertrates end

helmertrates(::Type{Datumₛ}, ::Type{Datumₜ}) where {Datumₜ,Datumₛ} = nothing

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

helmertparams(::Type{WGS84{1762}}, ::Type{ITRF{2008}}) = (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0.0

helmertparams(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = (-0.2e-3, -1e-3, -3.3e-3), (0.0, 0.0, 0.0), 0.29e-3
helmertrates(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = (0.0, 0.1e-3, -0.1e-3), (0.0, 0.0, 0.0), -0.03e-3
