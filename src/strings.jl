# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# if you coming from an error message,
# please add an entry to the following
# dictionary in **alphabetical order**
const esriid2code = Dict(
  "British_National_Grid" => EPSG{27700},
  "ETRF2000-PL_CS92" => EPSG{2180},
  "ETRS_1989_LAEA" => EPSG{3035},
  "ETRS_1989_UTM_Zone_32N" => EPSG{25832},
  "GCS_Datum_73" => EPSG{4274},
  "GCS_Deutsches_Hauptdreiecksnetz" => EPSG{4314},
  "GCS_European_1950" => EPSG{4230},
  "GCS_European_1979" => EPSG{4668},
  "GCS_European_1987" => EPSG{4231},
  "GCS_ISN_1993" => EPSG{4659},
  "GCS_ISN_2004" => EPSG{5324},
  "GCS_ISN_2016" => EPSG{8086},
  "GCS_Lisbon_1890" => EPSG{4666},
  "GCS_Lisbon" => EPSG{4207},
  "GCS_MAGNA" => EPSG{4686},
  "GCS_NAD83_CSRS_v2" => EPSG{8237},
  "GCS_NAD83_CSRS_v3" => EPSG{8240},
  "GCS_NAD83_CSRS_v4" => EPSG{8246},
  "GCS_NAD83_CSRS_v5" => EPSG{8249},
  "GCS_NAD83_CSRS_v6" => EPSG{8252},
  "GCS_NAD83_CSRS_v7" => EPSG{8255},
  "GCS_NAD83_CSRS_v8" => EPSG{10414},
  "GCS_NAD83_CSRS96" => EPSG{8232},
  "GCS_North_American_1927" => EPSG{4267},
  "GCS_North_American_1983" => EPSG{4269},
  "GCS_NTF" => EPSG{4275},
  "GCS_OSGB_1936" => EPSG{4277},
  "GCS_PD/83" => EPSG{4746},
  "GCS_RD/83" => EPSG{4745},
  "GCS_RGF_1993" => EPSG{4171},
  "GCS_SAD_1969_96" => EPSG{5527},
  "GCS_SIRGAS_2000" => EPSG{4674},
  "GCS_South_American_1969" => EPSG{4618},
  "GCS_WGS_1984" => EPSG{4326},
  "IRENET95_Irish_Transverse_Mercator" => EPSG{2157},
  "NAD_1983_California_Teale_Albers" => EPSG{3310},
  "NAD_1983_Contiguous_USA_Albers" => EPSG{5070},
  "North_Pole_Orthographic" => ESRI{102035},
  "NZGD_2000_New_Zealand_Transverse_Mercator" => EPSG{2193},
  "RGF93_v2" => EPSG{9777},
  "RGF93_v2b" => EPSG{9782},
  "SIRGAS_2000_UTM_Zone_11N" => EPSG{31965},
  "SIRGAS_2000_UTM_Zone_12N" => EPSG{31966},
  "SIRGAS_2000_UTM_Zone_13N" => EPSG{31967},
  "SIRGAS_2000_UTM_Zone_14N" => EPSG{31968},
  "SIRGAS_2000_UTM_Zone_15N" => EPSG{31969},
  "SIRGAS_2000_UTM_Zone_16N" => EPSG{31970},
  "SIRGAS_2000_UTM_Zone_17N" => EPSG{31971},
  "SIRGAS_2000_UTM_Zone_17S" => EPSG{31977},
  "SIRGAS_2000_UTM_Zone_18N" => EPSG{31972},
  "SIRGAS_2000_UTM_Zone_18S" => EPSG{31978},
  "SIRGAS_2000_UTM_Zone_19N" => EPSG{31973},
  "SIRGAS_2000_UTM_Zone_19S" => EPSG{31979},
  "SIRGAS_2000_UTM_Zone_20N" => EPSG{31974},
  "SIRGAS_2000_UTM_Zone_20S" => EPSG{31980},
  "SIRGAS_2000_UTM_Zone_21N" => EPSG{31975},
  "SIRGAS_2000_UTM_Zone_21S" => EPSG{31981},
  "SIRGAS_2000_UTM_Zone_22N" => EPSG{31976},
  "SIRGAS_2000_UTM_Zone_22S" => EPSG{31982},
  "SIRGAS_2000_UTM_Zone_23N" => EPSG{6210},
  "SIRGAS_2000_UTM_Zone_23S" => EPSG{31983},
  "SIRGAS_2000_UTM_Zone_24N" => EPSG{6211},
  "SIRGAS_2000_UTM_Zone_24S" => EPSG{31984},
  "SIRGAS_2000_UTM_Zone_25S" => EPSG{31985},
  "SIRGAS_2000_UTM_Zone_26S" => EPSG{5396},
  "South_Pole_Orthographic" => ESRI{102037},
  "TM75_Irish_Grid" => EPSG{29903},
  "WGS_1984_Plate_Carree" => EPSG{32662},
  "WGS_1984_UTM_Zone_10N"    => EPSG{32610},
  "WGS_1984_UTM_Zone_10S"    => EPSG{32710},
  "WGS_1984_UTM_Zone_11N"    => EPSG{32611},
  "WGS_1984_UTM_Zone_11S"    => EPSG{32711},
  "WGS_1984_UTM_Zone_12N"    => EPSG{32612},
  "WGS_1984_UTM_Zone_12S"    => EPSG{32712},
  "WGS_1984_UTM_Zone_13N"    => EPSG{32613},
  "WGS_1984_UTM_Zone_13S"    => EPSG{32713},
  "WGS_1984_UTM_Zone_14N"    => EPSG{32614},
  "WGS_1984_UTM_Zone_14S"    => EPSG{32714},
  "WGS_1984_UTM_Zone_15N"    => EPSG{32615},
  "WGS_1984_UTM_Zone_15S"    => EPSG{32715},
  "WGS_1984_UTM_Zone_16N"    => EPSG{32616},
  "WGS_1984_UTM_Zone_16S"    => EPSG{32716},
  "WGS_1984_UTM_Zone_17N"    => EPSG{32617},
  "WGS_1984_UTM_Zone_17S"    => EPSG{32717},
  "WGS_1984_UTM_Zone_18N"    => EPSG{32618},
  "WGS_1984_UTM_Zone_18S"    => EPSG{32718},
  "WGS_1984_UTM_Zone_19N"    => EPSG{32619},
  "WGS_1984_UTM_Zone_19S"    => EPSG{32719},
  "WGS_1984_UTM_Zone_1N"     => EPSG{32601},
  "WGS_1984_UTM_Zone_1S"     => EPSG{32701},
  "WGS_1984_UTM_Zone_20N"    => EPSG{32620},
  "WGS_1984_UTM_Zone_20S"    => EPSG{32720},
  "WGS_1984_UTM_Zone_21N"    => EPSG{32621},
  "WGS_1984_UTM_Zone_21S"    => EPSG{32721},
  "WGS_1984_UTM_Zone_22N"    => EPSG{32622},
  "WGS_1984_UTM_Zone_22S"    => EPSG{32722},
  "WGS_1984_UTM_Zone_23N"    => EPSG{32623},
  "WGS_1984_UTM_Zone_23S"    => EPSG{32723},
  "WGS_1984_UTM_Zone_24N"    => EPSG{32624},
  "WGS_1984_UTM_Zone_24S"    => EPSG{32724},
  "WGS_1984_UTM_Zone_25N"    => EPSG{32625},
  "WGS_1984_UTM_Zone_25S"    => EPSG{32725},
  "WGS_1984_UTM_Zone_26N"    => EPSG{32626},
  "WGS_1984_UTM_Zone_26S"    => EPSG{32726},
  "WGS_1984_UTM_Zone_27N"    => EPSG{32627},
  "WGS_1984_UTM_Zone_27S"    => EPSG{32727},
  "WGS_1984_UTM_Zone_28N"    => EPSG{32628},
  "WGS_1984_UTM_Zone_28S"    => EPSG{32728},
  "WGS_1984_UTM_Zone_29N"    => EPSG{32629},
  "WGS_1984_UTM_Zone_29S"    => EPSG{32729},
  "WGS_1984_UTM_Zone_2N"     => EPSG{32602},
  "WGS_1984_UTM_Zone_2S"     => EPSG{32702},
  "WGS_1984_UTM_Zone_30N"    => EPSG{32630},
  "WGS_1984_UTM_Zone_30S"    => EPSG{32730},
  "WGS_1984_UTM_Zone_31N"    => EPSG{32631},
  "WGS_1984_UTM_Zone_31S"    => EPSG{32731},
  "WGS_1984_UTM_Zone_32N"    => EPSG{32632},
  "WGS_1984_UTM_Zone_32S"    => EPSG{32732},
  "WGS_1984_UTM_Zone_33N"    => EPSG{32633},
  "WGS_1984_UTM_Zone_33S"    => EPSG{32733},
  "WGS_1984_UTM_Zone_34N"    => EPSG{32634},
  "WGS_1984_UTM_Zone_34S"    => EPSG{32734},
  "WGS_1984_UTM_Zone_35N"    => EPSG{32635},
  "WGS_1984_UTM_Zone_35S"    => EPSG{32735},
  "WGS_1984_UTM_Zone_36N"    => EPSG{32636},
  "WGS_1984_UTM_Zone_36S"    => EPSG{32736},
  "WGS_1984_UTM_Zone_37N"    => EPSG{32637},
  "WGS_1984_UTM_Zone_37S"    => EPSG{32737},
  "WGS_1984_UTM_Zone_38N"    => EPSG{32638},
  "WGS_1984_UTM_Zone_38S"    => EPSG{32738},
  "WGS_1984_UTM_Zone_39N"    => EPSG{32639},
  "WGS_1984_UTM_Zone_39S"    => EPSG{32739},
  "WGS_1984_UTM_Zone_3N"     => EPSG{32603},
  "WGS_1984_UTM_Zone_3S"     => EPSG{32703},
  "WGS_1984_UTM_Zone_40N"    => EPSG{32640},
  "WGS_1984_UTM_Zone_40S"    => EPSG{32740},
  "WGS_1984_UTM_Zone_41N"    => EPSG{32641},
  "WGS_1984_UTM_Zone_41S"    => EPSG{32741},
  "WGS_1984_UTM_Zone_42N"    => EPSG{32642},
  "WGS_1984_UTM_Zone_42S"    => EPSG{32742},
  "WGS_1984_UTM_Zone_43N"    => EPSG{32643},
  "WGS_1984_UTM_Zone_43S"    => EPSG{32743},
  "WGS_1984_UTM_Zone_44N"    => EPSG{32644},
  "WGS_1984_UTM_Zone_44S"    => EPSG{32744},
  "WGS_1984_UTM_Zone_45N"    => EPSG{32645},
  "WGS_1984_UTM_Zone_45S"    => EPSG{32745},
  "WGS_1984_UTM_Zone_46N"    => EPSG{32646},
  "WGS_1984_UTM_Zone_46S"    => EPSG{32746},
  "WGS_1984_UTM_Zone_47N"    => EPSG{32647},
  "WGS_1984_UTM_Zone_47S"    => EPSG{32747},
  "WGS_1984_UTM_Zone_48N"    => EPSG{32648},
  "WGS_1984_UTM_Zone_48S"    => EPSG{32748},
  "WGS_1984_UTM_Zone_49N"    => EPSG{32649},
  "WGS_1984_UTM_Zone_49S"    => EPSG{32749},
  "WGS_1984_UTM_Zone_4N"     => EPSG{32604},
  "WGS_1984_UTM_Zone_4S"     => EPSG{32704},
  "WGS_1984_UTM_Zone_50N"    => EPSG{32650},
  "WGS_1984_UTM_Zone_50S"    => EPSG{32750},
  "WGS_1984_UTM_Zone_51N"    => EPSG{32651},
  "WGS_1984_UTM_Zone_51S"    => EPSG{32751},
  "WGS_1984_UTM_Zone_52N"    => EPSG{32652},
  "WGS_1984_UTM_Zone_52S"    => EPSG{32752},
  "WGS_1984_UTM_Zone_53N"    => EPSG{32653},
  "WGS_1984_UTM_Zone_53S"    => EPSG{32753},
  "WGS_1984_UTM_Zone_54N"    => EPSG{32654},
  "WGS_1984_UTM_Zone_54S"    => EPSG{32754},
  "WGS_1984_UTM_Zone_55N"    => EPSG{32655},
  "WGS_1984_UTM_Zone_55S"    => EPSG{32755},
  "WGS_1984_UTM_Zone_56N"    => EPSG{32656},
  "WGS_1984_UTM_Zone_56S"    => EPSG{32756},
  "WGS_1984_UTM_Zone_57N"    => EPSG{32657},
  "WGS_1984_UTM_Zone_57S"    => EPSG{32757},
  "WGS_1984_UTM_Zone_58N"    => EPSG{32658},
  "WGS_1984_UTM_Zone_58S"    => EPSG{32758},
  "WGS_1984_UTM_Zone_59N"    => EPSG{32659},
  "WGS_1984_UTM_Zone_59S"    => EPSG{32759},
  "WGS_1984_UTM_Zone_5N"     => EPSG{32605},
  "WGS_1984_UTM_Zone_5S"     => EPSG{32705},
  "WGS_1984_UTM_Zone_60N"    => EPSG{32660},
  "WGS_1984_UTM_Zone_60S"    => EPSG{32760},
  "WGS_1984_UTM_Zone_6N"     => EPSG{32606},
  "WGS_1984_UTM_Zone_6S"     => EPSG{32706},
  "WGS_1984_UTM_Zone_7N"     => EPSG{32607},
  "WGS_1984_UTM_Zone_7S"     => EPSG{32707},
  "WGS_1984_UTM_Zone_8N"     => EPSG{32608},
  "WGS_1984_UTM_Zone_8S"     => EPSG{32708},
  "WGS_1984_UTM_Zone_9N"     => EPSG{32609},
  "WGS_1984_UTM_Zone_9S"     => EPSG{32709},
  "WGS_1984_Web_Mercator_Auxiliary_Sphere" => EPSG{3857},
  "WGS_1984_World_Mercator" => EPSG{3395},
  "World_Behrmann" => ESRI{54017},
  "World_Cylindrical_Equal_Area" => ESRI{54034},
  "World_Robinson" => ESRI{54030},
  "World_Winkel_Tripel_NGS" => ESRI{54042}
)

