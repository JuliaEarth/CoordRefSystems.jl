# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# helper type alias
const Len{T} = Quantity{T,u"𝐋"}
const Met{T} = Quantity{T,u"𝐋",typeof(m)}
const Deg{T} = Quantity{T,NoDims,typeof(°)}
const Rad{T} = Quantity{T,NoDims,typeof(rad)}

# degrees, minutes, seconds format
struct DMS{T<:Real} <: Number
  deg::Int
  minute::Int
  sec::T
end

# converting DMS and Deg
function Base.convert(::Type{Deg}, x::DMS)
  decimal_degree = x.deg + (x.minute / 60) + (x.sec / 3600)
  Deg(decimal_degree)
end

function Base.convert(::Type{DMS}, x::T) where {T<:Deg}
  # Gemini:
  # Extract the raw numeric value from the Unitful Quantity
  val = ustrip(x)

  # Formula: https://en.wikipedia.org/wiki/Geographic_coordinate_conversion
  # Reference proj: https://github.com/OSGeo/PROJ/blob/5c64452ecd74a99e05556d1f4e9c1d0af1ed06b7/src/rtodms.cpp#L38
  # Work with absolute value for components, sign is typically handled 
  # by the parent LatLon struct or hemisphere chars
  abs_val = abs(val)

  floor_deg = floor(Int, abs_val)
  minute = floor(Int, (abs_val - floor_deg) * 60)
  sec = (abs_val - floor_deg) * 3600 - 60 * minute

  deg = val > 0 ? floor_deg : -floor_deg

  return DMS(deg, minute, sec)
end
# DMS(deg::Int, minute::Int, sec::T) where {T<:Real} = DMS{T}(deg, minute, sec)

# show the DMS in DMS format
function Base.show(io::IO, x::DMS)
  d = x.deg
  m = x.minute
  s = x.sec
  print(io, "$(d)° $(m)′ $(s)″")
end

"""
    asdeg(x)

Return `x` if it is in degrees, add the degree unit if it is a number,
and throw an error otherwise.
"""
asdeg(x::Deg) = x
asdeg(x::Number) = x * °
asdeg(::Quantity) = error("invalid unit, please pass a value in degrees")

"""
    asmet(x)

Return `x` if it is in meters, add the meter unit if it is a number,
and throw an error otherwise.
"""
asmet(x::Met) = x
asmet(x::Number) = x * m
asmet(::Quantity) = error("invalid unit, please pass a value in meters")

"""
    atol(x)

Absolute tolerance for approximate comparison.
"""
atol(x) = atol(typeof(x))

