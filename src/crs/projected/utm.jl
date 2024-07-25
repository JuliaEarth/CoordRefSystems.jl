# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Hemisphere

Hemisphere of the Earth.
"""
abstract type Hemisphere end

"""
    North

Northern hemisphere.
"""
abstract type North <: Hemisphere end

"""
    South

Southern hemisphere.
"""
abstract type South <: Hemisphere end

"""
    UTM{Hemisphere,Zone,Datum}

UTM (Universal Transverse Mercator) CRS in `Hemisphere` with `Zone` (1 ≤ Zone ≤ 60) and a given `Datum`.
"""
struct UTM{Hemisphere,Zone,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
  function UTM{Hemisphere,Zone,Datum,M}(x, y) where {Hemisphere,Zone,Datum,M<:Met}
    if !(1 ≤ Zone ≤ 60)
      throw(ArgumentError("the UTM zone must be an integer between 1 and 60"))
    end
    new{Hemisphere,Zone,Datum,M}(x, y)
  end
end

UTM{Hemisphere,Zone,Datum}(x::M, y::M) where {Hemisphere,Zone,Datum,M<:Met} = UTM{Hemisphere,Zone,Datum,float(M)}(x, y)
UTM{Hemisphere,Zone,Datum}(x::Met, y::Met) where {Hemisphere,Zone,Datum} = UTM{Hemisphere,Zone,Datum}(promote(x, y)...)
UTM{Hemisphere,Zone,Datum}(x::Len, y::Len) where {Hemisphere,Zone,Datum} =
  UTM{Hemisphere,Zone,Datum}(uconvert(u"m", x), uconvert(u"m", y))
UTM{Hemisphere,Zone,Datum}(x::Number, y::Number) where {Hemisphere,Zone,Datum} =
  UTM{Hemisphere,Zone,Datum}(addunit(x, u"m"), addunit(y, u"m"))

UTM{Hemisphere,Zone}(args...) where {Hemisphere,Zone} = UTM{Hemisphere,Zone,WGS84Latest}(args...)

Base.convert(::Type{UTM{Hemisphere,Zone,Datum,M}}, coords::UTM{Hemisphere,Zone,Datum}) where {Hemisphere,Zone,Datum,M} =
  UTM{Hemisphere,Zone,Datum,M}(coords.x, coords.y)

constructor(::Type{<:UTM{Hemisphere,Zone,Datum}}) where {Hemisphere,Zone,Datum} = UTM{Hemisphere,Zone,Datum}

lentype(::Type{<:UTM{Hemisphere,Zone,Datum,M}}) where {Hemisphere,Zone,Datum,M} = M

==(coords₁::UTM{Hemisphere,Zone,Datum}, coords₂::UTM{Hemisphere,Zone,Datum}) where {Hemisphere,Zone,Datum} =
  coords₁.x == coords₂.x && coords₁.y == coords₂.y

"""
    UTMNorth{zone}(x, y)
    UTMNorth{zone,Datum}(x, y)

UTM (Universal Transverse Mercator) North coordinates in length units (default to meter)
with `zone` (1 ≤ zone ≤ 60) and a given `Datum` (default to `WGS84`).

## Examples

```julia
UTMNorth{1}(1, 1) # add default units
UTMNorth{1}(1u"m", 1u"m") # integers are converted converted to floats
UTMNorth{1}(1.0u"km", 1.0u"km") # length quantities are converted to meters
UTMNorth{1}(1.0u"m", 1.0u"m")
UTMNorth{1,WGS84Latest}(1.0u"m", 1.0u"m")
```
"""
const UTMNorth{Zone,Datum} = UTM{North,Zone,Datum}

"""
    UTMSouth{zone}(x, y)
    UTMSouth{zone,Datum}(x, y)

UTM (Universal Transverse Mercator) South coordinates in length units (default to meter)
with `zone` (1 ≤ zone ≤ 60) and a given `Datum` (default to `WGS84`).

## Examples

```julia
UTMSouth{1}(1, 1) # add default units
UTMSouth{1}(1u"m", 1u"m") # integers are converted converted to floats
UTMSouth{1}(1.0u"km", 1.0u"km") # length quantities are converted to meters
UTMSouth{1}(1.0u"m", 1.0u"m")
UTMSouth{1,WGS84Latest}(1.0u"m", 1.0u"m")
```
"""
const UTMSouth{Zone,Datum} = UTM{South,Zone,Datum}

inbounds(C::Type{<:UTM}, λ, ϕ) = inbounds(astm(C), λ, ϕ)

function formulas(C::Type{<:UTM{Hemisphere,Zone,Datum}}, ::Type{T}) where {Hemisphere,Zone,Datum,T}
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  xₒ = falseeasting(T, C) / a
  yₒ = falsenorthing(T, C) / a

  tmfx, tmfy = formulas(astm(C), T)

  fx(λ, ϕ) = tmfx(λ, ϕ) + xₒ
  fy(λ, ϕ) = tmfy(λ, ϕ) + yₒ

  fx, fy
end

function Base.convert(C::Type{UTM{Hemisphere,Zone,Datum}}, coords::LatLon{Datum}) where {Hemisphere,Zone,Datum}
  T = numtype(coords.lon)
  xₒ = falseeasting(T, C)
  yₒ = falsenorthing(T, C)

  tm = convert(astm(C), coords)

  C(tm.x + xₒ, tm.y + yₒ)
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {Hemisphere,Zone,Datum,C<:UTM{Hemisphere,Zone,Datum}}
  T = numtype(coords.x)
  xₒ = falseeasting(T, C)
  yₒ = falsenorthing(T, C)

  tm = astm(C)(coords.x - xₒ, coords.y - yₒ)

  convert(LatLon{Datum}, tm)
end

# ----------
# FALLBACKS
# ----------

Base.convert(::Type{UTM{Hemisphere,Zone}}, coords::LatLon{Datum}) where {Hemisphere,Zone,Datum} =
  convert(UTM{Hemisphere,Zone,Datum}, coords)

Base.convert(::Type{LatLon}, coords::UTM{Hemisphere,Zone,Datum}) where {Hemisphere,Zone,Datum} =
  convert(LatLon{Datum}, coords)

# -----------------
# HELPER FUNCTIONS
# -----------------

function astm(::Type{<:UTM{Hemisphere,Zone,Datum}}) where {Hemisphere,Zone,Datum}
  lonₒ = (6 * Zone - 183) * u"°"
  TransverseMercator{0.9996,0.0u"°",lonₒ,Datum}
end

falseeasting(::Type{T}, ::Type{<:UTM}) where {T} = T(500000) * u"m"

falsenorthing(::Type{T}, ::Type{<:UTM{North}}) where {T} = T(0) * u"m"
falsenorthing(::Type{T}, ::Type{<:UTM{South}}) where {T} = T(10000000) * u"m"
