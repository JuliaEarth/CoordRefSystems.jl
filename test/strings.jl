@testset "CRS strings" begin
  crsstringtest(EPSG{3395})
  crsstringtest(EPSG{3857})
  crsstringtest(EPSG{4326})
  crsstringtest(EPSG{32662})
  crsstringtest(EPSG{32633})
  crsstringtest(ESRI{54017})
  crsstringtest(ESRI{54030})
  crsstringtest(ESRI{54034})
  crsstringtest(ESRI{54042})
  crsstringtest(ESRI{102035})
  crsstringtest(ESRI{102037})

  # parsing errors
  # CRS format not supported
  str = "PROJ(NAME=Mercator, DATUM=WGS84)"
  @test_throws ArgumentError CoordRefSystems.string2code(str)
  # invalid WKT string
  str = """
  GEOG["GCS_WGS_1984",
    DATUM["D_WGS_1984",
        SPHEROID["WGS_1984",6378137.0,298.257223563]],
    PRIMEM["Greenwich",0.0],
    UNIT["Degree",0.0174532925199433]]"""
  @test_throws ArgumentError CoordRefSystems.string2code(str)
  # CRS ID not found in the WKT2 string
  str = "PROJCRS[]"
  @test_throws ArgumentError CoordRefSystems.string2code(str)
  # ESRI ID of the CRS not found in the ESRI WKT string
  str = "PROJCS[]"
  @test_throws ArgumentError CoordRefSystems.string2code(str)
end
