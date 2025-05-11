# ----------------
# BASIC UTILITIES
# ----------------

sqrttol(x, xo) = sqrttol(abs(x - xo) / xo) * xo
function sqrttol(e)
  T = typeof(e) 
  if e >= eps(T)^(1//4)
    return eps(T)^(1//2)
  elseif e >= eps(T)^(1//2)
    return eps(T)^(3//4) / e
  else
    return eps(T)^(1//4)
  end
end

relativeerror(x, xo) = norm(x - xo) / norm(xo)

svec(coords::Cartesian) = SVector(getfield(coords, :coords))
svec(coords::Projected) = SVector(coords.x, coords.y)

function wktstring(code; format="WKT2", multiline=false)
  spref = ArchGDAL.importUserInput(codestring(code))
  options = ["FORMAT=$format", "MULTILINE=$(multiline ? "YES" : "NO")"]
  wktptr = Ref{Cstring}()
  GDAL.osrexporttowktex(spref, wktptr, options)
  unsafe_string(wktptr[])
end

codestring(::Type{EPSG{Code}}) where {Code} = "EPSG:$Code"
codestring(::Type{ESRI{Code}}) where {Code} = "ESRI:$Code"

# -----------------
# ISAPPROX FOR CRS
# -----------------

# basic CRS
isapproxcoords(coords₁::Cartesian{Datum}, coords₂::Cartesian{Datum}) where {Datum} = svec(coords₁) ≈ svec(coords₂)
isapproxcoords(coords₁::Polar{Datum}, coords₂::Polar{Datum}) where {Datum} = coords₁.ρ ≈ coords₂.ρ && isapproxangle(coords₁.ϕ, coords₂.ϕ)
isapproxcoords(coords₁::Cylindrical{Datum}, coords₂::Cylindrical{Datum}) where {Datum} = SVector(coords₁.ρ, coords₁.z) ≈ SVector(coords₁.ρ, coords₂.z) && isapproxangle(coords₁.ϕ, coords₂.ϕ)
isapproxcoords(coords₁::Spherical{Datum}, coords₂::Spherical{Datum}) where {Datum} = coords₁.r ≈ coords₂.r && isapproxangle(coords₁.θ, coords₂.θ) && isapproxangle(coords₁.ϕ, coords₂.ϕ)

# geographic CRS
const LatLonType = Union{AuthalicLatLon, GeocentricLatLon, GeodeticLatLon}
const LatLonAltType = Union{GeocentricLatLonAlt, GeodeticLatLonAlt}
function isapproxcoords(coords₁::LL, coords₂::LL) where {LL <: LatLonType}
  T = promote_type(Unitful.numtype.((coords₁.lon, coords₂.lon))...)
  return (
    isapprox(coords₁.lat, coords₂.lat; atol = sqrt(eps(T(90)))°)
    && isapproxangle(coords₁.lon, coords₂.lon)
  )
end
function isapproxcoords(coords₁::LLA, coords₂::LLA) where {LLA <: LatLonAltType}
  T = promote_type(Unitful.numtype.((coords₁.lon, coords₂.lon))...)
  a = T(majoraxis(ellipsoid(datum(coords₁))))
  return (
    isapprox(coords₁.lat, coords₂.lat; atol = sqrt(eps(T(90))) * °)
    && isapproxangle(coords₁.lon, coords₂.lon)
    && isapprox(a + coords₁.alt, a + coords₂.alt)
  )
end

# projected CRS
function isapproxcoords(coords₁::C, coords₂::C) where {C <: Projected}
  T = promote_type(Unitful.numtype.((coords₁.x, coords₂.x))...)
  return isapprox(
    svec(coords₁),
    svec(coords₂);
    rtol = sqrt(eps(T)),
    atol = sqrt(eps(T(ustrip(m, majoraxis(ellipsoid(datum(C))))))) * m,
  )
end

isapproxangle(
  α, β;
  atol = sqrt(eps(2 * first(promote(π, ustrip(α), ustrip(β))))),
) = abs(rem2pi(ustrip(rad, α - β), RoundNearest)) <= ustrip(rad, atol)

# ---------------
# TEST UTILITIES
# ---------------

function isapproxtest2D(CRS; datum=WGS84{1762})
  c1 = convert(CRS, Cartesian{datum}(T(1), T(2)))

  τ = CoordRefSystems.atol(Float64) * m
  c2 = convert(CRS, Cartesian{datum}(1m + τ, 2m))
  c3 = convert(CRS, Cartesian{datum}(1m, 2m + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3

  τ = CoordRefSystems.atol(Float32) * m
  c2 = convert(CRS, Cartesian{datum}(1m + τ, 2m))
  c3 = convert(CRS, Cartesian{datum}(1m, 2m + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
end

function isapproxtest3D(CRS; datum1=WGS84{1762}, datum2=ITRF{2008})
  c = CRS <: Cartesian ? rand(Cartesian{datum1,3}) : rand(CRS{datum1})
  cart = CRS <: CoordRefSystems.Projected ? convert(Cartesian3D, c) : convert(Cartesian, c)
  u = CoordRefSystems.lentype(cart) |> unit

  # basic tests
  @test c ≈ cart
  @test cart ≈ c

  # translated coordinates
  c1 = convert(CRS, Cartesian{datum1}(cart.x, cart.y, cart.z))

  τ = CoordRefSystems.atol(Float64) * u
  x = Float64(ustrip(cart.x)) * u
  y = Float64(ustrip(cart.y)) * u
  z = Float64(ustrip(cart.z)) * u
  c2 = convert(CRS, Cartesian{datum1}(x + τ, y, z))
  c3 = convert(CRS, Cartesian{datum1}(x, y + τ, z))
  c4 = convert(CRS, Cartesian{datum1}(x, y, z + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  τ = CoordRefSystems.atol(Float32) * u
  x = Float32(ustrip(cart.x)) * u
  y = Float32(ustrip(cart.y)) * u
  z = Float32(ustrip(cart.z)) * u
  c2 = convert(CRS, Cartesian{datum1}(x + τ, y, z))
  c3 = convert(CRS, Cartesian{datum1}(x, y + τ, z))
  c4 = convert(CRS, Cartesian{datum1}(x, y, z + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  # different datums
  c2 = convert(CRS, Cartesian{datum2}(cart.x, cart.y, cart.z))
  @test c1 ≈ c2
end

equaltest(CRS) = equaltest(CRS, CoordRefSystems.ncoords(CRS))

function equaltest(CRS, n)
  c1 = CRS(ntuple(_ -> T(1), n)...)
  c2 = CRS(ntuple(_ -> 1.0, n)...)
  c3 = CRS(ntuple(_ -> 1.0f0, n)...)
  @test c1 == c2
  @test c1 == c3
end

function randtest(CRS)
  rng = StableRNG(123)

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
