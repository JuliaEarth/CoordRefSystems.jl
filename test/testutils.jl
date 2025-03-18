allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:CRS} =
  all(ntuple(i -> isapprox(getfield(coords₁, i), getfield(coords₂, i); kwargs...), nfields(coords₁)))

function allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian2D}
  isapprox(coords₁.x, coords₂.x, kwargs...) && isapprox(coords₁.y, coords₂.y, kwargs...)
end

function allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian3D}
  isapprox(coords₁.x, coords₂.x, kwargs...) &&
    isapprox(coords₁.y, coords₂.y, kwargs...) &&
    isapprox(coords₁.z, coords₂.z, kwargs...)
end

allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:LatLon} =
  isapprox(coords₁.lat, coords₂.lat; kwargs...) && (
    isapprox(coords₁.lon, coords₂.lon; kwargs...) ||
    (isapproxlon180(coords₁.lon; kwargs...) && isapprox(coords₁.lon, -coords₂.lon; kwargs...))
  )

isapproxlon180(lon; kwargs...) = isapprox(abs(lon), 180°; kwargs...)

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

function wktstring(code; format="WKT2", multiline=false)
  spref = ArchGDAL.importUserInput(codestring(code))
  options = ["FORMAT=$format", "MULTILINE=$(multiline ? "YES" : "NO")"]
  wktptr = Ref{Cstring}()
  GDAL.osrexporttowktex(spref, wktptr, options)
  unsafe_string(wktptr[])
end

codestring(::Type{EPSG{Code}}) where {Code} = "EPSG:$Code"
codestring(::Type{ESRI{Code}}) where {Code} = "ESRI:$Code"

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
