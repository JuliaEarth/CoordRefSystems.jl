# ------------------
# BASIC UTILITITIES
# ------------------

function wktstring(code; format="WKT2", multiline=false)
  spref = ArchGDAL.importUserInput(codestring(code))
  options = ["FORMAT=$format", "MULTILINE=$(multiline ? "YES" : "NO")"]
  wktptr = Ref{Cstring}()
  GDAL.osrexporttowktex(spref, wktptr, options)
  unsafe_string(wktptr[])
end

codestring(::Type{EPSG{Code}}) where {Code} = "EPSG:$Code"
codestring(::Type{ESRI{Code}}) where {Code} = "ESRI:$Code"

# ---------------
# TEST FUNCTIONS
# ---------------

function randtest(CRS)
  rng = StableRNG(2025)
  @test rand(CRS) isa CRS
  @test rand(rng, CRS) isa CRS
  @test eltype(rand(CRS, 10)) <: CRS
  @test eltype(rand(rng, CRS, 10)) <: CRS
  @inferred rand(CRS)
  @inferred rand(rng, CRS)
  @inferred rand(CRS, 10)
  @inferred rand(rng, CRS, 10)
end

function crsstringtest(code)
  crsstringtest1(code)
  crsstringtest2(code)
end

function crsstringtest1(code)
  str = wktstring(code)
  @test CoordRefSystems.string2code(str) === code
  str = wktstring(code, multiline=true)
  @test CoordRefSystems.string2code(str) === code
  str = wktstring(code, format="WKT1")
  @test CoordRefSystems.string2code(str) === code
  str = wktstring(code, format="WKT1", multiline=true)
  @test CoordRefSystems.string2code(str) === code
  str = wktstring(code, format="WKT1_ESRI")
  @test CoordRefSystems.string2code(str) === code
  str = wktstring(code, format="WKT1_ESRI", multiline=true)
  @test CoordRefSystems.string2code(str) === code
end

function crsstringtest2(code::Type{<:EPSG})
  gdal = wktstring(code)
  epsg = CoordRefSystems.wkt2(code)
  @test CoordRefSystems.string2code(gdal) == CoordRefSystems.string2code(epsg)
end

function crsstringtest2(code::Type{<:ESRI})
  @test_throws ArgumentError CoordRefSystems.wkt2(code)
end

function gettest(code, CRS)
  @test CoordRefSystems.get(code) === CRS
  # inverse operation
  @test CoordRefSystems.code(CRS) === code
  # with instance type
  n = CoordRefSystems.ncoords(CRS)
  c = CRS(ntuple(_ -> T(0), n)...)
  @test CoordRefSystems.code(typeof(c)) === code
end
