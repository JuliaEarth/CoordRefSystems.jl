# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    @timedephelmert Datumₛ Datumₜ (δx=0.0, δy=0.0, δz=0.0, θx=0.0, θy=0.0, θz=0.0, s=0.0,
      dδx=0.0, dδy=0.0, dδz=0.0, dθx=0.0, dθy=0.0, dθz=0.0, ds=0.0, tᵣ=epoch(Datumₜ))

Create a Helmert transform from time-dependent parameters:
epoch difference `dt = epoch(Datumₛ) - tᵣ`,
translation rates `dδx, dδy, dδz` in meters per year, 
rotation rates `dθx, dθy, dθz` in arc seconds per year 
scale rate `ds` in ppm (parts per million) per year,
and reference epoch `tᵣ` in decimalyears.

See also [`@helmert`](@ref).

## References

* Section 4.3.5 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
macro timedephelmert(Datumₛ, Datumₜ, params)
  expr = quote
    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      xyz = SVector(coords.x, coords.y, coords.z)
      xyz′ = timedephelmertfwd(Dₛ, Dₜ, xyz; $params...)
      Cartesian{Dₜ}(xyz′...)
    end

    function Base.convert(::Type{Cartesian{Dₛ}}, coords::Cartesian{Dₜ,3}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ}
      xyz = SVector(coords.x, coords.y, coords.z)
      xyz′ = timedephelmertbwd(Dₛ, Dₜ, xyz; $params...)
      Cartesian{Dₛ}(xyz′...)
    end

    Base.convert(::Type{Cylindrical{Dₜ}}, coords::Cylindrical{Dₛ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Cylindrical{Dₜ}, convert(Cartesian{Dₜ}, convert(Cartesian{Dₛ}, coords)))

    Base.convert(::Type{Cylindrical{Dₛ}}, coords::Cylindrical{Dₜ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Cylindrical{Dₛ}, convert(Cartesian{Dₛ}, convert(Cartesian{Dₜ}, coords)))

    Base.convert(::Type{Spherical{Dₜ}}, coords::Spherical{Dₛ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Spherical{Dₜ}, convert(Cartesian{Dₜ}, convert(Cartesian{Dₛ}, coords)))

    Base.convert(::Type{Spherical{Dₛ}}, coords::Spherical{Dₜ}) where {Dₛ<:$Datumₛ,Dₜ<:$Datumₜ} =
      convert(Spherical{Dₛ}, convert(Cartesian{Dₛ}, convert(Cartesian{Dₜ}, coords)))
  end
  esc(expr)
end

timedephelmertfwd(args...; kwargs...) = timedephelmertimpl(helmertfwd, args...; kwargs...)

timedephelmertbwd(args...; kwargs...) = timedephelmertimpl(helmertbwd, args...; kwargs...)

function timedephelmertimpl(
  helmert,
  Datumₛ,
  Datumₜ,
  xyz;
  δx=0.0,
  δy=0.0,
  δz=0.0,
  θx=0.0,
  θy=0.0,
  θz=0.0,
  s=0.0,
  dδx=0.0,
  dδy=0.0,
  dδz=0.0,
  dθx=0.0,
  dθy=0.0,
  dθz=0.0,
  ds=0.0,
  tᵣ=epoch(Datumₜ)
)
  dt = epoch(Datumₛ) - tᵣ
  helmert(
    xyz,
    δx=δx + dδx * dt,
    δy=δy + dδy * dt,
    δz=δz + dδz * dt,
    θx=θx + dθx * dt,
    θy=θy + dθy * dt,
    θz=θz + dθz * dt,
    s=s + ds * dt
  )
end
