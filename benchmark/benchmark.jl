using Cartography
import MapMaths as MM
import Geodesy as GD
import Proj

using BenchmarkTools

# ---------------------
# BENCHMARK 1 
# PROJECTION: WEB MERCATOR
# DATUM: WGS84
# COORDINATE: 30° LAT, 60° LON
# ---------------------

println("Proj: Web Mercator forward")
trans = Proj.Transformation("EPSG:4326", "EPSG:3857")
display(@benchmark trans(30, 60))
println("\nProj: Web Mercator inverse")
invtrans = inv(trans)
coord = trans(30, 60)
display(@benchmark invtrans($coord))

println("\nGeodesy: Web Mercator forward")
trans = GD.WebMercatorfromLLA(GD.wgs84)
latlon = GD.LLA(30, 60, 0)
display(@benchmark trans($latlon))
println("\nGeodesy: Web Mercator inverse")
invtrans = GD.LLAfromWebMercator(GD.wgs84)
coord = trans(latlon)
display(@benchmark invtrans($coord))

println("\nMapMaths: Web Mercator forward")
latlon = MM.LatLon(30, 60)
display(@benchmark MM.WebMercator($latlon))
println("\nMapMaths: Web Mercator inverse")
coord = MM.WebMercator(latlon)
display(@benchmark MM.LatLon($coord))

println("\nCartography: Web Mercator forward")
latlon = LatLon(30, 60)
display(@benchmark convert(WebMercator, $latlon))
println("\nCartography: Web Mercator inverse")
coord = convert(WebMercator, latlon)
display(@benchmark convert(LatLon, $coord))
