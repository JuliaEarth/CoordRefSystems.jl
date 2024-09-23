# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Geographic{Datum}

Geographic CRS with a given `Datum`.
"""
abstract type Geographic{Datum} <: CRS{Datum} end

ndims(::Type{<:Geographic}) = 3

# ----------------
# IMPLEMENTATIONS
# ----------------

include("geographic/geodetic.jl")
include("geographic/geocentric.jl")
include("geographic/authalic.jl")
