# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

function string2code(crsstr)
  # assumes WKT formats: "KEYWORD[content]"
  wktregex = r"([A-Z_]+)\[(.*)\]"s
  keyword, content = match(wktregex, crsstr)
  # to differentiate WKT1 from WKT2, see Annex B.8 of the OGC specification:
  # https://docs.ogc.org/is/18-010r11/18-010r11.pdf
  if endswith(keyword, "CRS") # WKT2
    # match all EPSG/ESRI IDs
    idregex = r"ID\[\"(EPSG|ESRI)\",([0-9]+)\]"
    # the last ID comes with the CRS code
    crsid = eachmatch(idregex, content) |> collect |> last
    type, code = crsid
    if type == "EPSG"
      EPSG{parse(Int, code)}
    else
      ESRI{parse(Int, code)}
    end
  elseif endswith(keyword, "CS") # ESRI WKT
    # the content of the first string comes with the ESRI ID of the CRS
    strregex = r"\"(.*?)\""
    esriid = match(strregex, content).captures |> first
    esriid2code[esriid]
  end
end

const esriid2code = Dict(
  "WGS_1984_World_Mercator" => EPSG{3395},
  "WGS_1984_Web_Mercator_Auxiliary_Sphere" => EPSG{3857}
)
