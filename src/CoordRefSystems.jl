# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module CoordRefSystems

using Unitful
using Unitful: numtype
using Unitful: m, rad, °
using Zygote: gradient
using Rotations: RotXYZ
using StaticArrays: SVector

import Random
import Base: ==

include("utils.jl")
include("ioutils.jl")
include("ellipsoids.jl")
include("datums.jl")
include("transforms.jl")
include("modes.jl")
include("crs.jl")
include("promotion.jl")
include("utm.jl")
include("shift.jl")
include("codes.jl")
include("strings.jl")
include("get.jl")

export
  # revolution ellipsoids
  RevolutionEllipsoid,
  majoraxis,
  minoraxis,
  eccentricity,
  eccentricity²,
  flattening,
  flattening⁻¹,

  # datums
  Datum,
  NoDatum,
  WGS84,
  WGS84Latest,
  ITRF,
  ITRFLatest,
  Aratu,
  Carthage,
  GGRS87,
  GRS80S,
  Hermannskogel,
  IGS20,
  Ire65,
  IRENET95,
  NAD83,
  NZGD1949,
  OSGB36,
  Potsdam,
  SAD69,
  SAD96,
  SIRGAS2000,
  ellipsoid,
  epoch,

  # coordinates
  CRS,
  Cartesian,
  Cartesian2D,
  Cartesian3D,
  Polar,
  Cylindrical,
  Spherical,
  GeodeticLatLon,
  GeodeticLatLonAlt,
  GeocentricLatLon,
  AuthalicLatLon,
  LatLon,
  LatLonAlt,
  Mercator,
  WebMercator,
  PlateCarree,
  Lambert,
  Behrmann,
  GallPeters,
  WinkelTripel,
  Robinson,
  OrthoNorth,
  OrthoSouth,
  TransverseMercator,
  datum,
  indomain,

  # UTM
  utm,
  utmnorth,
  utmsouth,

  # codes
  EPSG,
  ESRI

end
