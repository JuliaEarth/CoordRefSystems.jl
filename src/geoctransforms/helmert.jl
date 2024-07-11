# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct SimpleHelmert{T,R,S} <: GeocentricTransform
  δx::T
  δy::T
  δz::T
  θx::R
  θy::R
  θz::R
  s::S
end

SimpleHelmert(; δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0) =
  SimpleHelmert(δx * u"m", δy * u"m", δz * u"m", θx / 3600 * u"°", θy / 3600 * u"°", θz / 3600 * u"°", s * u"ppm")

function (transform::SimpleHelmert)(x)
  T = numtype(eltype(x))
  δ = translation(T, transform)
  R = rotation(T, transform)
  s = numconvert(T, transform.s)
  (1 + s) * R * x + δ
end

"""
    rotation(T, transform)

`RotZYX` rotation from parameters of `transform` with machine type `T`.
"""
function rotation(::Type{T}, transform::SimpleHelmert) where {T}
  θx = numconvert(T, transform.θx)
  θy = numconvert(T, transform.θx)
  θz = numconvert(T, transform.θx)
  RotXYZ(θx, θy, θz)
end

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

geoctransform(::Type{WGS84{2296}}, ::Type{ITRF{2020}}) = SimpleHelmert()

geoctransform(::Type{WGS84{2139}}, ::Type{ITRF{2014}}) = SimpleHelmert()

geoctransform(::Type{WGS84{1762}}, ::Type{ITRF{2008}}) = SimpleHelmert()

geoctransform(::Type{GGRS87}, ::Type{<:WGS84}) = SimpleHelmert(δx=-199.87, δy=74.79, δz=246.62)

geoctransform(::Type{NAD83}, ::Type{<:WGS84}) = SimpleHelmert()

geoctransform(::Type{Potsdam}, ::Type{<:WGS84}) =
  SimpleHelmert(δx=598.1, δy=73.7, δz=418.2, θx=0.202, θy=0.045, θz=-2.455, s=6.7)

geoctransform(::Type{Carthage}, ::Type{<:WGS84}) = SimpleHelmert(δx=-263.0, δy=6.0, δz=431.0)

geoctransform(::Type{Hermannskogel}, ::Type{<:WGS84}) =
  SimpleHelmert(δx=577.326, δy=90.129, δz=463.919, θx=5.137, θy=1.474, θz=5.297, s=2.4232)

geoctransform(::Type{Ire65}, ::Type{<:WGS84}) =
  SimpleHelmert(δx=482.530, δy=-130.596, δz=564.557, θx=-1.042, θy=-0.214, θz=-0.631, s=8.15)

geoctransform(::Type{NZGD1949}, ::Type{<:WGS84}) =
  SimpleHelmert(δx=59.47, δy=-5.04, δz=187.44, θx=0.47, θy=-0.1, θz=1.024, s=-4.5993)

geoctransform(::Type{OSGB36}, ::Type{<:WGS84}) =
  SimpleHelmert(δx=446.448, δy=-125.157, δz=542.060, θx=0.1502, θy=0.2470, θz=0.8421, s=-20.4894)
