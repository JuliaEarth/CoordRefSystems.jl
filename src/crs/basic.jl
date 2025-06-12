# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Basic{Datum}

Basic CRS with a given `Datum`.
"""
abstract type Basic{Datum} <: CRS{Datum} end

# ----------------
# IMPLEMENTATIONS
# ----------------

include("basic/cartesian.jl")
include("basic/polar.jl")
include("basic/cylindrical.jl")
include("basic/spherical.jl")

# ------------
# CONVERSIONS
# ------------

# Cartesian <> Polar
# https://en.wikipedia.org/wiki/Polar_coordinate_system#Converting_between_polar_and_Cartesian_coordinates
Base.convert(::Type{Cartesian{Datum}}, (; ρ, ϕ)::Polar{Datum}) where {Datum} = Cartesian{Datum}(ρ * cos(ϕ), ρ * sin(ϕ))
Base.convert(::Type{Polar{Datum}}, (; x, y)::Cartesian{Datum,2}) where {Datum} =
  Polar{Datum}(hypot(x, y), atanpos(y, x) * rad)

# Cartesian <> Cylindrical
# https://en.wikipedia.org/wiki/Cylindrical_coordinate_system#Cartesian_coordinates
Base.convert(::Type{Cartesian{Datum}}, (; ρ, ϕ, z)::Cylindrical{Datum}) where {Datum} =
  Cartesian{Datum}(ρ * cos(ϕ), ρ * sin(ϕ), z)
Base.convert(::Type{Cylindrical{Datum}}, (; x, y, z)::Cartesian{Datum,3}) where {Datum} =
  Cylindrical{Datum}(hypot(x, y), atanpos(y, x) * rad, z)

# Cartesian <> Spherical
# https://en.wikipedia.org/wiki/Spherical_coordinate_system#Cartesian_coordinates
Base.convert(::Type{Cartesian{Datum}}, (; r, θ, ϕ)::Spherical{Datum}) where {Datum} =
  Cartesian{Datum}(r * sin(θ) * cos(ϕ), r * sin(θ) * sin(ϕ), r * cos(θ))
Base.convert(::Type{Spherical{Datum}}, (; x, y, z)::Cartesian{Datum,3}) where {Datum} =
  Spherical{Datum}(hypot(x, y, z), atan(hypot(x, y), z) * rad, atanpos(y, x) * rad)

# Cylindrical <> Spherical
# https://en.wikipedia.org/wiki/Spherical_coordinate_system#Cylindrical_coordinates
Base.convert(::Type{Cylindrical{Datum}}, (; r, θ, ϕ)::Spherical{Datum}) where {Datum} =
  Cylindrical{Datum}(r * sin(θ), ϕ, r * cos(θ))
Base.convert(::Type{Spherical{Datum}}, (; ρ, ϕ, z)::Cylindrical{Datum}) where {Datum} =
  Spherical{Datum}(hypot(ρ, z), atan(ρ, z) * rad, ϕ)

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Cartesian}, coords::CRS{Datum}) where {Datum} = convert(Cartesian{Datum}, coords)

Base.convert(::Type{Polar}, coords::CRS{Datum}) where {Datum} = convert(Polar{Datum}, coords)

Base.convert(::Type{Cylindrical}, coords::CRS{Datum}) where {Datum} = convert(Cylindrical{Datum}, coords)

Base.convert(::Type{Spherical}, coords::CRS{Datum}) where {Datum} = convert(Spherical{Datum}, coords)
