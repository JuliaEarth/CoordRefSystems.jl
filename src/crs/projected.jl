# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Projected{Datum}

Projected CRS from [`Geographic`](@ref) coordinates with a given `Datum`.
"""
abstract type Projected{Datum} <: CRS{Datum} end

"""
    formulas(CRS::Type{<:Projected}, T)

Returns the forward formulas of the `CRS`: `fx(λ, ϕ)` and `fy(λ, ϕ)`,
with `f(λ::T, ϕ::T) -> T` for both functions.
"""
function formulas end

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
