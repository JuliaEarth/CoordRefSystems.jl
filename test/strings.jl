@testset "CRS strings" begin
  crsstringtest(EPSG{2157})
  crsstringtest(EPSG{3310})
  crsstringtest(EPSG{3395})
  crsstringtest(EPSG{3857})
  crsstringtest(EPSG{4207})
  crsstringtest(EPSG{4230})
  crsstringtest(EPSG{4231})
  crsstringtest(EPSG{4267})
  crsstringtest(EPSG{4269})
  crsstringtest(EPSG{4274})
  crsstringtest(EPSG{4277})
  crsstringtest(EPSG{4326})
  crsstringtest(EPSG{4618})
  crsstringtest(EPSG{4659})
  crsstringtest(EPSG{4668})
  crsstringtest(EPSG{4674})
  crsstringtest(EPSG{4666})
  crsstringtest(EPSG{4686})
  crsstringtest(EPSG{5324})
  crsstringtest(EPSG{5527})
  # TODO: check the generated strings for these codes
  # the datum of the ESRI WKT1 string does not have the "D_" suffix
  # crsstringtest(EPSG{8086})
  # crsstringtest(EPSG{8232})
  # crsstringtest(EPSG{8237})
  # crsstringtest(EPSG{8240})
  # crsstringtest(EPSG{8246})
  # crsstringtest(EPSG{8249})
  # crsstringtest(EPSG{8252})
  # crsstringtest(EPSG{8255})
  # crsstringtest(EPSG{10414})
  crsstringtest(EPSG{32662})
  crsstringtest(EPSG{32633})
  crsstringtest(EPSG{25832})
  crsstringtest(EPSG{27700})
  crsstringtest(EPSG{29903})
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
  # datum not found in the WKT1 string
  str = """
  GEOGCS["GCS_WGS_1984",
    PRIMEM["Greenwich",0.0],
    UNIT["Degree",0.0174532925199433]]
  """
  @test_throws ArgumentError CoordRefSystems.string2code(str)
  # ESRI ID of the CRS not found in the ESRI WKT string
  str = """
  GEOGCS[
    DATUM["D_WGS_1984",
        SPHEROID["WGS_1984",6378137.0,298.257223563]],
    PRIMEM["Greenwich",0.0],
    UNIT["Degree",0.0174532925199433]]
  """
  @test_throws ArgumentError CoordRefSystems.string2code(str)
  # CRS for the ESRI ID "test" not found in dictionary
  str = """
  GEOGCS["test",
    DATUM["D_WGS_1984",
        SPHEROID["WGS_1984",6378137.0,298.257223563]],
    PRIMEM["Greenwich",0.0],
    UNIT["Degree",0.0174532925199433]]
  """
  @test_throws ArgumentError CoordRefSystems.string2code(str)
  # CRS AUTHORITY not found in the WKT1 string
  str = """
  GEOGCS["WGS 84",
    DATUM["WGS_1984",
        SPHEROID["WGS 84",6378137,298.257223563,
            AUTHORITY["EPSG","7030"]],
        AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0,
        AUTHORITY["EPSG","8901"]],
    UNIT["degree",0.0174532925199433,
        AUTHORITY["EPSG","9122"]],
    AXIS["Latitude",NORTH],
    AXIS["Longitude",EAST]]
  """
  @test_throws ArgumentError CoordRefSystems.string2code(str)
end
