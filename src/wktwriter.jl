# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module WKTWriter

using CoordRefSystems
using CoordRefSystems: CRS

export wkt

"""
    CoordRefSystems.wkt(crs::CRS)::AbstractString
Convert a `CRS` object into an OGC WKT-CRS 2 formatted string.
- If an EPSG code exists, the function will use a generic template.
- If an EPSG code is missing, WKT is manually constructed from CRS metadata.
- Strictly follows the OGC WKT-CRS 2 format (no GDAL/PROJ extensions).
"""
function wkt(crs::CRS)::AbstractString
    epsg_code = try
        CoordRefSystems.code(crs)
    catch
        nothing
    end

    if epsg_code !== nothing
        return construct_wkt_with_epsg(epsg_code, crs)
    else
        return construct_wkt_from_metadata(crs)
    end
end

"""
    construct_wkt_with_epsg(epsg_code::Integer, crs::CRS)::AbstractString
Generates a WKT2 string using the EPSG code (generic template).
"""
function construct_wkt_with_epsg(epsg_code::Integer, crs::CRS)::AbstractString
    return """
    PROJCRS["$(crs.name)",
        BASEGEOGCRS["$(crs.datum)",
            DATUM["$(crs.datum)",
                ELLIPSOID["$(crs.ellipsoid)", $(crs.ellipsoid_major_axis), $(crs.ellipsoid_flattening),
                    LENGTHUNIT["metre", 1]
                ]
            ]
        ],
        ID["EPSG", $epsg_code]
    ]
    """
end

"""
    construct_wkt_from_metadata(crs::CRS)::AbstractString
Manually constructs an OGC WKT-CRS 2 string when no EPSG code is available.
"""
function construct_wkt_from_metadata(crs::CRS)::AbstractString
    projection_method = get(crs, :projection_method, "Unknown Method")
    parameters = get(crs, :parameters, [])

    wkt = """
    PROJCRS["$(crs.name)",
        BASEGEOGCRS["$(crs.datum)",
            DATUM["$(crs.datum)",
                ELLIPSOID["$(crs.ellipsoid)", $(crs.ellipsoid_major_axis), $(crs.ellipsoid_flattening),
                    LENGTHUNIT["metre", 1]
                ]
            ],
            PRIMEM["$(crs.prime_meridian)", 0, ANGLEUNIT["degree", 0.0174532925199433]]
        ],
        CONVERSION["$(crs.projection)",
            METHOD["$projection_method"]
    """

    for param in parameters
        wkt *= """,
            PARAMETER["$(param.name)", $(param.value)]"""
    end

    wkt *= """
        ],
        CS[Cartesian, 2],
        AXIS["E", east, ORDER[1], LENGTHUNIT["metre", 1]],
        AXIS["N", north, ORDER[2], LENGTHUNIT["metre", 1]],
        USAGE[SCOPE["General purpose CRS"]]
    ]
    """

    return wkt
end

end
