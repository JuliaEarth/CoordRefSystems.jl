# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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

constructor(::Type{<:Cartesian}) = Cartesian

reconstruct(C::Type{Cartesian{Datum}}, raw) where {Datum} = constructor(C)(raw...)

reconstruct(C::Type{Cartesian}, raw) = constructor(C)(raw...)

lentype(::Type{<:Cartesian{Datum,N,L}}) where {Datum,N,L} = L

==(coords₁::Cartesian{Datum,N}, coords₂::Cartesian{Datum,N}) where {Datum,N} = _coords(coords₁) == _coords(coords₂)

Random.rand(rng::Random.AbstractRNG, ::Type{Cartesian{Datum,N}}) where {Datum,N} =
  Cartesian{Datum}(ntuple(i -> rand(rng), N)...)

Random.rand(rng::Random.AbstractRNG, ::Type{Cartesian2D}) = rand(rng, Cartesian2D{NoDatum})

Random.rand(rng::Random.AbstractRNG, ::Type{Cartesian3D}) = rand(rng, Cartesian3D{NoDatum})

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
