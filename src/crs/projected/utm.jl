# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    UTM{IsNorth,Zone,Datum}

UTM (Universal Transverse Mercator) CRS in north hemisphere (`IsNorth = true`)
or south hemisphere (`IsNorth = false`) with `Zone` (1 ≤ Zone ≤ 60) and a given `Datum`.
"""
struct UTM{IsNorth,Zone,Datum,M<:Met} <: Projected{Datum}
  x::M
  y::M
  function UTM{IsNorth,Zone,Datum}(x::M, y::M) where {IsNorth,Zone,Datum,M<:Met}
    if !(1 ≤ Zone ≤ 60)
      throw(ArgumentError("the UTM zone must be an integer between 1 and 60"))
    end
    new{IsNorth,Zone,Datum,float(M)}(x, y)
  end
end

UTM{IsNorth,Zone,Datum}(x::Met, y::Met) where {IsNorth,Zone,Datum} = UTM{IsNorth,Zone,Datum}(promote(x, y)...)
UTM{IsNorth,Zone,Datum}(x::Len, y::Len) where {IsNorth,Zone,Datum} =
  UTM{IsNorth,Zone,Datum}(uconvert(u"m", x), uconvert(u"m", y))
UTM{IsNorth,Zone,Datum}(x::Number, y::Number) where {IsNorth,Zone,Datum} =
  UTM{IsNorth,Zone,Datum}(addunit(x, u"m"), addunit(y, u"m"))

UTM{IsNorth,Zone}(args...) where {IsNorth,Zone} = UTM{IsNorth,Zone,WGS84Latest}(args...)

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
const UTMNoth{Zone,Datum} = UTM{true,Zone,Datum}

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
const UTMSouth{Zone,Datum} = UTM{false,Zone,Datum}

function totm(::Type{<:UTM{IsNorth,Zone,Datum}}) where {IsNorth,Zone,Datum}
  lonₒ = (6 * Zone - 183) * u"°"
  TransverseMercator{0.9996,0.0u"°",lonₒ,Datum}
end

function formulas(C::Type{<:UTM{IsNorth,Zone,Datum}}, ::Type{T}) where {IsNorth,Zone,Datum,T}
  a = majoraxis(ellipsoid(Datum))
  # unscaled false easting and false northing
  xₒ = T(500000u"m" / a)
  yₒ = IsNorth ? T(0) : T(10000000u"m" / a)

  TM = totm(C)
  tmfx, tmfy = formulas(TM, T)

  fx(λ, ϕ) = tmfx(λ, ϕ) + xₒ
  fy(λ, ϕ) = tmfy(λ, ϕ) + yₒ

  fx, fy
end

function Base.convert(C::Type{UTM{IsNorth,Zone,Datum}}, coords::LatLon{Datum}) where {IsNorth,Zone,Datum}
  T = numtype(coords.lon)
  xₒ = T(500000) * u"m"
  yₒ = IsNorth ? T(0) * u"m" : T(10000000) * u"m"

  TM = totm(C)
  tm = convert(TM, coords)

  C(tm.x + xₒ, tm.y + yₒ)
end

function Base.convert(::Type{LatLon{Datum}}, coords::C) where {IsNorth,Zone,Datum,C<:UTM{IsNorth,Zone,Datum}}
  T = numtype(coords.x)
  xₒ = T(500000) * u"m"
  yₒ = IsNorth ? T(0) * u"m" : T(10000000) * u"m"

  TM = totm(C)
  tm = TM(coords.x - xₒ, coords.y - yₒ)

  convert(LatLon{Datum}, tm)
end
