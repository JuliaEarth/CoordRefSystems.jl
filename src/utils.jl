# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    atol(T)
    atol(x::T)

Absolute tolerance used in algorithms for approximate
comparison with numbers of type `T`. It is used in the
source code in calls to the [`isapprox`](@ref) function:

```julia
isapprox(a::T, b::T, atol=atol(T))
```
"""
atol(x) = atol(typeof(x))
atol(::Type{Float64}) = 1e-10
atol(::Type{Float32}) = 1.0f-5
atol(::Type{Q}) where {Q<:Quantity} = atol(numtype(Q)) * unit(Q)

"""
    addunit(x, u)

Adds the unit only if the argument is not a quantity, otherwise an error is thrown.
"""
addunit(x::Number, u) = x * u
addunit(x::Quantity, u) = throw(ArgumentError("invalid units for coordinates, please check the documentation"))

"""
    atanpos(x, y)

Adjusts the interval of values returned by the `atan(y, x)` function from `[-π,π]` to `[0,2π]`.
"""
function atanpos(y, x)
  α = atan(y, x)
  ifelse(α ≥ zero(α), α, α + oftype(α, 2π))
end

"""
    numconvert(T, x)

Converts the number type of quantity `x` to `T`.
"""
numconvert(::Type{T}, x::Quantity{S,D,U}) where {T,S,D,U} = convert(Quantity{T,D,U}, x)

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
