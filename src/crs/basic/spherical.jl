# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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

Random.rand(rng::Random.AbstractRNG, ::Type{Spherical{Datum}}) where {Datum} =
  Spherical{Datum}(rand(rng), 2π * rand(rng), 2π * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{Spherical}) = rand(rng, Spherical{NoDatum})
