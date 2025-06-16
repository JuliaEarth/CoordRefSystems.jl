# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module CoordRefSystems

using Unitful
using Unitful: numtype
using Unitful: m, rad, °, ppm
using Zygote: gradient
using Rotations: RotXYZ
using StaticArrays: SVector

import Random
import Base: ==

include("utils.jl")
include("ioutils.jl")
include("ellipsoids.jl")
include("datums.jl")
include("modes.jl")
include("crs.jl")
include("transforms.jl")
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
  ETRF,
  ETRFLatest,
  NAD83CSRS,
  NAD83CSRSLatest,
  Aratu,
  Carthage,
  Datum73,
  DHDN,
  ED50,
  ED79,
  ED87,
  GDA94,
  GGRS87,
  GRS80S,
  Hermannskogel,
  IGS20,
  Ire65,
  IRENET95,
  ISN93,
  ISN2004,
  ISN2016,
  Lisbon1890,
  Lisbon1937,
  NAD27,
  NAD83,
  NTF,
  NZGD1949,
  NZGD2000,
  OSGB36,
  PD83,
  Potsdam,
  RD83,
  RGF93v1,
  RGF93v2,
  RGF93v2b,
  RNB72,
  SAD69,
  SAD96,
  SIRGAS2000,
  ellipsoid,
  epoch,

  # coordinates
  CRS,

  # basic
  Cartesian,
  Cartesian2D,
  Cartesian3D,
  Polar,
  Cylindrical,
  Spherical,

  # geographic
  GeodeticLatLon,
  GeodeticLatLonAlt,
  GeocentricLatLon,
  GeocentricLatLonAlt,
  AuthalicLatLon,
  LatLon,
  LatLonAlt,

  # projected
  Mercator,
  WebMercator,
  PlateCarree,
  LambertCylindrical,
  Behrmann,
  GallPeters,
  WinkelTripel,
  Robinson,
  OrthoNorth,
  OrthoSouth,
  TransverseMercator,
  Albers,
  Sinusoidal,
  LambertAzimuthal,
  LambertConic,
  EqualEarth,
  datum,
  indomain,
  isconformal,
  isequalarea,
  isequidistant,
  iscompromise,

  # UTM
  utm,
  utmnorth,
  utmsouth,

  # codes
  EPSG,
  ESRI

end
