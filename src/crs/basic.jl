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
Cartesian(1m, 1m) # integers are converted converted to floats
Cartesian(1.0km, 1.0km, 1.0km)
Cartesian{WGS84Latest}(1.0m, 1.0m)
```

## References

* [Cartesian coordinate system](https://en.wikipedia.org/wiki/Cartesian_coordinate_system)
* [ISO 80000-2:2019](https://www.iso.org/standard/64973.html)
* [ISO 80000-3:2019](https://www.iso.org/standard/64974.html)
"""
struct Cartesian{Datum,N,L<:Len} <: Basic{Datum}
  coords::NTuple{N,L}
end

Cartesian{Datum,N}(coords::NTuple{N,L}) where {Datum,N,L<:Len} = Cartesian{Datum,N,float(L)}(coords)
Cartesian{Datum,N}(coords::NTuple{N,Len}) where {Datum,N} = Cartesian{Datum,N}(promote(coords...))
Cartesian{Datum,N}(coords::NTuple{N,Number}) where {Datum,N} = Cartesian{Datum,N}(addunit.(coords, m))
Cartesian{Datum,N}(coords::Vararg{Number,N}) where {Datum,N} = Cartesian{Datum,N}(coords)

Cartesian{Datum}(coords::NTuple{N,L}) where {Datum,N,L<:Len} = Cartesian{Datum,N,float(L)}(coords)
Cartesian{Datum}(coords::NTuple{N,Len}) where {Datum,N} = Cartesian{Datum}(promote(coords...))
Cartesian{Datum}(coords::NTuple{N,Number}) where {Datum,N} = Cartesian{Datum}(addunit.(coords, m))
Cartesian{Datum}(coords::Number...) where {Datum} = Cartesian{Datum}(coords)

Cartesian(args...) = Cartesian{NoDatum}(args...)

"""
    Cartesian2D(x, y)
    Cartesian2D{Datum}(x, y)
    Cartesian2D((x, y))
    Cartesian2D{Datum}((x, y))

Alias to [`Cartesian`](@ref) with 2 coordinates.

## Examples

```julia
Cartesian2D(1, 1) # add default units
Cartesian2D(1m, 1m) # integers are converted converted to floats
Cartesian2D(1.0km, 1.0km)
Cartesian2D{WGS84Latest}(1.0m, 1.0m)
```
"""
const Cartesian2D{Datum} = Cartesian{Datum,2}

Cartesian2D(args...) = Cartesian2D{NoDatum}(args...)

"""
    Cartesian3D(x, y, z)
    Cartesian3D{Datum}(x, y, z)
    Cartesian3D((x, y, z))
    Cartesian3D{Datum}((x, y, z))

Alias to [`Cartesian`](@ref) with 3 coordinates.

## Examples

```julia
Cartesian3D(1, 1, 1) # add default units
Cartesian3D(1m, 1m, 1m) # integers are converted converted to floats
Cartesian3D(1.0km, 1.0km, 1.0km)
Cartesian3D{WGS84Latest}(1.0m, 1.0m, 1.0m)
```
"""
const Cartesian3D{Datum} = Cartesian{Datum,3}

Cartesian3D(args...) = Cartesian3D{NoDatum}(args...)

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

prettyname(::Type{<:Cartesian}) = "Cartesian"

ncoords(::Type{<:Cartesian{<:Any,N}}) where {N} = N

ndims(::Type{<:Cartesian{<:Any,N}}) where {N} = N

names(C::Type{<:Cartesian}) = _fnames(C)

values(coords::Cartesian) = _coords(coords)

units(::Type{<:Cartesian{Datum,N,L}}) where {Datum,N,L} = ntuple(_ -> unit(L), N)

constructor(::Type{<:Cartesian{Datum}}) where {Datum} = Cartesian{Datum}

lentype(::Type{<:Cartesian{Datum,N,L}}) where {Datum,N,L} = L

==(coords₁::Cartesian{Datum,N}, coords₂::Cartesian{Datum,N}) where {Datum,N} = _coords(coords₁) == _coords(coords₂)

Base.isapprox(coords₁::Cartesian{Datum₁,3}, coords₂::Cartesian{Datum₂,3}; kwargs...) where {Datum₁,Datum₂} =
  isapprox(coords₁, convert(Cartesian{Datum₁}, coords₂); kwargs...)

Base.isapprox(coords₁::Cartesian{Datum,3}, coords₂::Cartesian{Datum,3}; kwargs...) where {Datum} =
  _isapprox(coords₁, coords₂; kwargs...)

Base.isapprox(coords₁::Cartesian{Datum,N}, coords₂::Cartesian{Datum,N}; kwargs...) where {Datum,N} =
  _isapprox(coords₁, coords₂; kwargs...)

function tol(coords::Cartesian)
  Q = eltype(_coords(coords))
  atol(numtype(Q)) * unit(Q)
end

makeconcrete(T::Type{Cartesian{Datum,N,L}}) where {Datum,N,L} = T
makeconcrete(::Type{Cartesian{Datum,N}}) where {Datum,N} = 
  Cartesian{Datum,N,Met{Float64}} |> makeconcrete
makeconcrete(::Type{Cartesian3D}) = Cartesian{NoDatum, 3} |> makeconcrete
makeconcrete(::Type{Cartesian2D}) = Cartesian{NoDatum, 2} |> makeconcrete

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

function _isapprox(coords₁, coords₂; kwargs...)
  # https://github.com/JuliaEarth/CoordRefSystems.jl/issues/53
  c₁ = SVector(_coords(coords₁))
  c₂ = SVector(_coords(coords₂))
  isapprox(c₁, c₂; kwargs...)
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
Polar(1m, (π/4)rad) # integers are converted converted to floats
Polar(1.0m, 45°) # degrees are converted to radians
Polar(1.0km, (π/4)rad)
Polar{WGS84Latest}(1.0m, (π/4)rad)
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
Polar{Datum}(ρ::Number, ϕ::Number) where {Datum} = Polar{Datum}(addunit(ρ, m), addunit(ϕ, rad))

Polar(args...) = Polar{NoDatum}(args...)

Base.convert(::Type{Polar{Datum,L,R}}, coords::Polar{Datum}) where {Datum,L,R} = Polar{Datum,L,R}(coords.ρ, coords.ϕ)

ndims(::Type{<:Polar}) = 2

constructor(::Type{<:Polar{Datum}}) where {Datum} = Polar{Datum}

lentype(::Type{<:Polar{Datum,L}}) where {Datum,L} = L

==(coords₁::Polar{Datum}, coords₂::Polar{Datum}) where {Datum} = coords₁.ρ == coords₂.ρ && coords₁.ϕ == coords₂.ϕ

makeconcrete(T::Type{Polar{Datum, L, R}}) where {Datum,L <: Len, R <: Rad} = T
makeconcrete(::Type{Polar{Datum, L}}) where {Datum,L <: Len} = 
  Polar{Datum, L, Rad{Float64}} |> makeconcrete
makeconcrete(::Type{Polar{Datum}}) where {Datum} = 
  Polar{Datum, Met{Float64}} |> makeconcrete
makeconcrete(::Type{Polar}) = 
  Polar{NoDatum} |> makeconcrete

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
Cylindrical(1m, (π/4)rad, 1m) # integers are converted converted to floats
Cylindrical(1.0m, 45°, 1.0m) # degrees are converted to radians
Cylindrical(1.0km, (π/4)rad, 1.0km)
Cylindrical{WGS84Latest}(1.0m, (π/4)rad, 1.0m)
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
  Cylindrical{Datum}(addunit(ρ, m), addunit(ϕ, rad), addunit(z, m))

Cylindrical(args...) = Cylindrical{NoDatum}(args...)

Base.convert(::Type{Cylindrical{Datum,L,R}}, coords::Cylindrical{Datum}) where {Datum,L,R} =
  Cylindrical{Datum,L,R}(coords.ρ, coords.ϕ, coords.z)

ndims(::Type{<:Cylindrical}) = 3

constructor(::Type{<:Cylindrical{Datum}}) where {Datum} = Cylindrical{Datum}

lentype(::Type{<:Cylindrical{Datum,L}}) where {Datum,L} = L

==(coords₁::Cylindrical{Datum}, coords₂::Cylindrical{Datum}) where {Datum} =
  coords₁.ρ == coords₂.ρ && coords₁.ϕ == coords₂.ϕ && coords₁.z == coords₂.z

makeconcrete(T::Type{Cylindrical{Datum, L, R}}) where {Datum,L <: Len, R <: Rad} = T
makeconcrete(::Type{Cylindrical{Datum, L}}) where {Datum,L <: Len} = 
  Cylindrical{Datum, L, Rad{Float64}} |> makeconcrete
makeconcrete(::Type{Cylindrical{Datum}}) where {Datum} = 
  Cylindrical{Datum, Met{Float64}} |> makeconcrete
makeconcrete(::Type{Cylindrical}) = 
  Cylindrical{NoDatum} |> makeconcrete

"""
    Spherical(r, θ, ϕ)
    Spherical{Datum}(r, θ, ϕ)

Spherical coordinates with radius `r ∈ [0,∞)` in length units (default to meter), 
polar angle `θ ∈ [0,π]` and azimuth angle `ϕ ∈ [0,2π)` in angular units (default to radian)
and a given `Datum` (default to `NoDatum`).

## Examples

```julia
Spherical(1, π/4, π/4) # add default units
Spherical(1m, (π/4)rad, (π/4)rad) # integers are converted converted to floats
Spherical(1.0m, 45°, 45°) # degrees are converted to radians
Spherical(1.0km, (π/4)rad, (π/4)rad)
Spherical{WGS84Latest}(1.0m, (π/4)rad, (π/4)rad)
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
  Spherical{Datum}(addunit(r, m), addunit(θ, rad), addunit(ϕ, rad))

