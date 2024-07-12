# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Transform

Transform that converts coordinates between datums.  
"""
abstract type Transform end

"""
    Reverse(transform)

Reverse of `transform`.
"""
struct Reverse{T<:Transform} <: Transform
  transform::T
end

Base.getproperty(transform::Reverse, name::Symbol) = getproperty(getfield(transform, :transform), name)

"""
    @reversible Datum₁ Datum₂ transform

Define the methods to apply and reverse the `transform` with `Datum₁` and `Datum₂`.
"""
macro reversible(Datum₁, Datum₂, transform)
  expr = quote
    transform(::Type{<:$Datum₁}, ::Type{<:$Datum₂}) = $transform
    transform(D₂::Type{<:$Datum₂}, D₁::Type{<:$Datum₁}) = Reverse(transform(D₁, D₂))
  end
  esc(expr)
end

"""
    transform(Datumₛ, Datumₜ)

Transform that converts the source datum `Datumₛ` to target datum `Datumₜ`.
"""
function transform end

"""
    apply(transform, x)

Apply the `transform` in a vector of coordinates `x`.
"""
function apply end

include("transforms/utils.jl")
include("transforms/identity.jl")
include("transforms/geoctranslation.jl")
include("transforms/helmert.jl")

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

# https://epsg.org/transformation_1188/NAD83-to-WGS-84-1.html
@reversible NAD83 WGS84 Identity()

# https://epsg.org/transformation_7666/WGS-84-G1762-to-ITRF2008-1.html
@reversible WGS84{1762} ITRF{2008} Identity()

# https://epsg.org/transformation_9757/WGS-84-G2139-to-ITRF2014-1.html
@reversible WGS84{2139} ITRF{2014} Identity()

# https://epsg.org/transformation_10608/WGS-84-G2296-to-ITRF2020-1.html
@reversible WGS84{2296} ITRF{2020} Identity()

# https://epsg.org/transformation_1130/Carthage-to-WGS-84-1.html
@reversible Carthage WGS84 GeocentricTranslation(δx=-263.0, δy=6.0, δz=431.0)

# https://epsg.org/transformation_1272/GGRS87-to-WGS-84-1.html
@reversible GGRS87 WGS84 GeocentricTranslation(δx=-199.87, δy=74.79, δz=246.62)

# https://epsg.org/transformation_15485/SAD69-to-SIRGAS-2000-1.html
@reversible SAD69 SIRGAS2000 GeocentricTranslation(δx=-67.35, δy=3.88, δz=-38.22)

# https://epsg.org/transformation_1864/SAD69-to-WGS-84-1.html
@reversible SAD69 WGS84 GeocentricTranslation(δx=-57.0, δy=1.0, δz=-41.0)

# https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp
@reversible Hermannskogel WGS84 HelmertTransform(
  δx=577.326,
  δy=90.129,
  δz=463.919,
  θx=5.137,
  θy=1.474,
  θz=5.297,
  s=2.4232
)

# https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp
@reversible Ire65 WGS84 HelmertTransform(δx=482.530, δy=-130.596, δz=564.557, θx=-1.042, θy=-0.214, θz=-0.631, s=8.15)

# https://epsg.org/transformation_1564/NZGD49-to-WGS-84-2.html
@reversible NZGD1949 WGS84 HelmertTransform(δx=59.47, δy=-5.04, δz=187.44, θx=0.47, θy=-0.1, θz=1.024, s=-4.5993)

# https://epsg.org/transformation_1314/OSGB36-to-WGS-84-6.html
@reversible OSGB36 WGS84 HelmertTransform(
  δx=446.448,
  δy=-125.157,
  δz=542.060,
  θx=0.1502,
  θy=0.2470,
  θz=0.8421,
  s=-20.4894
)

# https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp
@reversible Potsdam WGS84 HelmertTransform(δx=598.1, δy=73.7, δz=418.2, θx=0.202, θy=0.045, θz=-2.455, s=6.7)

# https://epsg.org/transformation_9992/ITRF2008-to-ITRF2020-1.html
@reversible ITRF{2008} ITRF{2020} timedephelmert(
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
