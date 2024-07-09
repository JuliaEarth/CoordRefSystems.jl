function isapproxtest2D(CRS)
  c1 = convert(CRS, Cartesian{WGS84Latest}(T(1), T(1)))

  τ = CoordRefSystems.atol(Float64) * u"m"
  c2 = convert(CRS, Cartesian{WGS84Latest}(1u"m" + τ, 1u"m"))
  c3 = convert(CRS, Cartesian{WGS84Latest}(1u"m", 1u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3

  τ = CoordRefSystems.atol(Float32) * u"m"
  c2 = convert(CRS, Cartesian{WGS84Latest}(1u"m" + τ, 1u"m"))
  c3 = convert(CRS, Cartesian{WGS84Latest}(1u"m", 1u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
end

isapproxtest3D(CRS) = isapproxtest3D(CRS{WGS84Latest}, CRS{ITRF{2008}})

function isapproxtest3D(CRS1, CRS2)
  c1 = convert(CRS1, Cartesian{WGS84Latest}(T(3.2e6), T(3.2e6), T(4.5e6)))

  τ = CoordRefSystems.atol(Float64) * u"m"
  c2 = convert(CRS1, Cartesian{WGS84Latest}(3.2e6u"m" + τ, 3.2e6u"m", 4.5e6u"m"))
  c3 = convert(CRS1, Cartesian{WGS84Latest}(3.2e6u"m", 3.2e6u"m" + τ, 4.5e6u"m"))
  c4 = convert(CRS1, Cartesian{WGS84Latest}(3.2e6u"m", 3.2e6u"m", 4.5e6u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  τ = CoordRefSystems.atol(Float32) * u"m"
  c2 = convert(CRS1, Cartesian{WGS84Latest}(3.2f6u"m" + τ, 3.2f6u"m", 4.5f6u"m"))
  c3 = convert(CRS1, Cartesian{WGS84Latest}(3.2f6u"m", 3.2f6u"m" + τ, 4.5f6u"m"))
  c4 = convert(CRS1, Cartesian{WGS84Latest}(3.2f6u"m", 3.2f6u"m", 4.5f6u"m" + τ))
  @test c1 ≈ c2
  @test c1 ≈ c3
  @test c1 ≈ c4

  c1 = convert(CRS2, Cartesian{ITRF{2008}}(T(3.2e6), T(3.2e6), T(4.5e6)))
  c2 = convert(CRS1, Cartesian{WGS84Latest}(T(3.2e6), T(3.2e6), T(4.5e6)))
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
