# ------------------
# BASIC UTILITITIES
# ------------------

isclose(coords₁::C, coords₂::C; kwargs...) where {C<:CRS} =
  all(ntuple(i -> isapprox(getfield(coords₁, i), getfield(coords₂, i); kwargs...), nfields(coords₁)))

function isclose(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian2D}
  isapprox(coords₁.x, coords₂.x, kwargs...) && isapprox(coords₁.y, coords₂.y, kwargs...)
end

function isclose(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian3D}
  isapprox(coords₁.x, coords₂.x, kwargs...) &&
    isapprox(coords₁.y, coords₂.y, kwargs...) &&
    isapprox(coords₁.z, coords₂.z, kwargs...)
end

isclose(coords₁::C, coords₂::C; kwargs...) where {C<:LatLon} =
  isapprox(coords₁.lat, coords₂.lat; kwargs...) && (
    isapprox(coords₁.lon, coords₂.lon; kwargs...) ||
    (isapprox(abs(coords₁.lon), 180°; kwargs...) && isapprox(coords₁.lon, -coords₂.lon; kwargs...))
  )

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

isequaltest(CRS) = isequaltest(CRS, CoordRefSystems.ncoords(CRS))

function isequaltest(CRS, n)
  c1 = CRS(ntuple(_ -> T(1), n)...)
  c2 = CRS(ntuple(_ -> 1.0, n)...)
  c3 = CRS(ntuple(_ -> 1.0f0, n)...)
  @test c1 == c2
  @test c1 == c3
end

function isapproxtest2D(CRS)
  x = T(1) * m
  y = T(2) * m
  τ = CoordRefSystems.atol(T) * m
  c1 = convert(CRS, Cartesian(x, y))
  c2 = convert(CRS, Cartesian(x + τ, y))
  c3 = convert(CRS, Cartesian(x, y + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
end

function isapproxtest3D(CRS; datum=WGS84{1762})
  rng = StableRNG(2025)
  r = CRS <: Cartesian ? rand(rng, Cartesian{datum,3}) : rand(rng, CRS{datum})
  c = CRS <: CoordRefSystems.Projected ? convert(Cartesian3D, r) : convert(Cartesian, r)
  x = T(ustrip(m, c.x)) * m
  y = T(ustrip(m, c.y)) * m
  z = T(ustrip(m, c.z)) * m
  τ = CoordRefSystems.atol(T) * m
  c1 = convert(CRS, Cartesian{datum}(x, y, z))
  c2 = convert(CRS, Cartesian{datum}(x + τ, y, z))
  c3 = convert(CRS, Cartesian{datum}(x, y + τ, z))
  c4 = convert(CRS, Cartesian{datum}(x, y, z + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4
end

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
