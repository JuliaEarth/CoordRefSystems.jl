# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# helper type alias
const Len{T} = Quantity{T,u"𝐋"}
const Met{T} = Quantity{T,u"𝐋",typeof(m)}
const Deg{T} = Quantity{T,NoDims,typeof(°)}
const Rad{T} = Quantity{T,NoDims,typeof(rad)}

asdeg(x::Deg) = x
asdeg(x::Number) = x * °
asdeg(::Quantity) = error("invalid unit, please pass a value in degrees")

asmet(x::Met) = x
asmet(x::Number) = x * m
asmet(::Quantity) = error("invalid unit, please pass a value in meters")

"""
    atol(T)
    atol(x::T)

Absolute tolerance used in source code for approximate
comparison with numbers of type `T`.
"""
atol(x) = atol(typeof(x))
atol(::Type{Float64}) = 1e-10
atol(::Type{Float32}) = 1.0f-5

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

Fix the longitude to be in the range `(-180°,180°]`.
"""
function fixlon(lon)
  lon = rem(lon, 360°, RoundNearest)
  ifelse(lon == -180°, oftype(lon, 180°), lon)
end

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
using its forward formulas `fx` and `fy`, `x` and `y` values, 
initial guess `λₒ` and `ϕₒ`, `maxiter` iterations, and tolerance `tol`.

## References

* Cengizhan Ipbuker and İbrahim Öztuğ Bildirici. 2002. [A GENERAL ALGORITHM FOR THE INVERSE TRANSFORMATION OF MAP PROJECTIONS USING JACOBIAN 
  MATRICES](https://www.researchgate.net/publication/241170163_A_GENERAL_ALGORITHM_FOR_THE_INVERSE_TRANSFORMATION_OF_MAP_PROJECTIONS_USING_JACOBIAN_MATRICES)
"""
function projinv(fx, fy, x, y, λₒ, ϕₒ; maxiter=10, tol=atol(x))
  f₁(λ, ϕ) = fx(λ, ϕ) - x
  f₂(λ, ϕ) = fy(λ, ϕ) - y
  λᵢ₊₁ = λᵢ = λₒ
  ϕᵢ₊₁ = ϕᵢ = ϕₒ

  for _ in 1:maxiter
    v₁ = f₁(λᵢ, ϕᵢ)
    v₂ = f₂(λᵢ, ϕᵢ)
    df₁dλ, df₁dϕ = gradient(f₁, λᵢ, ϕᵢ)
    df₂dλ, df₂dϕ = gradient(f₂, λᵢ, ϕᵢ)

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
