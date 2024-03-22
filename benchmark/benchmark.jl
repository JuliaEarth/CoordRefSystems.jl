using CoordRefSystems
import Geodesy
import Proj

using CSV
using Unitful
using DataFrames
using PrettyTables
using BenchmarkTools

function projtime(transf, invtransf, (lat, lon))
  fwdtime = @belapsed $transf($lat, $lon)
  coord = transf(lat, lon)
  invtime = @belapsed $invtransf($coord)
  fwdtime, invtime
end

function geodesytime(transf, (lat, lon))
  latlon = Geodesy.LLA(lat, lon, 0.0)
  fwdtime = @belapsed $transf($latlon)
  coord = transf(latlon)
  invtransf = inv(transf)
  invtime = @belapsed $invtransf($coord)
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

  gwmerc = Geodesy.WebMercatorfromLLA(Geodesy.wgs84)

  # --------
  # UTM 38N
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

  gutm = Geodesy.UTMfromLLA(38, true, Geodesy.wgs84)

  # --------------------
  # TRANSVERSE MERCATOR
  # --------------------

  pfwdtmerc = Proj.Transformation("""
  proj=pipeline
  step proj=axisswap order=2,1
  step proj=unitconvert xy_in=deg xy_out=rad
  step proj=tmerc lat_0=15 lon_0=45 k_0=0.9996 ellps=WGS84
  """)
  pinvtmerc = Proj.Transformation("""
  proj=pipeline
  step proj=tmerc inv lat_0=15 lon_0=45 k_0=0.9996 ellps=WGS84
  step proj=unitconvert xy_in=rad xy_out=deg
  step proj=axisswap order=2,1
  """)

  TransverseMercator = CoordRefSystems.TransverseMercator{0.9996,15.0u"°",45.0u"°"}

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

  pfwdorthosphere = Proj.Transformation("EPSG:4326", "ESRI:102035")
  pinvorthosphere = inv(pfwdorthosphere)

  OrthoNorthSpherical = CoordRefSystems.get(ESRI{102035})

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
    "Web Mercator" => (Proj=(pfwdwmerc, pinvwmerc), Geodesy=gwmerc, CoordRefSystems=WebMercator),
    "UTM 38N" => (Proj=(pfwdutm, pinvutm), Geodesy=gutm, CoordRefSystems=UTMNorth{38}),
    "Transverse Mercator" => (Proj=(pfwdtmerc, pinvtmerc), Geodesy=missing, CoordRefSystems=TransverseMercator),
    "Mercator" => (Proj=(pfwdmerc, pinvmerc), Geodesy=missing, CoordRefSystems=Mercator),
    "Plate Carrée" => (Proj=(pfwdplate, pinvplate), Geodesy=missing, CoordRefSystems=PlateCarree),
    "Lambert" => (Proj=(pfwdlambert, pinvlambert), Geodesy=missing, CoordRefSystems=Lambert),
    "Winkel Tripel" => (Proj=(pfwdwinkel, pinvwinkel), Geodesy=missing, CoordRefSystems=WinkelTripel),
    "Robinson" => (Proj=(pfwdrobin, pinvrobin), Geodesy=missing, CoordRefSystems=Robinson),
    "Orthographic Spherical" =>
      (Proj=(pfwdorthosphere, pinvorthosphere), Geodesy=missing, CoordRefSystems=OrthoNorthSpherical),
    "Orthographic Elliptical" => (Proj=(pfwdorthoellip, pinvorthoellip), Geodesy=missing, CoordRefSystems=OrthoNorth)
  ]
end

# Orthographic North latitude bounds: [0,90]
# Mercator latitude bounds: [-80,84]
# UTM Zone 38 longitude bounds: [42,48]
latlon = (rand(0:0.001:84), rand(42:0.001:48))
results = []

for (proj, args) in projargs
  pfwdtime, pinvtime = projtime(args.Proj..., latlon)

  gfwdtime, ginvtime = if ismissing(args.Geodesy)
    missing, missing
  else
    geodesytime(args.Geodesy, latlon)
  end

  cfwdtime, cinvtime = cartographytime(args.CoordRefSystems, latlon)

  push!(
    results,
    (;
      :CRS => proj,
      :DIRECTION => "forward",
      Symbol("Proj.jl") => pfwdtime,
      Symbol("Geodesy.jl") => gfwdtime,
      Symbol("CoordRefSystems.jl") => cfwdtime
    )
  )

  push!(
    results,
    (;
      :CRS => proj,
      :DIRECTION => "inverse",
      Symbol("Proj.jl") => pinvtime,
      Symbol("Geodesy.jl") => ginvtime,
      Symbol("CoordRefSystems.jl") => cinvtime
    )
  )
end

df = DataFrame(identity.(results))
sort!(df, :CRS)
df."Proj.jl / CoordRefSystems.jl" = round.(df."Proj.jl" ./ df."CoordRefSystems.jl", digits=2)

CSV.write(joinpath(@__DIR__, "output.csv"), df)
pretty_table(df)
