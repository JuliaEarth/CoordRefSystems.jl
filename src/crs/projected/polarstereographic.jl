# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Variant

Variant of the polar stereographic coordinate reference system.

See also [`A`](@ref), [`B`](@ref), [`C`](@ref).
"""
abstract type Variant end

"""
    A

Variant A (i.e. for variants of the PolarStereographic projection).
See also [`Variant`](@ref)
"""
abstract type VariantA <: Variant end

"""
    B

Variant B (i.e. for variants of the PolarStereographic projection).
See also [`Variant`](@ref)
"""
abstract type VariantB <: Variant end

"""
    C

Variant C (i.e. for variants of the PolarStereographic projection).
See also [`Variant`](@ref)
"""
abstract type VariantC <: Variant end

"""
    PolarStereographic{Variant,lat₁, Datum,Shift}

Polar Stereographic CRS Variant B with latitude of standard parallel `lat₁`, `Datum`, and `Shift`. Latitude of origin is taken to be ±90°,
with the sign matching the sign of `lat₁`. Longitude of origin is taken to be 0° and can be changed with a `Shift`.

See conversion formulas at [epsg.org](https://epsg.org/coord-operation-method_9829/Polar-Stereographic-variant-B.html)
and in [EPSG guidance note #7-2 (pdf)](https://www.iogp.org/wp-content/uploads/2019/09/373-07-02.pdf).
"""
struct PolarStereographic{Variant,lat₁,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

PolarStereographic{Variant,lat₁,Datum,Shift}(x::M, y::M) where {Variant,lat₁,Datum,Shift,M<:Met} =
  PolarStereographic{Variant,lat₁,Datum,Shift,float(M)}(x, y)
PolarStereographic{Variant,lat₁,Datum,Shift}(x::Met, y::Met) where {Variant,lat₁,Datum,Shift} =
  PolarStereographic{Variant,lat₁,Datum,Shift}(promote(x, y)...)
PolarStereographic{Variant,lat₁,Datum,Shift}(x::Len, y::Len) where {Variant,lat₁,Datum,Shift} =
  PolarStereographic{Variant,lat₁,Datum,Shift}(uconvert(m, x), uconvert(m, y))
PolarStereographic{Variant,lat₁,Datum,Shift}(x::Number, y::Number) where {Variant,lat₁,Datum,Shift} =
  PolarStereographic{Variant,lat₁,Datum,Shift}(addunit(x, m), addunit(y, m))

PolarStereographic{Variant,lat₁,Datum}(args...) where {Variant,lat₁,Datum} =
  PolarStereographic{Variant,lat₁,Datum,Shift()}(args...)

PolarStereographic{Variant,lat₁}(args...) where {Variant,lat₁} = PolarStereographic{Variant,lat₁,WGS84Latest}(args...)

Base.convert(
  ::Type{PolarStereographic{Variant,lat₁,Datum,Shift,M}},
  coords::PolarStereographic{Variant,lat₁,Datum,Shift}
) where {Variant,lat₁,Datum,Shift,M} = PolarStereographic{Variant,lat₁,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:PolarStereographic{Variant,lat₁,Datum,Shift}}) where {Variant,lat₁,Datum,Shift} =
  PolarStereographic{Variant,lat₁,Datum,Shift}

lentype(::Type{<:PolarStereographic{Variant,lat₁,Datum,Shift,M}}) where {Variant,lat₁,Datum,Shift,M} = M

==(
  coords₁::PolarStereographic{Variant,lat₁,Datum,Shift},
  coords₂::PolarStereographic{Variant,lat₁,Datum,Shift}
) where {Variant,lat₁,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

"""
    PolarStereographicB{lat₁}(x, y)
    PolarStereographicB{lat₁,Datum}(x, y)

Polar Stereographic CRS Variant B with latitude of standard parallel `lat₁` and `Datum`. Latitude of origin is taken to be ±90°,
with the sign matching the sign of `lat₁`. Longitude of origin is taken to be 0° and can be changed with a `Shift`.

See conversion formulas at [epsg.org](https://epsg.org/coord-operation-method_9829/Polar-Stereographic-variant-B.html)
and in [EPSG guidance note #7-2 (pdf)](https://www.iogp.org/wp-content/uploads/2019/09/373-07-02.pdf).

## Examples

```julia
PolarStereographicB{-71°}(1, 1) # add default units
PolarStereographicB{-71°}(1m, 1m) # integers are converted converted to floats
PolarStereographicB{-71°}(1.0km, 1.0km) # length quantities are converted to meters
PolarStereographicB{-71°}(1.0m, 1.0m)
PolarStereographicB{-71°,WGS84Latest}(1.0m, 1.0m)
```
"""
const PolarStereographicB{lat₁,Datum,Shift} = PolarStereographic{VariantB,lat₁,Datum,Shift}

# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:PolarStereographic{VariantB,lat₁,Datum}}, ::Type{T}) where {lat₁,Datum,T}
  ϕF = T(ustrip(deg2rad(lat₁)))

  🌎 = ellipsoid(Datum)

  e = T(eccentricity(🌎))
  π = T(pi)

  kO = scale_at_natural_origin(ϕF, e)

  function fx(λ, ϕ)
    θ = λ
    # calculate t, ρ, E, and N as in Variant A south pole case:
    t = tan(π / 4 + ϕ / 2) / (((1 + e * sin(ϕ)) / (1 - e * sin(ϕ)))^(e / 2))
    ρ = 2 * kO * t / sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e)) # factor of `a` is handled elsewhere
    dE = ρ * sin(θ)

    @debug "Values" kO t ρ

    # takes FE to be zero
    E = dE

    E
  end

  function fy(λ, ϕ)
    θ = λ
    # calculate t, ρ, E, and N as in Variant A south pole case:
    t = tan(π / 4 + ϕ / 2) / (((1 + e * sin(ϕ)) / (1 - e * sin(ϕ)))^(e / 2))
    ρ = 2 * kO * t / sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))
    dN = ρ * cos(θ)

    # takes FN to be zero
    N = dN

    N
  end
  fx, fy
end

function backward(::Type{<:PolarStereographic{VariantB,lat₁,Datum}}, x, y) where {lat₁,Datum}
  T = typeof(x)
  ϕF = T(ustrip(deg2rad(lat₁)))

  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  π = T(pi)

  E = x
  N = y

  @debug "Inputs" x y E N

  kO = scale_at_natural_origin(ϕF, e)

  # EPSG guidance note #7-2 uses a variable 'capital chi' (\Chi, Χ) but I'm using just 
  # a 'capital X' (X) because they looks the same in my font
  ρ′ = sqrt(E^2 + N^2)
  t′ = ρ′ * sqrt(((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * kO)
  X = 2atan(t′) - π / 2 # south pole case. TODO: add north pole case

  @debug "Intermediates" kO ρ′ t′ X

  # ϕ and λ are found as for variant A:
  ϕ =
    X +
    (e^2 / 2 + 5e^4 / 24 + e^6 / 12 + 13e^8 / 360) * sin(2X) +
    (7e^4 / 48 + 29e^6 / 240 + 811e^8 / 11520) * sin(4X) +
    (7e^6 / 120 + 81e^8 / 1120) * sin(6X) +
    (4279e^8 / 161280) * sin(8X)
  # south pole case only! TODO add north pole case
  λ = atan(E, N)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{PolarStereographic{Variant,lat₁}}, coords::CRS{Datum}) where {Variant,lat₁,Datum} =
  indomain(PolarStereographic{Variant,lat₁,Datum}, coords)

Base.convert(::Type{PolarStereographic{Variant,lat₁}}, coords::CRS{Datum}) where {Variant,lat₁,Datum} =
  convert(PolarStereographic{Variant,lat₁,Datum}, coords)

# -----------------
# HELPER FUNCTIONS
# -----------------

function scale_at_natural_origin(ϕF::T, e::T) where {T}
  π = T(pi)
  # TODO: this is only for the south pole case
  tF = tan(π / 4 + ϕF / 2) / (((1 + e * sin(ϕF)) / (1 - e * sin(ϕF)))^(e / 2))
  mF = cos(ϕF) / sqrt(1 - e^2 * sin(ϕF)^2)
  kO = mF * (sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * tF)

  @assert kO isa T
  kO
end
