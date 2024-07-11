# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

function TimeDependentHelmert(
  ::Type{Datumₛ},
  ::Type{Datumₜ};
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
  ds=0.0
) where {Datumₜ,Datumₛ}
  dt = epoch(Datumₛ) - epoch(Datumₜ)
  SimpleHelmert(
    δx=δx + dδx * dt,
    δy=δy + dδy * dt,
    δz=δz + dδz * dt,
    θx=θx + dθx * dt,
    θy=θy + dθy * dt,
    θz=θz + dθz * dt,
    s=s + ds * dt
  )
end

# ----------------
# IMPLEMENTATIONS
# ----------------

# source of parameters: 
# EPSG Database: https://epsg.org/search/by-name

geoctransform(::Type{ITRF{2008}}, ::Type{ITRF{2020}}) = TimeDependentHelmert(
  ITRF{2008},
  ITRF{2020},
  δx=-0.2e-3,
  δy=-1e-3,
  δz=-3.3e-3,
  s=0.29e-3,
  dδy=0.1e-3,
  dδz=-0.1e-3,
  ds=0.03e-3
)
