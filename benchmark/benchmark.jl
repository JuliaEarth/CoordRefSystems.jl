using Cartography
import Geodesy
import Proj

using PrettyTables
using BenchmarkTools

function projtime(trans, invtrans, (lat, lon))
  fwdtime = @belapsed $trans($lat, $lon)
  coord = trans(lat, lon)
  invtime = @belapsed $invtrans($coord)
  fwdtime, invtime
end

function geodesytime(trans, invtrans, (lat, lon))
  latlon = Geodesy.LLA(lat, lon, 0.0)
  fwdtime = @belapsed $trans($latlon)
  coord = trans(latlon)
  invtime = @belapsed $invtrans($coord)
  fwdtime, invtime
end

function cartographytime(CRS, (lat, lon))
  latlon = LatLon(lat, lon)
  fwdtime = @belapsed convert(CRS, $latlon)
  coord = convert(CRS, latlon)
  invtime = @belapsed convert(LatLon, $coord)
  fwdtime, invtime
end

projargs = let
  # -------------
  # WEB MERCATOR
  # -------------

  pfwdwmerc = Proj.Transformation("EPSG:4326", "EPSG:3857")
  pinvwmerc = inv(pfwdwmerc)

  gfwdwmerc = Geodesy.WebMercatorfromLLA(Geodesy.wgs84)
  ginvwmerc = inv(gfwdwmerc)

  # --------
  # UTM 32N
  # --------

  pfwdutm = Proj.Transformation("""
  proj=pipeline
  step proj=axisswap order=2,1
  step proj=unitconvert xy_in=deg xy_out=rad
  step proj=utm zone=38 ellps=WGS84
  """)
  pinvutm = Proj.Transformation("""
  proj=pipeline
  step proj=utm inv zone=38 ellps=WGS84
  step proj=unitconvert xy_in=rad xy_out=deg
  step proj=axisswap order=2,1
  """)

  gfwdutm = Geodesy.UTMfromLLA(38, true, Geodesy.wgs84)
  ginvutm = inv(gfwdutm)

  # ---------
  # MERCATOR
  # ---------

  pfwdmerc = Proj.Transformation("EPSG:4326", "EPSG:3395")
  pinvmerc = inv(pfwdmerc)

  # -------------
  # PLATE CARRÉE
  # -------------

  pfwdplate = Proj.Transformation("EPSG:4326", "EPSG:32662")
  pinvplate = inv(pfwdplate)

  # --------
  # LAMBERT
  # --------

  pfwdlambert = Proj.Transformation("EPSG:4326", "ESRI:54034")
  pinvlambert = inv(pfwdlambert)

  # --------------
  # WINKEL TRIPEL
  # --------------

  pfwdwinkel = Proj.Transformation("EPSG:4326", "ESRI:54042")
  pinvwinkel = inv(pfwdwinkel)

  # ---------
  # ROBINSON
  # ---------

  pfwdrobin = Proj.Transformation("EPSG:4326", "ESRI:54030")
  pinvrobin = inv(pfwdrobin)

  # -----------------------
  # ORTHOGRAPHIC SPHERICAL
  # -----------------------

  OrthoNorthSpherical = Cartography.crs(ESRI{102035})

  pfwdorthosphere = Proj.Transformation("EPSG:4326", "ESRI:102035")
  pinvorthosphere = inv(pfwdorthosphere)

  # ------------------------
  # ORTHOGRAPHIC ELLIPTICAL
  # ------------------------

  pfwdorthoellip = Proj.Transformation("""
  proj=pipeline
  step proj=axisswap order=2,1
  step proj=unitconvert xy_in=deg xy_out=rad
  step proj=ortho lat_0=90 lon_0=0 ellps=WGS84
  """)
  pinvorthoellip = Proj.Transformation("""
  proj=pipeline
  step proj=ortho inv lat_0=90 lon_0=0 ellps=WGS84
  step proj=unitconvert xy_in=rad xy_out=deg
  step proj=axisswap order=2,1
  """)

  [
    "Web Mercator" => (Proj=(pfwdwmerc, pinvwmerc), Geodesy=(gfwdwmerc, ginvwmerc), Cartography=WebMercator),
    "UTM 32N" => (Proj=(pfwdutm, pinvutm), Geodesy=(gfwdutm, ginvutm), Cartography=UTMNorth{38}),
    "Mercator" => (Proj=(pfwdmerc, pinvmerc), Geodesy=missing, Cartography=Mercator),
    "Plate Carrée" => (Proj=(pfwdplate, pinvplate), Geodesy=missing, Cartography=PlateCarree),
    "Lambert" => (Proj=(pfwdlambert, pinvlambert), Geodesy=missing, Cartography=Lambert),
    "Winkel Tripel" => (Proj=(pfwdwinkel, pinvwinkel), Geodesy=missing, Cartography=WinkelTripel),
    "Robinson" => (Proj=(pfwdrobin, pinvrobin), Geodesy=missing, Cartography=Robinson),
    "Orthographic Spherical" =>
      (Proj=(pfwdorthosphere, pinvorthosphere), Geodesy=missing, Cartography=OrthoNorthSpherical),
    "Orthographic Elliptical" => (Proj=(pfwdorthoellip, pinvorthoellip), Geodesy=missing, Cartography=OrthoNorth)
  ]
end

# Orthographic North latitude bounds: [0,90]
# UTM Zone 38 longitude bounds: [42,48]
latlon = (rand(0:0.001:90), rand(42:0.001:48))
results = []

for (proj, args) in projargs
  pfwdtime, pinvtime = projtime(args.Proj..., latlon)

  gfwdtime, ginvtime = if ismissing(args.Geodesy)
    missing, missing
  else
    geodesytime(args.Geodesy..., latlon)
  end

  cfwdtime, cinvtime = cartographytime(args.Cartography, latlon)

  push!(
    results,
    (;
      :CRS => proj,
      :DIRECTION => "forward",
      Symbol("Proj.jl") => pfwdtime,
      Symbol("Geodesy.jl") => gfwdtime,
      Symbol("Cartography.jl") => cfwdtime
    )
  )

  push!(
    results,
    (;
      :CRS => proj,
      :DIRECTION => "inverse",
      Symbol("Proj.jl") => pinvtime,
      Symbol("Geodesy.jl") => ginvtime,
      Symbol("Cartography.jl") => cinvtime
    )
  )
end

results = identity.(results)
pretty_table(results)
