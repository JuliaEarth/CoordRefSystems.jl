# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    gridfile(Datumₛ, Datumₜ)

TODO
"""
function gridfile end

const INTERP_CACHE = IdDict()

"""
    interpolation(Datumₛ, Datumₜ)

TODO
"""
function interpolation(Datumₛ, Datumₜ)
  if haskey(INTERP_CACHE, (Datumₛ, Datumₜ))
    return INTERP_CACHE[(Datumₛ, Datumₜ)]
  end

  # download geotiff from PROJ CDN
  geotiff = downloadgrid(Datumₛ, Datumₜ)

  # construct the interpolation grid
  N = GeoTIFF.nchannels(geotiff)
  img = GeoTIFF.image(geotiff)
  grid = mappedarray(img) do color
    tup = ntuple(i -> GeoTIFF.channel(color, i), N)
    SVector(tup)
  end

  # lon lat range
  m, n = size(grid)
  A, b = GeoTIFF.affineparams2D(GeoTIFF.metadata(geotiff))
  lon₀, lat₀ = muladd(A, SA[0, 0], b)
  lonₘ, lat₀ = muladd(A, SA[m, 0], b)
  lon₀, latₙ = muladd(A, SA[0, n], b)
  lonₛ, lonₑ = lon₀ > lonₘ ? (lonₘ, lon₀) : (lon₀, lonₘ)
  latₛ, latₑ = lat₀ > latₙ ? (latₙ, lat₀) : (lat₀, latₙ)
  lonrange = range(start=lonₛ, stop=lonₑ, length=m)
  latrange = range(start=latₛ, stop=latₑ, length=n)

  # create the interpolation
  interp = interpolate((lonrange, latrange), grid, Gridded(Linear()))

  INTERP_CACHE[(Datumₛ, Datumₜ)] = interp

  interp
end

function downloadgrid(Datumₛ, Datumₜ)
  fname = gridfile(Datumₛ, Datumₜ)
  url = "https://cdn.proj.org/$fname"

  file = try
    # if data is already on disk
    # we just return the path
    @datadep_str fname
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    try
      register(DataDep(fname, "Grid file provided by PROJ CDN", url, Any))
      @datadep_str fname
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end

  GeoTIFF.load(file)
end

# ----------------
# IMPLEMENTATIONS
# ----------------

gridfile(::Type{SAD69}, ::Type{SIRGAS2000}) = "br_ibge_SAD69_003.tif"

gridfile(::Type{SAD96}, ::Type{SIRGAS2000}) = "br_ibge_SAD96_003.tif"
