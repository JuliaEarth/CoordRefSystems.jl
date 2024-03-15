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
    UTM{H,Zone,Datum}

UTM (Universal Transverse Mercator) CRS in north hemisphere `H` 
with `Zone` (1 ≤ Zone ≤ 60) and a given `Datum`.
"""
struct UTM{H,Zone,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
  function UTM{H,Zone,Datum}(x::M, y::M) where {H,Zone,Datum,M<:Met}
    if !(1 ≤ Zone ≤ 60)
      throw(ArgumentError("the UTM zone must be an integer between 1 and 60"))
    end
    new{H,Zone,Datum,float(M)}(x, y)
  end
end

UTM{H,Zone,Datum}(x::Met, y::Met) where {H,Zone,Datum} = UTM{H,Zone,Datum}(promote(x, y)...)
UTM{H,Zone,Datum}(x::Len, y::Len) where {H,Zone,Datum} = UTM{H,Zone,Datum}(uconvert(u"m", x), uconvert(u"m", y))
UTM{H,Zone,Datum}(x::Number, y::Number) where {H,Zone,Datum} = UTM{H,Zone,Datum}(addunit(x, u"m"), addunit(y, u"m"))

UTM{H,Zone}(args...) where {H,Zone} = UTM{H,Zone,WGS84Latest}(args...)

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

function formulas(C::Type{<:UTM{H,Zone,Datum}}, ::Type{T}) where {H,Zone,Datum,T}
  a = numconvert(T, majoraxis(ellipsoid(Datum)))
  xₒ = falseeasting(T, C) / a
  yₒ = falsenorthing(T, C) / a

  TM = totm(C)
  tmfx, tmfy = formulas(TM, T)

  fx(λ, ϕ) = tmfx(λ, ϕ) + xₒ
  fy(λ, ϕ) = tmfy(λ, ϕ) + yₒ

  fx, fy
end

function Base.convert(C::Type{UTM{H,Zone,Datum}}, coords::LatLon{Datum}) where {H,Zone,Datum}
  T = numtype(coords.lon)
  xₒ = falseeasting(T, C)
  yₒ = falsenorthing(T, C)

  TM = totm(C)
  tm = convert(TM, coords)

  C(tm.x + xₒ, tm.y + yₒ)
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {H,Zone,Datum,C<:UTM{H,Zone,Datum}}
  T = numtype(coords.x)
  xₒ = falseeasting(T, C)
  yₒ = falsenorthing(T, C)

  TM = totm(C)
  tm = TM(coords.x - xₒ, coords.y - yₒ)

  convert(LatLon{Datum}, tm)
end

# -----------------
# HELPER FUNCTIONS
# -----------------

function totm(::Type{<:UTM{H,Zone,Datum}}) where {H,Zone,Datum}
  lonₒ = (6 * Zone - 183) * u"°"
  TransverseMercator{0.9996,0.0u"°",lonₒ,Datum}
end

falseeasting(::Type{T}, ::Type{<:UTM}) where {T} = T(500000) * u"m"

falsenorthing(::Type{T}, ::Type{<:UTM{North}}) where {T} = T(0) * u"m"
falsenorthing(::Type{T}, ::Type{<:UTM{South}}) where {T} = T(10000000) * u"m"
