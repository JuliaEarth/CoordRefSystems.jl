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

allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:CoordRefSystems.ShiftedCRS} =
  allapprox(CoordRefSystems._coords(coords₁), CoordRefSystems._coords(coords₂); kwargs...)

isapproxlon180(lon; kwargs...) = isapprox(abs(lon), 180°; kwargs...)

function isapproxtest2D(CRS)
  c1 = convert(CRS, Cartesian{WGS84{1762}}(T(1), T(1)))

  τ = CoordRefSystems.atol(Float64) * m
  c2 = convert(CRS, Cartesian{WGS84{1762}}(1m + τ, 1m))
  c3 = convert(CRS, Cartesian{WGS84{1762}}(1m, 1m + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3

  τ = CoordRefSystems.atol(Float32) * m
  c2 = convert(CRS, Cartesian{WGS84{1762}}(1m + τ, 1m))
  c3 = convert(CRS, Cartesian{WGS84{1762}}(1m, 1m + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
end

isapproxtest3D(CRS) = isapproxtest3D(CRS{WGS84{1762}}, CRS{ITRF{2008}})

function isapproxtest3D(CRS1, CRS2)
  c1 = convert(CRS1, Cartesian{WGS84{1762}}(T(3.2e6), T(3.2e6), T(4.5e6)))

  τ = CoordRefSystems.atol(Float64) * m
  c2 = convert(CRS1, Cartesian{WGS84{1762}}(3.2e6m + τ, 3.2e6m, 4.5e6m))
  c3 = convert(CRS1, Cartesian{WGS84{1762}}(3.2e6m, 3.2e6m + τ, 4.5e6m))
  c4 = convert(CRS1, Cartesian{WGS84{1762}}(3.2e6m, 3.2e6m, 4.5e6m + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  τ = CoordRefSystems.atol(Float32) * m
  c2 = convert(CRS1, Cartesian{WGS84{1762}}(3.2f6m + τ, 3.2f6m, 4.5f6m))
  c3 = convert(CRS1, Cartesian{WGS84{1762}}(3.2f6m, 3.2f6m + τ, 4.5f6m))
  c4 = convert(CRS1, Cartesian{WGS84{1762}}(3.2f6m, 3.2f6m, 4.5f6m + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  c1 = convert(CRS2, Cartesian{ITRF{2008}}(T(3.2e6), T(3.2e6), T(4.5e6)))
  c2 = convert(CRS1, Cartesian{WGS84{1762}}(T(3.2e6), T(3.2e6), T(4.5e6)))
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
