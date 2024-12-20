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

Retrieve shift parameters of the projected `CRS`.
"""
projshift(::Type{<:Projected}) = Shift()

projshift(::Type{<:Projected{Datum,Shift}}) where {Datum,Shift} = Shift

"""
    formulas(CRS::Type{<:Projected}, T)

Returns the forward formulas of the `CRS`. The formulas
`x = fx(λ, ϕ)` and `y = fy(λ, ϕ)` map unitless longitude
`λ` and latitude `ϕ` to unitless Cartesian coordinates
`x` and `y`.

The formulas must be normalized, i.e., they must return
values that are **not** scaled by the major axis of the
ellipsoid of the datum. Additionally, these formulas should
**not** include the shift parameters: longitude origin `λₒ`,
false easting `xₒ` and false northing `yₒ`. These adjustments
are performed automatically for all `Projected` `CRS` in pre-
and post-processing steps using the `shift` function.
"""
function formulas end

"""
    forward(CRS::Type{<:Projected}, λ, ϕ)

Forward longitude `λ` and latitude `ϕ` in radians to `x` and `y`
in meters using `CRS` `formulas` that operate on unitless values.
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

Backward `x` and `y` in meters to longitude `λ` and latitude `ϕ`
in radians using `CRS` `formulas` that operate on unitless values.
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
function inbounds(::Type{<:Projected}, λ, ϕ)
  T = typeof(λ)
  -T(π) ≤ λ ≤ T(π) && -T(π) / 2 ≤ ϕ ≤ T(π) / 2
end

"""
    indomain(CRS::Type{<:Projected}, coords)

Checks whether `coords` coordinates are within the `CRS` domain.
"""
indomain(C::Type{<:Projected}, coords::CRS) = indomain(C, convert(LatLon, coords))

indomain(C::Type{<:Projected}, coords::LatLon) = _indomainlatlon(C, coords)

indomain(C::Type{<:Projected{Datum}}, coords::LatLon{Datum}) where {Datum} = _indomainlatlon(C, coords)

indomain(C::Type{<:Projected{Datumₜ}}, coords::LatLon{Datumₛ}) where {Datumₛ,Datumₜ} =
  _indomainlatlon(C, convert(LatLon{Datumₜ}, coords))

indomain(C::Type{<:Projected{Datum}}, coords::Cartesian{NoDatum,2}) where {Datum} = true

indomain(C::Type{<:Projected{Datum}}, coords::Cartesian{Datum,2}) where {Datum} = true

function _indomainlatlon(C, coords)
  lonₒ = oftype(coords.lon, projshift(C).lonₒ)
  inbounds(C, ustrip(deg2rad(coords.lon - lonₒ)), ustrip(deg2rad(coords.lat)))
end

# convert to Cartesian3D through a common LatLon
Base.isapprox(coords₁::Projected, coords₂::Projected; kwargs...) =
  isapprox(convert(Cartesian3D, coords₁), convert(Cartesian3D, coords₂); kwargs...)

Base.isapprox(coords₁::Projected, coords₂::CRS; kwargs...) =
  isapprox(convert(Cartesian3D, coords₁), convert(Cartesian, coords₂); kwargs...)

Base.isapprox(coords₁::CRS, coords₂::Projected; kwargs...) =
  isapprox(convert(Cartesian, coords₁), convert(Cartesian3D, coords₂); kwargs...)

function Random.rand(rng::Random.AbstractRNG, ::Type{C}) where {C<:Projected}
  try
    convert(C, rand(rng, LatLon))
  catch
    rand(rng, C)
  end
end

"""
    isconformal(CRS::Type{<:Projected})

Tells whether or not the projected `CRS` preserves angles.
"""
isconformal(CRS::Type{<:Projected}) = false

"""
    isequalarea(CRS::Type{<:Projected})

Tells whether or not the projected `CRS` preserves area.
"""
isequalarea(CRS::Type{<:Projected}) = false

"""
    isequidistant(CRS::Type{<:Projected})

Tells whether or not the projected `CRS` preserves distance.
"""
isequidistant(CRS::Type{<:Projected}) = false

"""
    iscompromise(CRS::Type{<:Projected})

Tells whether or not the projected `CRS` is a compromise
of angle, area and distance distortion.
"""
iscompromise(CRS::Type{<:Projected}) = false

# -----------
# IO METHODS
# -----------

function Base.summary(io::IO, coords::Projected)
  name = prettyname(coords)
  Datum = datum(coords)
  S = projshift(typeof(coords))
  print(io, "$name{$(rmmodule(Datum))} coordinates")
  if S ≠ Shift()
    print(io, " with lonₒ: $(S.lonₒ), xₒ: $(S.xₒ), yₒ: $(S.yₒ)")
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
include("projected/albers.jl")
include("projected/sinusoidal.jl")
include("projected/lambertazmeqarea.jl")

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{C}, coords::GeocentricLatLon{Datum}) where {Datum,C<:Projected{Datum}} =
  convert(C, convert(LatLon{Datum}, coords))

Base.convert(::Type{GeocentricLatLon{Datum}}, coords::C) where {Datum,C<:Projected{Datum}} =
  convert(GeocentricLatLon{Datum}, convert(LatLon{Datum}, coords))

Base.convert(::Type{C}, coords::GeocentricLatLonAlt{Datum}) where {Datum,C<:Projected{Datum}} =
  convert(C, convert(GeocentricLatLon{Datum}, coords))

Base.convert(::Type{GeocentricLatLonAlt{Datum}}, coords::C) where {Datum,C<:Projected{Datum}} =
  convert(GeocentricLatLonAlt{Datum}, convert(GeocentricLatLon{Datum}, coords))

Base.convert(::Type{C}, coords::LatLonAlt{Datum}) where {Datum,C<:Projected{Datum}} =
  convert(C, convert(LatLon{Datum}, coords))

Base.convert(::Type{LatLonAlt{Datum}}, coords::C) where {Datum,C<:Projected{Datum}} =
  convert(LatLonAlt{Datum}, convert(LatLon{Datum}, coords))

function Base.convert(::Type{C}, coords::LatLon{Datum}) where {Datum,C<:Projected{Datum}}
  S = projshift(C)
  T = numtype(coords.lon)
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  xₒ = numconvert(T, S.xₒ)
  yₒ = numconvert(T, S.yₒ)
  lonₒ = numconvert(T, S.lonₒ)
  λ = ustrip(deg2rad(fixlon(coords.lon - lonₒ)))
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
