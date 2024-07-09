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
  wktmatch = match(wktregex, crsstr)
  if isnothing(wktmatch)
    throw(ArgumentError("CRS format not supported"))
  end
  keyword, content = wktmatch
  # to differentiate WKT1 from WKT2, see Annex B.8 of the OGC specification:
  # https://docs.ogc.org/is/18-010r11/18-010r11.pdf
  if endswith(keyword, "CRS") # WKT2
    # match the last EPSG/ESRI ID
    # the last ID comes with the CRS code
    idregex = r"ID\[\"(EPSG|ESRI)\",([0-9]+)\]$"
    # removing all extra spaces for safe matching
    idmatch = match(idregex, filter(!isspace, content))
    if isnothing(idmatch)
      throw(ArgumentError("CRS ID not found in the WKT2 string"))
    end
    type, codestr = idmatch
    code = parse(Int, codestr)
    type == "EPSG" ? EPSG{code} : ESRI{code}
  elseif endswith(keyword, "CS") # ESRI WKT
    # the content of the first string comes with the ESRI ID of the CRS
    strregex = r"\"(.*?)\""
    strmatch = match(strregex, content)
    if isnothing(strmatch)
      throw(ArgumentError("ESRI ID of the CRS not found in the ESRI WKT string"))
    end
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
  else
    throw(ArgumentError("invalid WKT string"))
  end
end

const esriid2code = Dict(
  "WGS_1984_World_Mercator" => EPSG{3395},
  "WGS_1984_Web_Mercator_Auxiliary_Sphere" => EPSG{3857},
  "GCS_WGS_1984" => EPSG{4326},
  "WGS_1984_Plate_Carree" => EPSG{32662},
  "WGS_1984_UTM_Zone_33N" => EPSG{32633},
  "World_Behrmann" => ESRI{54017},
  "World_Robinson" => ESRI{54030},
  "World_Cylindrical_Equal_Area" => ESRI{54034},
  "World_Winkel_Tripel_NGS" => ESRI{54042},
  "North_Pole_Orthographic" => ESRI{102035},
  "South_Pole_Orthographic" => ESRI{102037}
)
