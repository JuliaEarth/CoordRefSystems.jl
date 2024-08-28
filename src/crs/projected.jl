# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Projected{Datum,Shift}

Projected CRS with a given `Datum` and `Shift`.
"""
abstract type Projected{Datum,Shift} <: CRS{Datum} end

ndims(::Type{<:Projected}) = 2

"""
    CoordRefSystems.projshift(CRS::Type{<:Projected})

Shift parameters of the `CRS`.
"""
projshift(::Type{<:Projected}) = Shift()

projshift(::Type{<:Projected{Datum,Shift}}) where {Datum,Shift} = Shift

"""
    formulas(CRS::Type{<:Projected}, T)

Returns the forward formulas of the `CRS`: `fx(λ, ϕ)` and `fy(λ, ϕ)`,
with `f(λ::T, ϕ::T) -> T` for both functions.
"""
function formulas end

"""
    forward(CRS::Type{<:Projected}, λ, ϕ)

Forward longitude `λ` and latitude `ϕ` in radians to `x` and `y` in meters
using `CRS` formulas. Both inputs and outputs are unitless.
"""
function forward(::Type{C}, λ, ϕ) where {C<:Projected}
  T = typeof(λ)
  fx, fy = formulas(C, T)
  x = fx(λ, ϕ)
  y = fy(λ, ϕ)
  x, y
end

"""
    backward(CRS::Type{<:Projected}, x, y)

Backward `x` and `y` in meters to longitude `λ` and latitude `ϕ` in radians
using `CRS` formulas. Both inputs and outputs are unitless.
"""
function backward(::Type{C}, x, y) where {C<:Projected}
  T = typeof(x)
  fx, fy = formulas(C, T)
  projinv(fx, fy, x, y, x, y)
end

"""
    inbounds(CRS::Type{<:Projected}, λ, ϕ)

Checks whether `λ` and `ϕ` in radians are within the `CRS` domain.
"""
inbounds(::Type{<:Projected}, λ, ϕ) = -π ≤ λ ≤ π && -π / 2 ≤ ϕ ≤ π / 2

"""
    indomain(CRS::Type{<:Projected}, latlon::LatLon)

Checks whether `latlon` coordinates are within the `CRS` domain.
"""
function indomain(C::Type{<:Projected}, (; lat, lon)::LatLon)
  lonₒ = oftype(lon, projshift(C).lonₒ)
  inbounds(C, ustrip(deg2rad(lon - lonₒ)), ustrip(deg2rad(lat)))
end

Base.isapprox(coords₁::Projected{Datum}, coords₂::Projected{Datum}; kwargs...) where {Datum} =
  isapprox(convert(Cartesian, coords₁), convert(Cartesian, coords₂); kwargs...)

Base.isapprox(coords₁::Projected{Datum₁}, coords₂::Projected{Datum₂}; kwargs...) where {Datum₁,Datum₂} =
  isapprox(convert(Cartesian{Datum₁,3}, coords₁), convert(Cartesian{Datum₂,3}, coords₂); kwargs...)

function Random.rand(rng::Random.AbstractRNG, ::Type{C}) where {C<:Projected}
  try
    convert(C, rand(rng, LatLon))
  catch
    rand(rng, C)
  end
end

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
include("projected/transversemercator.jl")

# ----------
# FALLBACKS
# ----------

function Base.convert(::Type{C}, coords::LatLon{Datum}) where {Datum,C<:Projected{Datum}}
  S = projshift(C)
  T = numtype(coords.lon)
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  xₒ = numconvert(T, S.xₒ)
  yₒ = numconvert(T, S.yₒ)
  lonₒ = numconvert(T, S.lonₒ)
  λ = ustrip(deg2rad(coords.lon - lonₒ))
  ϕ = ustrip(deg2rad(coords.lat))
  if !inbounds(C, λ, ϕ)
    throw(ArgumentError("coordinates outside of the projection domain"))
  end
  x, y = forward(C, λ, ϕ)
  C(x * a + xₒ, y * a + yₒ)
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {Datum,C<:Projected{Datum}}
  S = projshift(C)
  T = numtype(coords.x)
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  xₒ = numconvert(T, S.xₒ)
  yₒ = numconvert(T, S.yₒ)
  lonₒ = numconvert(T, S.lonₒ)
  x = (coords.x - xₒ) / a
  y = (coords.y - yₒ) / a
  λ, ϕ = backward(C, x, y)
  LatLon{Datum}(phi2lat(ϕ), lam2lon(λ) + lonₒ)
end

Base.convert(C::Type{<:Projected{Datumₜ}}, coords::LatLon{Datumₛ}) where {Datumₜ,Datumₛ} =
  convert(C, convert(LatLon{Datumₜ}, coords))

Base.convert(C::Type{LatLon{Datumₜ}}, coords::Projected{Datumₛ}) where {Datumₜ,Datumₛ} =
  convert(C, convert(LatLon, coords))

Base.convert(::Type{Cartesian}, coords::Projected{Datum}) where {Datum} = convert(Cartesian2D, coords)

Base.convert(::Type{Cartesian2D}, coords::Projected{Datum}) where {Datum} = convert(Cartesian{Datum,2}, coords)
Base.convert(::Type{Cartesian{Datum,2}}, coords::Projected{Datum}) where {Datum} = Cartesian{Datum}(coords.x, coords.y)
Base.convert(C::Type{<:Projected{Datum}}, coords::Cartesian{Datum,2}) where {Datum} = C(coords.x, coords.y)
Base.convert(C::Type{<:Projected{Datum}}, coords::Cartesian{NoDatum,2}) where {Datum} = C(coords.x, coords.y)

Base.convert(::Type{Cartesian3D}, coords::Projected{Datum}) where {Datum} = convert(Cartesian{Datum,3}, coords)
Base.convert(::Type{Cartesian{Datum,3}}, coords::Projected{Datum}) where {Datum} =
  convert(Cartesian, convert(LatLon, coords))
Base.convert(C::Type{<:Projected{Datum}}, coords::Cartesian{Datum,3}) where {Datum} =
  convert(C, convert(LatLon, coords))

# projection conversion with same datum
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

# avoid converting coordinates with the same type as the first argument
Base.convert(::Type{C}, coords::C) where {Datum,C<:Projected{Datum}} = coords
