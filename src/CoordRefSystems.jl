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
using DataDeps

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

function __init__()
  # make sure datasets are always downloaded
  # without user interaction from DataDeps.jl
  ENV["DATADEPS_ALWAYS_ACCEPT"] = true

  # register EPSG dataset
  registerEPSG()
end

function registerEPSG()
  ID = "epsg-wkt2"
  try
    # if data is already on disk
    # we just return the path
    @datadep_str ID
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    try
      register(DataDep(ID,
        """
        EPSG dataset providing coordinate reference system definitions in WKT 2 format.
        For terms of use and more information, please check https://epsg.org/terms-of-use.html
        """,
        # TODO: update the URL to JuliaEarth hosted version
        "https://github.com/Omar-Elrefaei/EPSG-WKT2/raw/refs/heads/main/EPSG-latest-WKT.Zip",
        Any,
        post_fetch_method=DataDeps.unpack
      ))
      @datadep_str ID
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end
end

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
  OSGB36,
  PD83,
  Potsdam,
  RD83,
  RGF93v1,
  RGF93v2,
  RGF93v2b,
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
  Lambert,
  Behrmann,
  GallPeters,
  WinkelTripel,
  Robinson,
  OrthoNorth,
  OrthoSouth,
  TransverseMercator,
  Albers,
  Sinusoidal,
  LambertAzimuthalEqualArea,
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
