# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    PolarStereographicB{lat₁, Datum,Shift}

Polar Stereographic CRS Variant B with latitude of standard parallel `lat₁`, `Datum`, and `Shift`. Latitude of origin is taken to be ±90°,
with the sign matching the sign of `lat₁`. Longitude of origin is taken to be 0° and can be changed with a `Shift`.

See conversion formulas at [epsg.org](https://epsg.org/coord-operation-method_9829/Polar-Stereographic-variant-B.html)
and in [EPSG guidance note #7-2 (pdf)](https://www.iogp.org/wp-content/uploads/2019/09/373-07-02.pdf).
"""
struct PolarStereographicB{lat₁,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

PolarStereographicB{lat₁,Datum,Shift}(x::M, y::M) where {lat₁,Datum,Shift,M<:Met} =
  PolarStereographicB{lat₁,Datum,Shift,float(M)}(x, y)
PolarStereographicB{lat₁,Datum,Shift}(x::Met, y::Met) where {lat₁,Datum,Shift} =
  PolarStereographicB{lat₁,Datum,Shift}(promote(x, y)...)
PolarStereographicB{lat₁,Datum,Shift}(x::Len, y::Len) where {lat₁,Datum,Shift} =
  PolarStereographicB{lat₁,Datum,Shift}(uconvert(m, x), uconvert(m, y))
PolarStereographicB{lat₁,Datum,Shift}(x::Number, y::Number) where {lat₁,Datum,Shift} =
  PolarStereographicB{lat₁,Datum,Shift}(addunit(x, m), addunit(y, m))

PolarStereographicB{lat₁,Datum}(args...) where {lat₁,Datum} = PolarStereographicB{lat₁,Datum,Shift()}(args...)

PolarStereographicB{lat₁}(args...) where {lat₁} = PolarStereographicB{lat₁,WGS84Latest}(args...)

Base.convert(
  ::Type{PolarStereographicB{lat₁,Datum,Shift,M}},
  coords::PolarStereographicB{lat₁,Datum,Shift}
) where {lat₁,Datum,Shift,M} = PolarStereographicB{lat₁,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:PolarStereographicB{lat₁,Datum,Shift}}) where {lat₁,Datum,Shift} =
  PolarStereographicB{lat₁,Datum,Shift}

lentype(::Type{<:PolarStereographicB{lat₁,Datum,Shift,M}}) where {lat₁,Datum,Shift,M} = M

==(
  coords₁::PolarStereographicB{lat₁,Datum,Shift},
  coords₂::PolarStereographicB{lat₁,Datum,Shift}
) where {lat₁,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

# ------------
# CONVERSIONS
# ------------

#=
Tested against the manual with:
julia> convert(CoordRefSystems.PolarStereographicB{-71, 70, WGS84Latest, CoordRefSystems.Shift(xₒ=6e6m, yₒ=6e6m)}, LatLon(-75,120))
┌ Debug: Values
│   tF = 0.16840732452916302
│   mF = 0.32654678137878085
│   kO = 0.9727690128917972
│   t = 0.13250834771195819
│   ρ = 0.25693760394410403
└ @ CoordRefSystems ~/.julia/dev/CoordRefSystems/src/crs/projected/polarstereographic.jl:120
PolarStereographicB{WGS84Latest} coordinates with lonₒ: 0.0°, xₒ: 6.0e6 m, yₒ: 6.0e6 m
├─ x: 7.255380793258386e6 m
└─ y: 7.053389560610154e6 m
=#
function formulas(::Type{<:PolarStereographicB{lat₁,Datum}}, ::Type{T}) where {lat₁,Datum,T}
  ϕF = T(ustrip(deg2rad(lat₁)))

  🌎 = ellipsoid(Datum)

  e = T(eccentricity(🌎))
  π = T(pi)

  function fx(λ, ϕ)
    # TODO: this is only for the south pole case
    tF = tan(π / 4 + ϕF / 2) / (((1 + e * sin(ϕF)) / (1 - e * sin(ϕF)))^(e / 2))
    mF = cos(ϕF) / sqrt(1 - e^2 * sin(ϕF)^2)
    kO = mF * (sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * tF)

    θ = λ
    # calculate t, ρ, E, and N as in Variant A south pole case:
    t = tan(π / 4 + ϕ / 2) / (((1 + e * sin(ϕ)) / (1 - e * sin(ϕ)))^(e / 2))
    ρ = 2 * kO * t / sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e)) # factor of `a` is handled elsewhere
    dE = ρ * sin(θ)
    dN = ρ * cos(θ)

    @debug "Values" tF mF kO t ρ

    # takes FE and FN to be zero
    E = dE
    N = dN

    E
  end

  function fy(λ, ϕ)
    # TODO: this is only for the south pole case
    tF = tan(π / 4 + ϕF / 2) / (((1 + e * sin(ϕF)) / (1 - e * sin(ϕF)))^(e / 2))
    mF = cos(ϕF) / sqrt(1 - e^2 * sin(ϕF)^2)
    kO = mF * (sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * tF)

    θ = λ
    # calculate t, ρ, E, and N as in Variant A south pole case:
    t = tan(π / 4 + ϕ / 2) / (((1 + e * sin(ϕ)) / (1 - e * sin(ϕ)))^(e / 2))
    ρ = 2 * kO * t / sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))
    dE = ρ * sin(θ)
    dN = ρ * cos(θ)

    # takes FE and FN to be zero
    E = dE
    N = dN

    N
  end
  fx, fy
end

#=
test with:
julia> convert(LatLon, CoordRefSystems.PolarStereographicB{-71, 70, WGS84Latest, CoordRefSystems.Shift(xₒ=6e6m, yₒ=6e6m)}(7255380.79, 7053389.56))
┌ Debug: Inputs
│   x = 0.19682562321881766
│   y = 0.16515630818215407
│   E = 1.25538079e6
│   N = 1.0533895599999996e6
└ @ CoordRefSystems ~/.julia/dev/CoordRefSystems/src/crs/projected/polarstereographic.jl:165
┌ Debug: Intermediates
│   tF = 0.16840732452916302
│   mF = 0.32654678137878085
│   kO = 0.9727690128917972
│   ρ′ = 1.6387832355189677e6
│   t′ = 0.13250834747841927
│   X = -1.3073145883173596
└ @ CoordRefSystems ~/.julia/dev/CoordRefSystems/src/crs/projected/polarstereographic.jl:182
GeodeticLatLon{WGS84Latest} coordinates
├─ lat: -75.00000002614524°
└─ lon: 119.9999999431146°
=#
function backward(::Type{<:PolarStereographicB{lat₁,Datum}}, x, y) where {lat₁,Datum}
  T = typeof(x)
  ϕF = T(ustrip(deg2rad(lat₁)))

  🌎 = ellipsoid(Datum)
  e = T(eccentricity(🌎))
  semimajoraxis = majoraxis(🌎)
  π = T(pi)

  E = x
  N = y

  @debug "Inputs" x y E N

  # nonzero FE and FN are covered by `shift` operations
  FE = 0
  FN = 0

  # TODO: this is only for the south pole case
  tF = tan(π / 4 + ϕF / 2) / (((1 + e * sin(ϕF)) / (1 - e * sin(ϕF)))^(e / 2))
  mF = cos(ϕF) / sqrt(1 - e^2 * sin(ϕF)^2)
  kO = mF * (sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * tF)

  # EPSG guidance note #7-2 uses a variable 'capital chi' (\Chi, Χ) but I'm using just 
  # a 'capital X' (X) because they looks the same in my font
  ρ′ = sqrt(E^2 + N^2)
  t′ = ρ′ * sqrt(((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * kO)
  X = 2atan(t′) - π / 2 # south pole case. TODO: add north pole case

  @debug "Intermediates" tF mF kO ρ′ t′ X

  # ϕ and λ are found as for variant A:
  ϕ =
    X +
    (e^2 / 2 + 5e^4 / 24 + e^6 / 12 + 13e^8 / 360) * sin(2X) +
    (7e^4 / 48 + 29e^6 / 240 + 811e^8 / 11520) * sin(4X) +
    (7e^6 / 120 + 81e^8 / 1120) * sin(6X) +
    (4279e^8 / 161280) * sin(8X)
  # south pole case only! TODO add north pole case
  # TODO: the atan can be dropped because FE and FN are zero!
  λ = λₒ + atan(E - FE, N - FN)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{PolarStereographicB{lat₁}}, coords::CRS{Datum}) where {lat₁,Datum} =
  indomain(PolarStereographicB{lat₁,Datum}, coords)

Base.convert(::Type{PolarStereographicB{lat₁}}, coords::CRS{Datum}) where {lat₁,Datum} =
  convert(PolarStereographicB{lat₁,Datum}, coords)
