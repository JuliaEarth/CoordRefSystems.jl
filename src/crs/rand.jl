# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    rand([rng], C)

Generate a random coordinate of type `C`,
optionally passing a random number generator `rng`.

# Examples

```julia
rand(LatLon)
rand(Cartesian)
```
"""
Random.rand(C::Type{<:CRS}; kwargs...) = rand(Random.default_rng(), C; kwargs...)
Random.rand(rng::Random.AbstractRNG, C::Type{<:CRS}) = _rand(rng, C)

"""
    rand([rng], C, n)

Generate a vector of `n` random coordinates of type `C`,
optionally passing a random number generator `rng`.

# Examples

```julia
rand(LatLon, 10)
rand(Cartesian, 10)
```
"""
Random.rand(::Type{C}, n::Int; kwargs...) where C <: CRS = rand(Random.default_rng(), C, n; kwargs...)
Random.rand(rng::Random.AbstractRNG, ::Type{C}, n::Int; kwargs...) where C <: CRS= [rand(rng, C; kwargs...) for _ in 1:n]

# ----------------
# IMPLEMENTATIONS
# ----------------

_rand(rng::Random.AbstractRNG, ::Type{C}) where C <: Union{LatLon, GeocentricLatLon, AuthalicLatLon} =
  C(-90° + 180° * rand(rng), -180° + 360° * rand(rng))

_rand(rng::Random.AbstractRNG, ::Type{C}) where C <: LatLonAlt =
  C(-90° + 180° * rand(rng), -180° + 360° * rand(rng), rand(rng) * 1m)