atol(::Type{T}) where {T<:Number} = eps(T)^(3 // 4)

atol(::Type{<:Len{T}}) where {T} = atol(T) * 6378137m
atol(::Type{<:Deg{T}}) where {T} = sqrt(eps(T(360))) * °
atol(::Type{<:Rad{T}}) where {T} = sqrt(eps(T(2π))) * rad

"""
    rtol(x)

Relative tolerance for approximate comparison.
"""
rtol(x) = rtol(typeof(x))

rtol(::Type{T}) where {T<:Number} = sqrt(eps(T))

rtol(::Type{<:Len{T}}) where {T} = rtol(T)
rtol(::Type{<:Deg{T}}) where {T} = zero(T)
rtol(::Type{<:Rad{T}}) where {T} = zero(T)

"""
    addunit(x, u)

Adds the unit only if the argument is not a quantity, otherwise an error is thrown.
"""
addunit(x::Number, u) = x * u
addunit(x::Quantity, u) = throw(ArgumentError("invalid units for coordinates, please check the documentation"))

"""
    numconvert(T, x)

Converts the number type of quantity `x` to `T`.
"""
numconvert(::Type{T}, x::Quantity{S,D,U}) where {T,S,D,U} = convert(Quantity{T,D,U}, x)

"""
    atanpos(x, y)

Adjusts the interval of values returned by the `atan(y, x)` function from `[-π,π]` to `[0,2π]`.
"""
function atanpos(y, x)
  α = atan(y, x)
  ifelse(α ≥ zero(α), α, α + oftype(α, 2π))
end

"""
    asinclamp(x)

Adjust `x` to the range `[-1,1]` to handle floating-point errors.
"""
asinclamp(x) = asin(clamp(x, -one(x), one(x)))

"""
    checklat(lat)

Checks if the latitude is in the range `[-90°,90°]`.
"""
function checklat(lat)
  if abs(lat) > 90°
    throw(ArgumentError("the latitude must be in the range [-90°,90°], while $lat was provided"))
  end
  lat
end

"""
    fixlon(lon)

Fix the longitude to be in the range `[-180°,180°]`.
"""
fixlon(lon) = ifelse(abs(lon) == 180°, lon, rem(lon, 360°, RoundNearest))

"""
    phi2lat(ϕ)

Converts the unitless `ϕ` to latitude and adjusts it to the range `[-90,90]`
to fix floating-point errors.
"""
phi2lat(ϕ) = clamp(rad2deg(ϕ) * °, -90°, 90°)

"""
    lam2lon(λ)

Converts the unitless `λ` to longitude.
"""
lam2lon(λ) = rad2deg(λ) * °

"""
    newton(f, df, xₒ; maxiter=10, tol=atol(xₒ))

Newton's method approximates the root of the function `f` using its derivative `df`,
initial guess `xₒ`, `maxiter` iterations, and tolerance `tol`.
"""
function newton(f, df, xₒ; maxiter=10, tol=atol(xₒ))
  xₙ₊₁ = xₙ = xₒ
  for _ in 1:maxiter
    xₙ₊₁ = xₙ - f(xₙ) / df(xₙ)
    if abs(xₙ₊₁ - xₙ) ≤ tol
      break
    end
    xₙ = xₙ₊₁
  end
  xₙ₊₁
end

"""
    projinv(fx, fy, x, y, λₒ, ϕₒ; maxiter=10, tol=atol(x))

Approximates the inverse of a projection with the Newton-Raphson method
using its forward formulas `fx` and `fy`, `x` and `y` values, initial
guess `λₒ` and `ϕₒ`, `maxiter` iterations, and tolerance `tol`.

## References

* Cengizhan Ipbuker and İbrahim Öztuğ Bildirici. 2002. [A GENERAL ALGORITHM FOR THE INVERSE TRANSFORMATION OF MAP PROJECTIONS USING JACOBIAN
  MATRICES](https://www.researchgate.net/publication/241170163_A_GENERAL_ALGORITHM_FOR_THE_INVERSE_TRANSFORMATION_OF_MAP_PROJECTIONS_USING_JACOBIAN_MATRICES)
"""
function projinv(fx, fy, x, y, λₒ, ϕₒ; maxiter=10, tol=atol(x))
  # deviation from target
  f₁(λ, ϕ) = fx(λ, ϕ) - x
  f₂(λ, ϕ) = fy(λ, ϕ) - y

  # corresponding gradient
  ∇f₁(λ, ϕ) = gradient(u -> f₁(u[1], u[2]), SVector(λ, ϕ))
  ∇f₂(λ, ϕ) = gradient(u -> f₂(u[1], u[2]), SVector(λ, ϕ))

  # Newton-Rhapson iteration
  λᵢ₊₁ = λᵢ = λₒ
  ϕᵢ₊₁ = ϕᵢ = ϕₒ
  for _ in 1:maxiter
    v₁ = f₁(λᵢ, ϕᵢ)
    v₂ = f₂(λᵢ, ϕᵢ)

    df₁dλ, df₁dϕ = ∇f₁(λᵢ, ϕᵢ)
    df₂dλ, df₂dϕ = ∇f₂(λᵢ, ϕᵢ)

    den = (df₁dϕ * df₂dλ - df₂dϕ * df₁dλ)
    λᵢ₊₁ = λᵢ - (v₂ * df₁dϕ - v₁ * df₂dϕ) / den
    ϕᵢ₊₁ = ϕᵢ - (v₁ * df₂dλ - v₂ * df₁dλ) / den

    if abs(λᵢ₊₁ - λᵢ) ≤ tol && abs(ϕᵢ₊₁ - ϕᵢ) ≤ tol
      break
    end

    λᵢ = λᵢ₊₁
    ϕᵢ = ϕᵢ₊₁
  end

  λᵢ₊₁, ϕᵢ₊₁
end

"""
    ellipfromaf⁻¹(a, f⁻¹)

Calculates the parameters of the ellipsoid with a given
major axis `a` and flattening inverse `f⁻¹`.
"""
function ellipfromaf⁻¹(a, f⁻¹)
  f = inv(f⁻¹)
  b = a * (1 - f)
  e² = (2 - f) / f⁻¹
  e = √e²
  (; a, b, e, e², f, f⁻¹)
end

"""
    ellipfromab(a, b)

Calculates the parameters of the ellipsoid with a given
major axis `a` and minor axis `b`.
"""
function ellipfromab(a, b)
  f = (a - b) / a
  f⁻¹ = inv(f)
  e² = (2 - f) / f⁻¹
  e = √e²
  (; a, b, e, e², f, f⁻¹)
end
