# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Sequential(transforms...)

Apply the `transforms` sequentially.
"""
struct Sequential{T<:Tuple} <: Transform
  transforms::T
end

Sequential(transforms...) = Sequential(transforms)

function apply(transform::Sequential, x)
  x′ = x
  for t in transform.transforms
    x′ = apply(t, x′)
  end
  x′
end

function apply(transform::Reverse{<:Sequential}, x)
  x′ = x
  for t in reverse(transform.transforms)
    x′ = apply(revert(t), x′)
  end
  x′
end