"""
    CoordRefSystems.string2code(string)

Get the EPSG/ESRI code from the CRS `string`.
"""
function string2code(crsstr)
  # regex for WKT formats: "KEYWORD[content]"
  wktregex = r"([A-Z_]+)\[(.*)\]"s
  wktmatch = match(wktregex, crsstr) |> checkmatch
  keyword, content = wktmatch
  # to differentiate WKT1 from WKT2, see Annex B.8 of the OGC specification:
  # https://docs.ogc.org/is/18-010r11/18-010r11.pdf
  if endswith(keyword, "CRS") # WKT2
    # match the last EPSG/ESRI ID
    # the last ID comes with the CRS code
    idregex = r"ID\[\"(EPSG|ESRI)\",([0-9]+)\]$"
    # removing all extra spaces for safe matching
    idmatch = match(idregex, filter(!isspace, content)) |> checkmatch
    type, codestr = idmatch
    code = parse(Int, codestr)
    type == "EPSG" ? EPSG{code} : ESRI{code}
  elseif endswith(keyword, "CS") # WKT1
    # use the datum name to differentiate ESRI WKT1 from OGC WKT1
    # if the datum name starts with "D_", the format is ESRI WKT1
    datumregex = r"DATUM\[\"(.*?)\""
    datummatch = match(datumregex, content) |> checkmatch
    datumname = datummatch.captures[1]
    if startswith(datumname, "D_") # ESRI WKT1
      # the content of the first string comes with the ESRI ID of the CRS
      strregex = r"^\"(.*?)\""
      # removing all leading extra spaces for safe matching
      strmatch = match(strregex, lstrip(content)) |> checkmatch
      esriid = strmatch.captures[1]
      if haskey(esriid2code, esriid)
        esriid2code[esriid]
      else
        throw(ArgumentError("""
        EPSG/ESRI code for the ESRI ID \"$esriid\" not found in dictionary.
        Please check https://github.com/JuliaEarth/CoordRefSystems.jl/blob/main/src/strings.jl
        If you know the EPSG/ESRI code of a given ESRI WKT string, please submit a pull request.
        """))
      end
    else # OGC WKT1
      # match the last EPSG/ESRI AUTHORITY
      # the last AUTHORITY comes with the CRS code
      authregex = r"AUTHORITY\[\"(EPSG|ESRI)\",\"([0-9]+)\"\]$"
      # removing all extra spaces for safe matching
      authmatch = match(authregex, filter(!isspace, content)) |> checkmatch
      type, codestr = authmatch
      code = parse(Int, codestr)
      type == "EPSG" ? EPSG{code} : ESRI{code}
    end
  else
    parseerror()
  end
end

checkmatch(m) = isnothing(m) ? parseerror() : m

function parseerror()
  throw(ArgumentError("""
  Malformed CRS string.
  Please make sure that the string follows any of the following Well-Known-Text formats: OGC WKT1, ESRI WKT1, WKT2.
  """))
end
