# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Identity()

Identity transform.
"""
struct Identity <: Transform end

apply(::Identity, x) = x

apply(::Reverse{<:Identity}, x) = x
