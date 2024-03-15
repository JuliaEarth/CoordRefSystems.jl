# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module Cartography

using Unitful
using Unitful: numtype
using Zygote: gradient
using Rotations: RotXYZ
using StaticArrays: SVector

include("utils.jl")
include("ioutils.jl")
include("ellipsoids.jl")
include("datums.jl")
include("helmert.jl")
include("crs.jl")
include("codes.jl")

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
  GGRS87,
  NAD83,
  Potsdam,
  Carthage,
  Hermannskogel,
  Ire65,
  NZGD1949,
  OSGB36,
  ellipsoid,
  epoch,

  # coordinates
  CRS,
  Cartesian,
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
  UTMNorth,
  UTMSouth,
  datum,
  indomain,

  # codes
  EPSG,
  ESRI

end