Spherical(args...) = Spherical{NoDatum}(args...)

Base.convert(::Type{Spherical{Datum,L,R}}, coords::Spherical{Datum}) where {Datum,L,R} =
  Spherical{Datum,L,R}(coords.r, coords.θ, coords.ϕ)

ndims(::Type{<:Spherical}) = 3

constructor(::Type{<:Spherical{Datum}}) where {Datum} = Spherical{Datum}

lentype(::Type{<:Spherical{Datum,L}}) where {Datum,L} = L

==(coords₁::Spherical{Datum}, coords₂::Spherical{Datum}) where {Datum} =
  coords₁.r == coords₂.r && coords₁.θ == coords₂.θ && coords₁.ϕ == coords₂.ϕ

makeconcrete(T::Type{Spherical{Datum, L, R}}) where {Datum,L <: Len, R <: Rad} = T
makeconcrete(::Type{Spherical{Datum, L}}) where {Datum,L <: Len} = 
  Spherical{Datum, L, Rad{Float64}} |> makeconcrete
makeconcrete(::Type{Spherical{Datum}}) where {Datum} = 
  Spherical{Datum, Met{Float64}} |> makeconcrete
makeconcrete(::Type{Spherical}) = 
  Spherical{NoDatum} |> makeconcrete

# ------------
# CONVERSIONS
# ------------

