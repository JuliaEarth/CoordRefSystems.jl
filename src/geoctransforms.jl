# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

abstract type GeocentricTransform end

struct Reverse{T<:GeocentricTransform} <: GeocentricTransform
  transform::T
end

function geoctransform end

function geocapply end

include("geoctransforms/utils.jl")
include("geoctransforms/geocidentity.jl")
include("geoctransforms/geoctranslation.jl")
include("geoctransforms/geochelmert.jl")

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

geoctransform(::Type{<:WGS84}, ::Type{SAD69}) = GeocentricTranslation(δx=-57.0, δy=1.0, δz=-41.0)

geoctransform(::Type{WGS84{2296}}, ::Type{ITRF{2020}}) = GeocentricIdentity()

geoctransform(::Type{WGS84{2139}}, ::Type{ITRF{2014}}) = GeocentricIdentity()

geoctransform(::Type{WGS84{1762}}, ::Type{ITRF{2008}}) = GeocentricIdentity()

geoctransform(::Type{GGRS87}, ::Type{<:WGS84}) = GeocentricHelmert(δx=-199.87, δy=74.79, δz=246.62)

geoctransform(::Type{NAD83}, ::Type{<:WGS84}) = GeocentricIdentity()

geoctransform(::Type{Potsdam}, ::Type{<:WGS84}) =
  GeocentricHelmert(δx=598.1, δy=73.7, δz=418.2, θx=0.202, θy=0.045, θz=-2.455, s=6.7)

geoctransform(::Type{Carthage}, ::Type{<:WGS84}) = GeocentricHelmert(δx=-263.0, δy=6.0, δz=431.0)

geoctransform(::Type{Hermannskogel}, ::Type{<:WGS84}) =
  GeocentricHelmert(δx=577.326, δy=90.129, δz=463.919, θx=5.137, θy=1.474, θz=5.297, s=2.4232)

geoctransform(::Type{Ire65}, ::Type{<:WGS84}) =
  GeocentricHelmert(δx=482.530, δy=-130.596, δz=564.557, θx=-1.042, θy=-0.214, θz=-0.631, s=8.15)

geoctransform(::Type{NZGD1949}, ::Type{<:WGS84}) =
  GeocentricHelmert(δx=59.47, δy=-5.04, δz=187.44, θx=0.47, θy=-0.1, θz=1.024, s=-4.5993)

geoctransform(::Type{OSGB36}, ::Type{<:WGS84}) =
  GeocentricHelmert(δx=446.448, δy=-125.157, δz=542.060, θx=0.1502, θy=0.2470, θz=0.8421, s=-20.4894)

geoctransform(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = timedephelmert(
  ITRF{2008},
  ITRF{2020},
  δx=-0.2e-3,
  δy=-1e-3,
  δz=-3.3e-3,
  s=0.29e-3,
  dδy=0.1e-3,
  dδz=-0.1e-3,
  ds=0.03e-3
)
