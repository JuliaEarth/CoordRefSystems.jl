# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

include("transforms/identity.jl")
include("transforms/geoctranslation.jl")
include("transforms/helmert.jl")
include("transforms/timedephelmert.jl")
include("transforms/sequential.jl")

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
@identity NAD83 WGS84

# https://epsg.org/transformation_7666/WGS-84-G1762-to-ITRF2008-1.html
@identity WGS84{1762} ITRF{2008}

# https://epsg.org/transformation_9757/WGS-84-G2139-to-ITRF2014-1.html
@identity WGS84{2139} ITRF{2014}

# https://epsg.org/transformation_10608/WGS-84-G2296-to-ITRF2020-1.html
@identity WGS84{2296} ITRF{2020}

# https://epsg.org/transformation_1149/ETRS89-to-WGS-84-1.html
@identity ETRF{2020} WGS84{2296}

# https://epsg.org/transformation_1565/NZGD2000-to-WGS-84-1.html
@identity NZGD2000 WGS84

# https://epsg.org/transformation_1130/Carthage-to-WGS-84-1.html
@geoctranslation Carthage WGS84 (δx=-263.0, δy=6.0, δz=431.0)

# https://epsg.org/transformation_1272/GGRS87-to-WGS-84-1.html
@geoctranslation GGRS87 WGS84 (δx=-199.87, δy=74.79, δz=246.62)

# https://epsg.org/transformation_15485/SAD69-to-SIRGAS-2000-1.html
@geoctranslation SAD69 SIRGAS2000 (δx=-67.35, δy=3.88, δz=-38.22)

# https://epsg.org/transformation_1864/SAD69-to-WGS-84-1.html
@geoctranslation SAD69 WGS84 (δx=-57.0, δy=1.0, δz=-41.0)

# https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp
@helmert Hermannskogel WGS84 (δx=577.326, δy=90.129, δz=463.919, θx=5.137, θy=1.474, θz=5.297, s=2.4232)

# https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp
@helmert Ire65 WGS84 (δx=482.530, δy=-130.596, δz=564.557, θx=-1.042, θy=-0.214, θz=-0.631, s=8.15)

# https://epsg.org/transformation_1564/NZGD49-to-WGS-84-2.html
@helmert NZGD1949 WGS84 (δx=59.47, δy=-5.04, δz=187.44, θx=0.47, θy=-0.1, θz=1.024, s=-4.5993)

# https://epsg.org/transformation_1314/OSGB36-to-WGS-84-6.html
@helmert OSGB36 WGS84 (δx=446.448, δy=-125.157, δz=542.060, θx=0.1502, θy=0.2470, θz=0.8421, s=-20.4894)

# https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp
@helmert Potsdam WGS84 (δx=598.1, δy=73.7, δz=418.2, θx=0.202, θy=0.045, θz=-2.455, s=6.7)

# https://epsg.org/transformation_9960/WGS-84-Transit-to-WGS-84-G730-1.html
@helmert WGS84{0} WGS84{730} (δx=-58e-3, δy=521e-3, δz=239e-3, θx=-18.3e-3, θy=0.3e-3, θz=-7e-3, s=10.7e-3)

# https://epsg.org/transformation_9961/WGS-84-G730-to-WGS-84-G873-1.html
@helmert WGS84{730} WGS84{873} (δx=-20e-3, δy=-16e-3, δz=14e-3, s=-0.69e-3)

# https://epsg.org/transformation_7668/WGS-84-G1150-to-WGS-84-G1762-1.html
@helmert WGS84{1150} WGS84{1762} (δx=-6e-3, δy=5e-3, δz=20e-3, s=-4.5e-3)

# https://epsg.org/transformation_7667/WGS-84-G1674-to-WGS-84-G1762-1.html
@helmert WGS84{1674} WGS84{1762} (δx=-4e-3, δy=3e-3, δz=4e-3, θx=-0.27e-3, θy=0.27e-3, θz=-0.38e-3, s=-6.9e-3)

# https://epsg.org/transformation_9756/WGS-84-G1762-to-WGS-84-G2139-1.html
@helmert WGS84{1762} WGS84{2139} (δx=0.0058, δy=-0.0064, δz=0.007, θx=-0.08e-3, θy=-0.04e-3, θz=-0.12e-3, s=-4.4e-3)

# https://epsg.org/transformation_10607/WGS-84-G2139-to-WGS-84-G2296-1.html
@helmert WGS84{2139} WGS84{2296} (δx=2.6e-3, δy=5.4e-3, δz=-0.9e-3, θx=0.01e-3, θy=0.07e-3, s=0.06e-3)

# https://epsg.org/transformation_9992/ITRF2008-to-ITRF2020-1.html
@timedephelmert ITRF{2008} ITRF{2020} (δx=-0.2e-3, δy=-1e-3, δz=-3.3e-3, s=0.29e-3, dδy=0.1e-3, dδz=-0.1e-3, ds=0.03e-3)

# https://epsg.org/transformation_9962/WGS-84-G873-to-WGS-84-G1150-1.html
@timedephelmert WGS84{873} WGS84{1150} (
  δx=1.1e-3,
  δy=-4.7e-3,
  δz=22e-3,
  θz=-0.16e-3,
  s=1.45e-3,
  dδy=0.6e-3,
  dδz=1.4e-3,
  dθz=-0.02e-3,
  ds=-0.01e-3,
  tᵣ=2005.0 # reference epoch differs from epoch of target datum
)

# https://epsg.org/transformation_9963/WGS-84-G1150-to-WGS-84-G1674-1.html
@timedephelmert WGS84{1150} WGS84{1674} (
  δx=-2.4e-3,
  δy=1.6e-3,
  δz=23.2e-3,
  θx=0.27e-3,
  θy=-0.27e-3,
  θz=0.38e-3,
  s=2.08e-3,
  dδx=-0.1e-3,
  dδy=-0.1e-3,
  dδz=1.8e-3,
  ds=-0.08e-3
)

@sequential ITRF{2008} WGS84{1762} WGS84{2139} WGS84{2296}

@sequential ITRF{2014} WGS84{2139} WGS84{2296}

@sequential WGS84{0} WGS84{730} WGS84{873} WGS84{1150} WGS84{1674} WGS84{1762} WGS84{2139} WGS84{2296}

@sequential WGS84{730} WGS84{873} WGS84{1150} WGS84{1674} WGS84{1762} WGS84{2139} WGS84{2296}

@sequential WGS84{873} WGS84{1150} WGS84{1674} WGS84{1762} WGS84{2139} WGS84{2296}

@sequential WGS84{1150} WGS84{1674} WGS84{1762} WGS84{2139} WGS84{2296}

@sequential WGS84{1674} WGS84{1762} WGS84{2139} WGS84{2296}

@sequential WGS84{1762} WGS84{2139} WGS84{2296}