# Cartesian <> Polar
Base.convert(::Type{Cartesian{Datum}}, (; ρ, ϕ)::Polar{Datum}) where {Datum} = Cartesian{Datum}(ρ * cos(ϕ), ρ * sin(ϕ))
Base.convert(::Type{Polar{Datum}}, (; x, y)::Cartesian{Datum,2}) where {Datum} =
  Polar{Datum}(hypot(x, y), atanpos(y, x) * rad)

# Cartesian <> Cylindrical
Base.convert(::Type{Cartesian{Datum}}, (; ρ, ϕ, z)::Cylindrical{Datum}) where {Datum} =
  Cartesian{Datum}(ρ * cos(ϕ), ρ * sin(ϕ), z)
Base.convert(::Type{Cylindrical{Datum}}, (; x, y, z)::Cartesian{Datum,3}) where {Datum} =
  Cylindrical{Datum}(hypot(x, y), atanpos(y, x) * rad, z)

# Cartesian <> Spherical
Base.convert(::Type{Cartesian{Datum}}, (; r, θ, ϕ)::Spherical{Datum}) where {Datum} =
  Cartesian{Datum}(r * sin(θ) * cos(ϕ), r * sin(θ) * sin(ϕ), r * cos(θ))
Base.convert(::Type{Spherical{Datum}}, (; x, y, z)::Cartesian{Datum,3}) where {Datum} =
  Spherical{Datum}(hypot(x, y, z), atan(hypot(x, y), z) * rad, atanpos(y, x) * rad)

# datum conversion
function Base.convert(::Type{Cartesian{Datumₜ}}, coords::Cartesian{Datumₛ,3}) where {Datumₜ,Datumₛ}
  x = SVector(_coords(coords))

  x′ = apply(transform(Datumₛ, Datumₜ), x)

  Cartesian{Datumₜ}(Tuple(x′))
end

# avoid converting coordinates with the same datum as the first argument
Base.convert(::Type{Cartesian{Datum}}, coords::Cartesian{Datum,3}) where {Datum} = coords

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{Cartesian}, coords::CRS{Datum}) where {Datum} = convert(Cartesian{Datum}, coords)

Base.convert(::Type{Polar}, coords::CRS{Datum}) where {Datum} = convert(Polar{Datum}, coords)

Base.convert(::Type{Cylindrical}, coords::CRS{Datum}) where {Datum} = convert(Cylindrical{Datum}, coords)

Base.convert(::Type{Spherical}, coords::CRS{Datum}) where {Datum} = convert(Spherical{Datum}, coords)
