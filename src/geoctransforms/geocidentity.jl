# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

struct GeocentricIdentity <: GeocentricTransform end

geocapply(::GeocentricIdentity, x) = x

geocapply(::Reverse{<:GeocentricIdentity}, x) = x
