# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    helmert(T, Datumₛ, Datumₜ)

Translation, Rotation and scale of the Helmert transform that converts
the source `Datumₛ` to target `Datumₜ`. 

The type `T` is the resulting machine type of the parameters.
"""
function helmert(::Type{T}, ::Type{Datumₛ}, ::Type{Datumₜ}) where {T,Datumₜ,Datumₛ}
  params = helmertparams(Datumₛ, Datumₜ)
  rates = helmertrates(Datumₛ, Datumₜ)
  δ, θ, s = if isnothing(rates)
    params
  else
    dt = epoch(Datumₛ) - epoch(Datumₜ)
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

Must be defined only for time-dependent Helmert transforms.
"""
helmertrates(::Type{Datumₛ}, ::Type{Datumₜ}) where {Datumₜ,Datumₛ} = nothing

"""
    translation(T, δ)

Translation vector from parameters `δ = (δx, δy, δz)` with machine type `T`.
"""
function translation(::Type{T}, (δx, δy, δz)) where {T}
  uδx = T(δx) * u"m"
  uty = T(δy) * u"m"
  utz = T(δz) * u"m"
  SVector(uδx, uty, utz)
end

"""
    rotation(T, θ)

`RotZYX` rotation from parameters `θ = (θx, θy, θz)` with machine type `T`.
"""
function rotation(::Type{T}, (θx, θy, θz)) where {T}
  uθx = T(θx) / 3600 * u"°"
  uθy = T(θy) / 3600 * u"°"
  uθz = T(θz) / 3600 * u"°"
  RotXYZ(uθx, uθy, uθz)
end

"""
    scale(T, s)

Scale from parameter `s` with machine type `T`.
"""
scale(::Type{T}, s) where {T} = T(s) * u"ppm"

# ----------------
# IMPLEMENTATIONS
# ----------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# source of parameters: 
# EPSG Database: https://epsg.org/search/by-name
# PROJ source code: https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp

helmertparams(::Type{WGS84{2296}}, ::Type{ITRF{2020}}) = (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0.0

helmertparams(::Type{WGS84{2139}}, ::Type{ITRF{2014}}) = (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0.0

helmertparams(::Type{WGS84{1762}}, ::Type{ITRF{2008}}) = (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0.0

helmertparams(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = (-0.2e-3, -1e-3, -3.3e-3), (0.0, 0.0, 0.0), 0.29e-3
helmertrates(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = (0.0, 0.1e-3, -0.1e-3), (0.0, 0.0, 0.0), -0.03e-3

helmertparams(::Type{GGRS87}, ::Type{<:WGS84}) = (-199.87, 74.79, 246.62), (0.0, 0.0, 0.0), 0.0

helmertparams(::Type{NAD83}, ::Type{<:WGS84}) = (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0.0

helmertparams(::Type{Potsdam}, ::Type{<:WGS84}) = (598.1, 73.7, 418.2), (0.202, 0.045, -2.455), 6.7

helmertparams(::Type{Carthage}, ::Type{<:WGS84}) = (-263.0, 6.0, 431.0), (0.0, 0.0, 0.0), 0.0

helmertparams(::Type{Hermannskogel}, ::Type{<:WGS84}) = (577.326, 90.129, 463.919), (5.137, 1.474, 5.297), 2.4232

helmertparams(::Type{Ire65}, ::Type{<:WGS84}) = (482.530, -130.596, 564.557), (-1.042, -0.214, -0.631), 8.15

helmertparams(::Type{NZGD1949}, ::Type{<:WGS84}) = (59.47, -5.04, 187.44), (0.47, -0.1, 1.024), -4.5993

helmertparams(::Type{OSGB36}, ::Type{<:WGS84}) = (446.448, -125.157, 542.060), (0.1502, 0.2470, 0.8421), -20.4894
