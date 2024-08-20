# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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

function parseerror()
  throw(ArgumentError("""
  Malformed CRS string.
  Please make sure that the string follows any of the following Well-Known-Text formats: OGC WKT1, ESRI WKT1, WKT2.
  """))
end

checkmatch(m) = isnothing(m) ? parseerror() : m

# ESRI IDs in alphabetical order
const esriid2code = Dict(
  "British_National_Grid" => EPSG{27700},
  "GCS_MAGNA" => EPSG{4686},
  "GCS_SAD_1969_96" => EPSG{5527},
  "GCS_SIRGAS_2000" => EPSG{4674},
  "GCS_South_American_1969" => EPSG{4618},
  "GCS_WGS_1984" => EPSG{4326},
  "IRENET95_Irish_Transverse_Mercator" => EPSG{2157},
  "North_Pole_Orthographic" => ESRI{102035},
  "South_Pole_Orthographic" => ESRI{102037},
  "TM75_Irish_Grid" => EPSG{29903},
  "WGS_1984_Plate_Carree" => EPSG{32662},
  "WGS_1984_UTM_Zone_33N" => EPSG{32633},
  "WGS_1984_Web_Mercator_Auxiliary_Sphere" => EPSG{3857},
  "WGS_1984_World_Mercator" => EPSG{3395},
  "World_Behrmann" => ESRI{54017},
  "World_Cylindrical_Equal_Area" => ESRI{54034},
  "World_Robinson" => ESRI{54030},
  "World_Winkel_Tripel_NGS" => ESRI{54042}
)
