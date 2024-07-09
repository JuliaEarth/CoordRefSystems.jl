# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module CoordRefSystems

using Unitful
using Unitful: numtype
using Zygote: gradient
using Rotations: RotXYZ
using StaticArrays: SVector

import Random
import Base: ==

include("utils.jl")
include("ioutils.jl")
include("ellipsoids.jl")
include("datums.jl")
include("helmert.jl")
include("crs.jl")
include("shift.jl")
include("codes.jl")
include("crsstrings.jl")

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
  GRS80S,
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
  UTM,
  UTMNorth,
  UTMSouth,
  allapprox,
  datum,
  indomain,

  # hemispheres
  North,
  South,

  # codes
  EPSG,
  ESRI

end
