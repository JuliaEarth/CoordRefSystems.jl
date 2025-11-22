# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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

constructor(::Type{<:Cylindrical}) = Cylindrical

lentype(::Type{<:Cylindrical{Datum,L}}) where {Datum,L} = L

==(coords₁::Cylindrical{Datum}, coords₂::Cylindrical{Datum}) where {Datum} =
  coords₁.ρ == coords₂.ρ && coords₁.ϕ == coords₂.ϕ && coords₁.z == coords₂.z

Random.rand(rng::Random.AbstractRNG, ::Type{Cylindrical{Datum}}) where {Datum} =
  Cylindrical{Datum}(rand(rng), 2π * rand(rng), rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{Cylindrical}) = rand(rng, Cylindrical{NoDatum})
