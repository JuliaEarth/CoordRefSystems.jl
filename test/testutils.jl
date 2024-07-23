allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:CRS} =
  all(ntuple(i -> isapprox(getfield(coords₁, i), getfield(coords₂, i); kwargs...), nfields(coords₁)))

function allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian2D}
  isapprox(c₁.x, c₂.x, kwargs...) && isapprox(c₁.y, c₂.y, kwargs...)
end

function allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian3D}
  isapprox(c₁.x, c₂.x, kwargs...) && isapprox(c₁.y, c₂.y, kwargs...) && isapprox(c₁.z, c₂.z, kwargs...)
end

allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:LatLon} =
  isapprox(coords₁.lat, coords₂.lat; kwargs...) && (
    isapprox(coords₁.lon, coords₂.lon; kwargs...) ||
    (isapproxlon180(coords₁.lon; kwargs...) && isapprox(coords₁.lon, -coords₂.lon; kwargs...))
  )

allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:CoordRefSystems.ShiftedCRS} =
  allapprox(CoordRefSystems._coords(coords₁), CoordRefSystems._coords(coords₂); kwargs...)

isapproxlon180(lon; kwargs...) = isapprox(abs(lon), 180u"°"; kwargs...)

function isapproxtest2D(CRS)
  c1 = convert(CRS, Cartesian{WGS84{1762}}(T(1), T(1)))

  τ = CoordRefSystems.atol(Float64) * u"m"
  c2 = convert(CRS, Cartesian{WGS84{1762}}(1u"m" + τ, 1u"m"))
  c3 = convert(CRS, Cartesian{WGS84{1762}}(1u"m", 1u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3

  τ = CoordRefSystems.atol(Float32) * u"m"
  c2 = convert(CRS, Cartesian{WGS84{1762}}(1u"m" + τ, 1u"m"))
  c3 = convert(CRS, Cartesian{WGS84{1762}}(1u"m", 1u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
end

isapproxtest3D(CRS) = isapproxtest3D(CRS{WGS84{1762}}, CRS{ITRF{2008}})

function isapproxtest3D(CRS1, CRS2)
  c1 = convert(CRS1, Cartesian{WGS84{1762}}(T(3.2e6), T(3.2e6), T(4.5e6)))

  τ = CoordRefSystems.atol(Float64) * u"m"
  c2 = convert(CRS1, Cartesian{WGS84{1762}}(3.2e6u"m" + τ, 3.2e6u"m", 4.5e6u"m"))
  c3 = convert(CRS1, Cartesian{WGS84{1762}}(3.2e6u"m", 3.2e6u"m" + τ, 4.5e6u"m"))
  c4 = convert(CRS1, Cartesian{WGS84{1762}}(3.2e6u"m", 3.2e6u"m", 4.5e6u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  τ = CoordRefSystems.atol(Float32) * u"m"
  c2 = convert(CRS1, Cartesian{WGS84{1762}}(3.2f6u"m" + τ, 3.2f6u"m", 4.5f6u"m"))
  c3 = convert(CRS1, Cartesian{WGS84{1762}}(3.2f6u"m", 3.2f6u"m" + τ, 4.5f6u"m"))
  c4 = convert(CRS1, Cartesian{WGS84{1762}}(3.2f6u"m", 3.2f6u"m", 4.5f6u"m" + τ))
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
  str = wktstring(code, format="WKT1_ESRI")
  @test CoordRefSystems.string2code(str) === code
  str = wktstring(code, format="WKT1_ESRI", multiline=true)
  @test CoordRefSystems.string2code(str) === code
end
