# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Projected{Datum}

Projected CRS with a given `Datum`.
"""
abstract type Projected{Datum} <: CRS{Datum} end

"""
    formulas(CRS::Type{<:Projected}, T)

Returns the forward formulas of the `CRS`: `fx(λ, ϕ)` and `fy(λ, ϕ)`,
with `f(λ::T, ϕ::T) -> T` for both functions.
"""
function formulas end

"""
    inrange(CRS::Type{<:Projected}, λ, ϕ)

Checks whether `λ` and `ϕ` are within the `CRS` range.
"""
inrange(::Type{<:Projected}, λ, ϕ) = -π ≤ λ ≤ π && -π / 2 ≤ ϕ ≤ π / 2

# ----------------
# IMPLEMENTATIONS
# ----------------

include("projected/mercator.jl")
include("projected/webmercator.jl")
include("projected/eqdistcylindrical.jl")
include("projected/eqareacylindrical.jl")
include("projected/winkeltripel.jl")
include("projected/robinson.jl")
include("projected/orthographic.jl")

# ----------
# FALLBACKS
# ----------

function Base.convert(::Type{C}, coords::LatLon{Datum}) where {Datum,C<:Projected{Datum}}
  T = numtype(coords.lon)
  λ = ustrip(deg2rad(coords.lon))
  ϕ = ustrip(deg2rad(coords.lat))
  if !inrange(C, λ, ϕ)
    throw(ArgumentError("coordinates outside of the projection range"))
  end
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  fx, fy = formulas(C, T)
  x = fx(λ, ϕ) * a
  y = fy(λ, ϕ) * a
  C(x, y)
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {Datum,C<:Projected{Datum}}
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  x = coords.x / a
  y = coords.y / a
  fx, fy = formulas(C, T)
  λ, ϕ = projinv(fx, fy, x, y, x, y)
  LatLon{Datum}(rad2deg(ϕ) * u"°", rad2deg(λ) * u"°")
end

# projection conversion with same Datum
function Base.convert(::Type{Cₜ}, coords::Cₛ) where {Datum,Cₜ<:Projected{Datum},Cₛ<:Projected{Datum}}
  latlon = convert(LatLon{Datum}, coords)
  convert(Cₜ, latlon)
end

# projection conversion with different datums
function Base.convert(::Type{Cₜ}, coords::Cₛ) where {Datumₜ,Datumₛ,Cₜ<:Projected{Datumₜ},Cₛ<:Projected{Datumₛ}}
  latlonₛ = convert(LatLon{Datumₛ}, coords)
  latlonₜ = convert(LatLon{Datumₜ}, latlonₛ)
  convert(Cₜ, latlonₜ)
end
