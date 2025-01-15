# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    PolarStereographicB{latF, lngₒ, Datum,Shift}

Polar Stereographic CRS Variant B with latitude of standard parallel `latF` and  longitude of 
origin `lngₒ` in degrees, `Datum` and `Shift`. Latitude of origin is taken to be ±90°,
with the sign matching the sign of `latF`.

See conversion formulas at [epsg.org](https://epsg.org/coord-operation-method_9829/Polar-Stereographic-variant-B.html)
and in [EPSG guidance note #7-2 (pdf)](https://www.iogp.org/wp-content/uploads/2019/09/373-07-02.pdf).
"""
struct PolarStereographicB{latF,lngₒ,Datum,Shift,M<:Met} <: Projected{Datum,Shift}
  x::M
  y::M
end

PolarStereographicB{latF,lngₒ,Datum,Shift}(x::M, y::M) where {latF,lngₒ,Datum,Shift,M<:Met} =
  PolarStereographicB{latF,lngₒ,Datum,Shift,float(M)}(x, y)
PolarStereographicB{latF,lngₒ,Datum,Shift}(x::Met, y::Met) where {latF,lngₒ,Datum,Shift} =
  PolarStereographicB{latF,lngₒ,Datum,Shift}(promote(x, y)...)
PolarStereographicB{latF,lngₒ,Datum,Shift}(x::Len, y::Len) where {latF,lngₒ,Datum,Shift} =
  PolarStereographicB{latF,lngₒ,Datum,Shift}(uconvert(m, x), uconvert(m, y))
PolarStereographicB{latF,lngₒ,Datum,Shift}(x::Number, y::Number) where {latF,lngₒ,Datum,Shift} =
  PolarStereographicB{latF,lngₒ,Datum,Shift}(addunit(x, m), addunit(y, m))

PolarStereographicB{latF,lngₒ,Datum}(args...) where {latF,lngₒ,Datum} =
  PolarStereographicB{latF,lngₒ,Datum,Shift()}(args...)

PolarStereographicB{latF,lngₒ}(args...) where {latF,lngₒ} = PolarStereographicB{latF,lngₒ,WGS84Latest}(args...)

Base.convert(
  ::Type{PolarStereographicB{latF,lngₒ,Datum,Shift,M}},
  coords::PolarStereographicB{latF,lngₒ,Datum,Shift}
) where {latF,lngₒ,Datum,Shift,M} = PolarStereographicB{latF,lngₒ,Datum,Shift,M}(coords.x, coords.y)

constructor(::Type{<:PolarStereographicB{latF,lngₒ,Datum,Shift}}) where {latF,lngₒ,Datum,Shift} =
  PolarStereographicB{latF,lngₒ,Datum,Shift}

lentype(::Type{<:PolarStereographicB{latF,lngₒ,Datum,Shift,M}}) where {latF,lngₒ,Datum,Shift,M} = M

==(
  coords₁::PolarStereographicB{latF,lngₒ,Datum,Shift},
  coords₂::PolarStereographicB{latF,lngₒ,Datum,Shift}
) where {latF,lngₒ,Datum,Shift} = coords₁.x == coords₂.x && coords₁.y == coords₂.y

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
# TODO: can FE and FN (false east and north) be removed by composing with a shift?
function formulas(::Type{<:PolarStereographicB{latF,lngₒ,Datum}}, ::Type{T}) where {latF,lngₒ,Datum,T}
  ϕF = T(ustrip(deg2rad(latF)))
  λₒ = T(ustrip(deg2rad(lngₒ)))

  🌎 = ellipsoid(Datum)

  ecc = eccentricity(🌎)
  semimajoraxis = majoraxis(🌎)
  a = ustrip(uconvert(m, semimajoraxis)) # TODO do we need to enforce a type here?

  # TODO: remove these? FE and FN can be covered by Shift I think
  FE = 0
  FN = 0

  # TODO: NOTE: are there docs on what fx and fy are supposed to be?
  # that'd be nice info to add into a guide for contribution
  function fx(λ, ϕ)
    # TODO: this is only for the south pole case
    tF = tan(π / 4 + ϕF / 2) / (((1 + ecc * sin(ϕF)) / (1 - ecc * sin(ϕF)))^(ecc / 2))
    mF = cos(ϕF) / sqrt(1 - ecc^2 * sin(ϕF)^2)
    kO = mF * (sqrt((1 + ecc)^(1 + ecc) * (1 - ecc)^(1 - ecc))) / (2 * tF)

    θ = λ - λₒ
    # calculate t, ρ, E, and N as in Variant A south pole case:
    t = tan(π / 4 + ϕ / 2) / (((1 + ecc * sin(ϕ)) / (1 - ecc * sin(ϕ)))^(ecc / 2))
    # Geomatics Guidance Note number 7, part 2 defines
    #   ρ = 2 * a * kO * ... but it seems like CoordRefSystems.jl
    # multiplies the result of fx and fy by a, so a is not included in
    # the definition of ρ here
    ρ = 2 * kO * t / sqrt((1 + ecc)^(1 + ecc) * (1 - ecc)^(1 - ecc))
    dE = ρ * sin(θ)
    dN = ρ * cos(θ)

    @debug "Values" tF mF kO t ρ

    E = FE + dE
    N = FN + dN

    E
  end

  function fy(λ, ϕ)
    # TODO: this is only for the south pole case
    tF = tan(π / 4 + ϕF / 2) / (((1 + ecc * sin(ϕF)) / (1 - ecc * sin(ϕF)))^(ecc / 2))
    mF = cos(ϕF) / sqrt(1 - ecc^2 * sin(ϕF)^2)
    kO = mF * (sqrt((1 + ecc)^(1 + ecc) * (1 - ecc)^(1 - ecc))) / (2 * tF)

    θ = λ - λₒ
    # calculate t, ρ, E, and N as in Variant A south pole case:
    t = tan(π / 4 + ϕ / 2) / (((1 + ecc * sin(ϕ)) / (1 - ecc * sin(ϕ)))^(ecc / 2))
    ρ = 2 * kO * t / sqrt((1 + ecc)^(1 + ecc) * (1 - ecc)^(1 - ecc))
    dE = ρ * sin(θ)
    dN = ρ * cos(θ)

    E = FE + dE
    N = FN + dN

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
function backward(::Type{<:PolarStereographicB{latF,lngₒ,Datum}}, x, y) where {latF,lngₒ,Datum}
  ϕF = oftype(x, ustrip(deg2rad(latF)))
  λₒ = oftype(x, ustrip(deg2rad(lngₒ)))

  🌎 = ellipsoid(Datum)
  e = eccentricity(🌎)
  semimajoraxis = majoraxis(🌎)
  a = ustrip(uconvert(m, semimajoraxis)) # TODO do we need to enforce a type here? `oftype` is used above

  E = x * a
  N = y * a

  @debug "Inputs" x y E N

  # TODO: remove these? FE and FN can be covered by Shift I think
  FE = 0
  FN = 0

  # TODO: this is only for the south pole case
  tF = tan(π / 4 + ϕF / 2) / (((1 + e * sin(ϕF)) / (1 - e * sin(ϕF)))^(e / 2))
  mF = cos(ϕF) / sqrt(1 - e^2 * sin(ϕF)^2)
  kO = mF * (sqrt((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * tF)

  # EPSG guidance note #7-2 uses a variable 'capital chi' (\Chi, Χ) but I'm using just 
  # a 'capital X' (X) because they looks the same in my font
  ρ′ = sqrt((E - FE)^2 + (N - FN)^2)
  t′ = ρ′ * sqrt(((1 + e)^(1 + e) * (1 - e)^(1 - e))) / (2 * a * kO)
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
  # TODO: the atan can be dropped if FE and FN are zero, which might
  #   be possible if Shift takes care of FE and FN
  λ = λₒ + atan(E - FE, N - FN)

  λ, ϕ
end

# ----------
# FALLBACKS
# ----------

indomain(::Type{PolarStereographicB{latF,lngₒ}}, coords::CRS{Datum}) where {latF,lngₒ,Datum} =
  indomain(PolarStereographicB{latF,lngₒ,Datum}, coords)

Base.convert(::Type{PolarStereographicB{latF,lngₒ}}, coords::CRS{Datum}) where {latF,lngₒ,Datum} =
  convert(PolarStereographicB{latF,lngₒ,Datum}, coords)
