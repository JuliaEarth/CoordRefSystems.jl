@testset "strings" begin
  # EPSG codes
  crsstringtest(EPSG{2157})
  crsstringtest(EPSG{2193})
  crsstringtest(EPSG{3035})
  crsstringtest(EPSG{3310})
  crsstringtest(EPSG{3395})
  crsstringtest(EPSG{3857})
  crsstringtest(EPSG{4171})
  crsstringtest(EPSG{4207})
  crsstringtest(EPSG{4230})
  crsstringtest(EPSG{4231})
  crsstringtest(EPSG{4267})
  crsstringtest(EPSG{4269})
  crsstringtest(EPSG{4274})
  crsstringtest(EPSG{4275})
  crsstringtest(EPSG{4277})
  crsstringtest(EPSG{4314})
  crsstringtest(EPSG{4326})
  crsstringtest(EPSG{4618})
  crsstringtest(EPSG{4659})
  crsstringtest(EPSG{4668})
  crsstringtest(EPSG{4674})
  crsstringtest(EPSG{4666})
  crsstringtest(EPSG{4745})
  crsstringtest(EPSG{4746})
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
  # crsstringtest(EPSG{9777})
  # crsstringtest(EPSG{9782})
  # crsstringtest(EPSG{10414})
  crsstringtest1(EPSG{32662})
  crsstringtest(EPSG{5396})
  crsstringtest(EPSG{6210})
  crsstringtest(EPSG{6211})
  crsstringtest(EPSG{31965})
  crsstringtest(EPSG{31966})
  crsstringtest(EPSG{31967})
  crsstringtest(EPSG{31968})
  crsstringtest(EPSG{31969})
  crsstringtest(EPSG{31970})
  crsstringtest(EPSG{31971})
  crsstringtest(EPSG{31972})
  crsstringtest(EPSG{31973})
  crsstringtest(EPSG{31974})
  crsstringtest(EPSG{31975})
  crsstringtest(EPSG{31976})
  crsstringtest(EPSG{31977})
  crsstringtest(EPSG{31978})
  crsstringtest(EPSG{31979})
  crsstringtest(EPSG{31980})
  crsstringtest(EPSG{31981})
  crsstringtest(EPSG{31982})
  crsstringtest(EPSG{31983})
  crsstringtest(EPSG{31984})
  crsstringtest(EPSG{31985})
  crsstringtest(EPSG{32601})
  crsstringtest(EPSG{32602})
  crsstringtest(EPSG{32603})
  crsstringtest(EPSG{32604})
  crsstringtest(EPSG{32605})
  crsstringtest(EPSG{32606})
  crsstringtest(EPSG{32607})
  crsstringtest(EPSG{32608})
  crsstringtest(EPSG{32609})
  crsstringtest(EPSG{32610})
  crsstringtest(EPSG{32611})
  crsstringtest(EPSG{32612})
  crsstringtest(EPSG{32613})
  crsstringtest(EPSG{32614})
  crsstringtest(EPSG{32615})
  crsstringtest(EPSG{32616})
  crsstringtest(EPSG{32617})
  crsstringtest(EPSG{32618})
  crsstringtest(EPSG{32619})
  crsstringtest(EPSG{32620})
  crsstringtest(EPSG{32621})
  crsstringtest(EPSG{32622})
  crsstringtest(EPSG{32623})
  crsstringtest(EPSG{32624})
  crsstringtest(EPSG{32625})
  crsstringtest(EPSG{32626})
  crsstringtest(EPSG{32627})
  crsstringtest(EPSG{32628})
  crsstringtest(EPSG{32629})
  crsstringtest(EPSG{32630})
  crsstringtest(EPSG{32631})
  crsstringtest(EPSG{32632})
  crsstringtest(EPSG{32633})
  crsstringtest(EPSG{32634})
  crsstringtest(EPSG{32635})
  crsstringtest(EPSG{32636})
  crsstringtest(EPSG{32637})
  crsstringtest(EPSG{32638})
  crsstringtest(EPSG{32639})
  crsstringtest(EPSG{32640})
  crsstringtest(EPSG{32641})
  crsstringtest(EPSG{32642})
  crsstringtest(EPSG{32643})
  crsstringtest(EPSG{32644})
  crsstringtest(EPSG{32645})
  crsstringtest(EPSG{32646})
  crsstringtest(EPSG{32647})
  crsstringtest(EPSG{32648})
  crsstringtest(EPSG{32649})
  crsstringtest(EPSG{32650})
  crsstringtest(EPSG{32651})
  crsstringtest(EPSG{32652})
  crsstringtest(EPSG{32653})
  crsstringtest(EPSG{32654})
  crsstringtest(EPSG{32655})
  crsstringtest(EPSG{32656})
  crsstringtest(EPSG{32657})
  crsstringtest(EPSG{32658})
  crsstringtest(EPSG{32659})
  crsstringtest(EPSG{32660})
  crsstringtest(EPSG{32701})
  crsstringtest(EPSG{32702})
  crsstringtest(EPSG{32703})
  crsstringtest(EPSG{32704})
  crsstringtest(EPSG{32705})
  crsstringtest(EPSG{32706})
  crsstringtest(EPSG{32707})
  crsstringtest(EPSG{32708})
  crsstringtest(EPSG{32709})
  crsstringtest(EPSG{32710})
  crsstringtest(EPSG{32711})
  crsstringtest(EPSG{32712})
  crsstringtest(EPSG{32713})
  crsstringtest(EPSG{32714})
  crsstringtest(EPSG{32715})
  crsstringtest(EPSG{32716})
  crsstringtest(EPSG{32717})
  crsstringtest(EPSG{32718})
  crsstringtest(EPSG{32719})
  crsstringtest(EPSG{32720})
  crsstringtest(EPSG{32721})
  crsstringtest(EPSG{32722})
  crsstringtest(EPSG{32723})
  crsstringtest(EPSG{32724})
  crsstringtest(EPSG{32725})
  crsstringtest(EPSG{32726})
  crsstringtest(EPSG{32727})
  crsstringtest(EPSG{32728})
  crsstringtest(EPSG{32729})
  crsstringtest(EPSG{32730})
  crsstringtest(EPSG{32731})
  crsstringtest(EPSG{32732})
  crsstringtest(EPSG{32733})
  crsstringtest(EPSG{32734})
  crsstringtest(EPSG{32735})
  crsstringtest(EPSG{32736})
  crsstringtest(EPSG{32737})
  crsstringtest(EPSG{32738})
  crsstringtest(EPSG{32739})
  crsstringtest(EPSG{32740})
  crsstringtest(EPSG{32741})
  crsstringtest(EPSG{32742})
  crsstringtest(EPSG{32743})
  crsstringtest(EPSG{32744})
  crsstringtest(EPSG{32745})
  crsstringtest(EPSG{32746})
  crsstringtest(EPSG{32747})
  crsstringtest(EPSG{32748})
  crsstringtest(EPSG{32749})
  crsstringtest(EPSG{32750})
  crsstringtest(EPSG{32751})
  crsstringtest(EPSG{32752})
  crsstringtest(EPSG{32753})
  crsstringtest(EPSG{32754})
  crsstringtest(EPSG{32755})
  crsstringtest(EPSG{32756})
  crsstringtest(EPSG{32757})
  crsstringtest(EPSG{32758})
  crsstringtest(EPSG{32759})
  crsstringtest(EPSG{32760})
  crsstringtest(EPSG{25832})
  crsstringtest(EPSG{27700})
  crsstringtest(EPSG{29903})

  # ESRI codes
  crsstringtest(ESRI{54017})
  crsstringtest(ESRI{54030})
  crsstringtest(ESRI{54034})
  crsstringtest(ESRI{54042})
  crsstringtest(ESRI{102035})
  crsstringtest(ESRI{102037})

  # throws when WKT is not supported by EPSG database
  @test_throws ArgumentError CoordRefSystems.wkt2(EPSG{5614})
  @test_throws ArgumentError CoordRefSystems.wkt2(EPSG{6358})
  @test_throws ArgumentError CoordRefSystems.wkt2(EPSG{8051})
  @test_throws ArgumentError CoordRefSystems.wkt2(EPSG{8053})

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
