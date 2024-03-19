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

function cartographytime(CRS, Datum, (lat, lon))
  latlon = LatLon{Datum}(lat, lon)
  fwdtime = @belapsed convert(CRS, $latlon)
  coord = convert(CRS, latlon)
  invtime = @belapsed convert(LatLon, $coord)
  fwdtime, invtime
end

coords = (56, 12)
results = []
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
  step proj=utm zone=32 ellps=WGS84
  """)
  pinvutm = Proj.Transformation("""
  proj=pipeline
  step inv proj=utm zone=32 ellps=WGS84
  step proj=unitconvert xy_in=rad xy_out=deg
  step proj=axisswap order=2,1
  """)

  gfwdutm = Geodesy.UTMfromLLA(32, true, Geodesy.wgs84)
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

  [
    "Web Mercator" =>
      (Proj=(pfwdwmerc, pinvwmerc), Geodesy=(gfwdwmerc, ginvwmerc), Cartography=(WebMercator, WGS84Latest)),
    "UTM 32N" => (Proj=(pfwdutm, pinvutm), Geodesy=(gfwdutm, ginvutm), Cartography=(UTMNorth{32}, WGS84Latest)),
    "Mercator" => (Proj=(pfwdmerc, pinvmerc), Geodesy=nothing, Cartography=(Mercator, WGS84Latest)),
    "Plate Carrée" => (Proj=(pfwdplate, pinvplate), Geodesy=nothing, Cartography=(PlateCarree, WGS84Latest)),
    "Lambert" => (Proj=(pfwdlambert, pinvlambert), Geodesy=nothing, Cartography=(Lambert, WGS84Latest)),
    "Winkel Tripel" => (Proj=(pfwdwinkel, pinvwinkel), Geodesy=nothing, Cartography=(WinkelTripel, WGS84Latest)),
    "Robinson" => (Proj=(pfwdrobin, pinvrobin), Geodesy=nothing, Cartography=(Robinson, WGS84Latest))
  ]
end

for (proj, args) in projargs
  pfwdtime, pinvtime = projtime(args.Proj..., coords)

  gfwdtime, ginvtime = if isnothing(args.Geodesy)
    missing, missing
  else
    geodesytime(args.Geodesy..., coords)
  end

  cfwdtime, cinvtime = cartographytime(args.Cartography..., coords)

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
