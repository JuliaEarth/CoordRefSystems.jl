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

See also [`HelmertTransform`](@ref).

## References

* Section 4.3.5 of EPSG Guidance Note 7-2: <https://epsg.org/guidance-notes.html>
"""
macro timedephelmert(Datumₛ, Datumₜ, params)
  expr = quote
    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₛ,Dₜ<:Datumₜ}
      x = SVector(values(coords))
      x′ = timedephelmertfwd(Dₛ, Dₜ, x; $params...)
      Cartesian{Dₜ,3}(Tuple(x′))
    end

    function Base.convert(::Type{Cartesian{Dₜ}}, coords::Cartesian{Dₛ,3}) where {Dₛ<:$Datumₜ,Dₜ<:Datumₛ}
      x = SVector(values(coords))
      x′ = timedephelmertbwd(Dₛ, Dₜ, x; $params...)
      Cartesian{Dₜ,3}(Tuple(x′))
    end
  end
  esc(expr)
end

timedephelmertfwd(args...; kwargs...) = timedephelmertgeneric(helmerttransformfwd, args...; kwargs...)

timedephelmertbwd(args...; kwargs...) = timedephelmertgeneric(helmerttransformbwd, args...; kwargs...)

function timedephelmertgeneric(
  helmert,
  Datumₛ,
  Datumₜ,
  x;
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
    x,
    δx=δx + dδx * dt,
    δy=δy + dδy * dt,
    δz=δz + dδz * dt,
    θx=θx + dθx * dt,
    θy=θy + dθy * dt,
    θz=θz + dθz * dt,
    s=s + ds * dt
  )
end
