# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Basic{Datum}

Basic CRS with a given `Datum`.
"""
abstract type Basic{Datum} <: CRS{Datum} end

"""
    Cartesian(x₁, x₂, ..., xₙ)
    Cartesian{Datum}(x₁, x₂, ..., xₙ)
    Cartesian((x₁, x₂, ..., xₙ))
    Cartesian{Datum}((x₁, x₂, ..., xₙ))

N-dimensional Cartesian coordinates `x₁, x₂, ..., xₙ` in length units (default to meter)
with a given `Datum` (default to `NoDatum`).
The first 3 coordinates can be accessed with the properties `x`, `y` and `z`, respectively.

## Examples

```julia
Cartesian(1, 1) # add default units
Cartesian(1u"m", 1u"m") # integers are converted converted to floats
Cartesian(1.0u"km", 1.0u"km", 1.0u"km")
Cartesian{WGS84Latest}(1.0u"m", 1.0u"m")
```

## References

* [Cartesian coordinate system](https://en.wikipedia.org/wiki/Cartesian_coordinate_system)
* [ISO 80000-2:2019](https://www.iso.org/standard/64973.html)
* [ISO 80000-3:2019](https://www.iso.org/standard/64974.html)
"""
struct Cartesian{Datum,N,L<:Len} <: Basic{Datum}
  coords::NTuple{N,L}
end

Cartesian{Datum}(coords::NTuple{N,L}) where {Datum,N,L<:Len} = Cartesian{Datum,N,float(L)}(coords)
Cartesian{Datum}(coords::NTuple{N,Len}) where {Datum,N} = Cartesian{Datum}(promote(coords...))
Cartesian{Datum}(coords::NTuple{N,Number}) where {Datum,N} = Cartesian{Datum}(addunit.(coords, u"m"))
Cartesian{Datum}(coords::Number...) where {Datum} = Cartesian{Datum}(coords)

Cartesian(args...) = Cartesian{NoDatum}(args...)

Base.convert(::Type{Cartesian{Datum,N,L}}, coords::Cartesian{Datum}) where {Datum,N,L} =
  Cartesian{Datum,N,L}(_coords(coords))

Base.propertynames(::Cartesian) = (:x, :y, :z)

function Base.getproperty(coords::Cartesian, name::Symbol)
  tup = _coords(coords)
  if name === :x
    tup[1]
  elseif name === :y
    tup[2]
  elseif name === :z
    tup[3]
  else
    error("invalid property, use `x`, `y` or `z`")
  end
end

ncoords(::Type{<:Cartesian{Datum,N}}) where {Datum,N} = N

cvalues(coords::Cartesian) = _coords(coords)

cnames(C::Type{<:Cartesian}) = _fnames(C)

ndims(::Type{<:Cartesian{Datum,N}}) where {Datum,N} = N

function Base.isapprox(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian}
  # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/53
  c₁ = SVector(_coords(coords₁))
  c₂ = SVector(_coords(coords₂))
  isapprox(c₁, c₂; kwargs...)
end

function allapprox(coords₁::C, coords₂::C; kwargs...) where {C<:Cartesian}
  c₁ = _coords(coords₁)
  c₂ = _coords(coords₂)
  all(ntuple(i -> isapprox(c₁[i], c₂[i]; kwargs...), length(c₁)))
end

function tol(coords::Cartesian)
  Q = eltype(_coords(coords))
  atol(numtype(Q)) * unit(Q)
end

lentype(::Type{Cartesian{Datum,N,L}}) where {Datum,N,L} = L

Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Cartesian{Datum,N}}) where {Datum,N} =
  Cartesian{Datum}(ntuple(i -> rand(rng), N)...)

_coords(coords::Cartesian) = getfield(coords, :coords)

function _fnames(::Type{<:Cartesian{Datum,N}}) where {Datum,N}
  if N == 1
    (:x,)
  elseif N == 2
    (:x, :y)
  elseif N == 3
    (:x, :y, :z)
  else
    ntuple(i -> Symbol(:x, i), N)
  end
end

"""
    Polar(ρ, ϕ)
    Polar{Datum}(ρ, ϕ)

Polar coordinates with radius `ρ ∈ [0,∞)` in length units (default to meter),
angle `ϕ ∈ [0,2π)` in angular units (default to radian)
and a given `Datum` (default to `NoDatum`).

## Examples

```julia
Polar(1, π/4) # add default units
Polar(1u"m", (π/4)u"rad") # integers are converted converted to floats
Polar(1.0u"m", 45u"°") # degrees are converted to radians
Polar(1.0u"km", (π/4)u"rad")
Polar{WGS84Latest}(1.0u"m", (π/4)u"rad")
```

## References

* [Polar coordinate system](https://en.wikipedia.org/wiki/Polar_coordinate_system)
* [ISO 80000-2:2019](https://www.iso.org/standard/64973.html)
* [ISO 80000-3:2019](https://www.iso.org/standard/64974.html)
"""
struct Polar{Datum,L<:Len,R<:Rad} <: Basic{Datum}
  ρ::L
  ϕ::R
end

Polar{Datum}(ρ::L, ϕ::R) where {Datum,L<:Len,R<:Rad} = Polar{Datum,float(L),float(R)}(ρ, ϕ)
Polar{Datum}(ρ::Len, ϕ::Deg) where {Datum} = Polar{Datum}(ρ, deg2rad(ϕ))
Polar{Datum}(ρ::Number, ϕ::Number) where {Datum} = Polar{Datum}(addunit(ρ, u"m"), addunit(ϕ, u"rad"))

Polar(args...) = Polar{NoDatum}(args...)

Base.convert(::Type{Polar{Datum,L,R}}, coords::Polar{Datum}) where {Datum,L,R} = Polar{Datum,L,R}(coords.ρ, coords.ϕ)

ndims(::Type{<:Polar}) = 2

lentype(::Type{<:Polar{Datum,L}}) where {Datum,L} = L

Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Polar{Datum}}) where {Datum} =
  Polar{Datum}(rand(rng), 2π * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Polar}) = rand(rng, Polar{NoDatum})

"""
    Cylindrical(ρ, ϕ, z)
    Cylindrical{Datum}(ρ, ϕ, z)

Cylindrical coordinates with radius `ρ ∈ [0,∞)` in length units (default to meter), 
angle `ϕ ∈ [0,2π)` in angular units (default to radian),
height `z ∈ [0,∞)` in length units (default to meter)
and a given `Datum` (default to `NoDatum`).

## Examples

```julia
Cylindrical(1, π/4, 1) # add default units
Cylindrical(1u"m", (π/4)u"rad", 1u"m") # integers are converted converted to floats
Cylindrical(1.0u"m", 45u"°", 1.0u"m") # degrees are converted to radians
Cylindrical(1.0u"km", (π/4)u"rad", 1.0u"km")
Cylindrical{WGS84Latest}(1.0u"m", (π/4)u"rad", 1.0u"m")
```

## References

* [Cylindrical coordinate system](https://en.wikipedia.org/wiki/Cylindrical_coordinate_system)
* [ISO 80000-2:2019](https://www.iso.org/standard/64973.html)
* [ISO 80000-3:2019](https://www.iso.org/standard/64974.html)
"""
struct Cylindrical{Datum,L<:Len,R<:Rad} <: Basic{Datum}
  ρ::L
  ϕ::R
  z::L
end

Cylindrical{Datum}(ρ::L, ϕ::R, z::L) where {Datum,L<:Len,R<:Rad} = Cylindrical{Datum,float(L),float(R)}(ρ, ϕ, z)
function Cylindrical{Datum}(ρ::Len, ϕ::Rad, z::Len) where {Datum}
  nρ, nz = promote(ρ, z)
  Cylindrical{Datum}(nρ, ϕ, nz)
end
Cylindrical{Datum}(ρ::Len, ϕ::Deg, z::Len) where {Datum} = Cylindrical{Datum}(ρ, deg2rad(ϕ), z)
Cylindrical{Datum}(ρ::Number, ϕ::Number, z::Number) where {Datum} =
  Cylindrical{Datum}(addunit(ρ, u"m"), addunit(ϕ, u"rad"), addunit(z, u"m"))

Cylindrical(args...) = Cylindrical{NoDatum}(args...)

Base.convert(::Type{Cylindrical{Datum,L,R}}, coords::Cylindrical{Datum}) where {Datum,L,R} =
  Cylindrical{Datum,L,R}(coords.ρ, coords.ϕ, coords.z)

ndims(::Type{<:Cylindrical}) = 3

lentype(::Type{<:Cylindrical{Datum,L}}) where {Datum,L} = L

Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Cylindrical{Datum}}) where {Datum} =
  Cylindrical{Datum}(rand(rng), 2π * rand(rng), rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Cylindrical}) = rand(rng, Cylindrical{NoDatum})

"""
    Spherical(r, θ, ϕ)
    Spherical{Datum}(r, θ, ϕ)

Spherical coordinates with radius `r ∈ [0,∞)` in length units (default to meter), 
polar angle `θ ∈ [0,π]` and azimuth angle `ϕ ∈ [0,2π)` in angular units (default to radian)
and a given `Datum` (default to `NoDatum`).

## Examples

```julia
Spherical(1, π/4, π/4) # add default units
Spherical(1u"m", (π/4)u"rad", (π/4)u"rad") # integers are converted converted to floats
Spherical(1.0u"m", 45u"°", 45u"°") # degrees are converted to radians
Spherical(1.0u"km", (π/4)u"rad", (π/4)u"rad")
Spherical{WGS84Latest}(1.0u"m", (π/4)u"rad", (π/4)u"rad")
```

## References

* [Spherical coordinate system](https://en.wikipedia.org/wiki/Spherical_coordinate_system)
* [ISO 80000-2:2019](https://www.iso.org/standard/64973.html)
* [ISO 80000-3:2019](https://www.iso.org/standard/64974.html)
"""
struct Spherical{Datum,L<:Len,R<:Rad} <: Basic{Datum}
  r::L
  θ::R
  ϕ::R
end

Spherical{Datum}(r::L, θ::R, ϕ::R) where {Datum,L<:Len,R<:Rad} = Spherical{Datum,float(L),float(R)}(r, θ, ϕ)
Spherical{Datum}(r::Len, θ::Rad, ϕ::Rad) where {Datum} = Spherical{Datum}(r, promote(θ, ϕ)...)
Spherical{Datum}(r::Len, θ::Deg, ϕ::Deg) where {Datum} = Spherical{Datum}(r, deg2rad(θ), deg2rad(ϕ))
Spherical{Datum}(r::Number, θ::Number, ϕ::Number) where {Datum} =
  Spherical{Datum}(addunit(r, u"m"), addunit(θ, u"rad"), addunit(ϕ, u"rad"))

Spherical(args...) = Spherical{NoDatum}(args...)

Base.convert(::Type{Spherical{Datum,L,R}}, coords::Spherical{Datum}) where {Datum,L,R} =
  Spherical{Datum,L,R}(coords.r, coords.θ, coords.ϕ)

ndims(::Type{<:Spherical}) = 3

lentype(::Type{<:Spherical{Datum,L}}) where {Datum,L} = L

Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Spherical{Datum}}) where {Datum} =
  Spherical{Datum}(rand(rng), 2π * rand(rng), 2π * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Spherical}) = rand(rng, Spherical{NoDatum})

# ------------
# CONVERSIONS
# ------------

# Cartesian <> Polar
Base.convert(::Type{Cartesian{Datum}}, (; ρ, ϕ)::Polar{Datum}) where {Datum} = Cartesian{Datum}(ρ * cos(ϕ), ρ * sin(ϕ))
Base.convert(::Type{Polar{Datum}}, (; x, y)::Cartesian{Datum,2}) where {Datum} =
  Polar{Datum}(hypot(x, y), atanpos(y, x) * u"rad")

# Cartesian <> Cylindrical
Base.convert(::Type{Cartesian{Datum}}, (; ρ, ϕ, z)::Cylindrical{Datum}) where {Datum} =
  Cartesian{Datum}(ρ * cos(ϕ), ρ * sin(ϕ), z)
Base.convert(::Type{Cylindrical{Datum}}, (; x, y, z)::Cartesian{Datum,3}) where {Datum} =
  Cylindrical{Datum}(hypot(x, y), atanpos(y, x) * u"rad", z)

# Cartesian <> Spherical
Base.convert(::Type{Cartesian{Datum}}, (; r, θ, ϕ)::Spherical{Datum}) where {Datum} =
  Cartesian{Datum}(r * sin(θ) * cos(ϕ), r * sin(θ) * sin(ϕ), r * cos(θ))
Base.convert(::Type{Spherical{Datum}}, (; x, y, z)::Cartesian{Datum,3}) where {Datum} =
  Spherical{Datum}(hypot(x, y, z), atan(hypot(x, y), z) * u"rad", atanpos(y, x) * u"rad")

# datum conversion
function Base.convert(::Type{Cartesian{Datumₜ}}, coords::Cartesian{Datumₛ,3}) where {Datumₜ,Datumₛ}
  x = SVector(_coords(coords))

  δ, R, s = helmert(numtype(eltype(x)), Datumₛ, Datumₜ)

  x′ = (1 + s) * R * x + δ

  Cartesian{Datumₜ}(Tuple(x′))
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Cartesian}, coords::Polar{Datum}) where {Datum} = convert(Cartesian{Datum}, coords)
Base.convert(::Type{Polar}, coords::Cartesian{Datum,2}) where {Datum} = convert(Polar{Datum}, coords)

Base.convert(::Type{Cartesian}, coords::Cylindrical{Datum}) where {Datum} = convert(Cartesian{Datum}, coords)
Base.convert(::Type{Cylindrical}, coords::Cartesian{Datum,3}) where {Datum} = convert(Cylindrical{Datum}, coords)

Base.convert(::Type{Cartesian}, coords::Spherical{Datum}) where {Datum} = convert(Cartesian{Datum}, coords)
Base.convert(::Type{Spherical}, coords::Cartesian{Datum,3}) where {Datum} = convert(Spherical{Datum}, coords)
