# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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

Random.rand(rng::Random.AbstractRNG, ::Type{Polar{Datum}}) where {Datum} = Polar{Datum}(rand(rng), 2π * rand(rng))

Random.rand(rng::Random.AbstractRNG, ::Type{Polar}) = rand(rng, Polar{NoDatum})
