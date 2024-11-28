# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    geotiff(Datumₛ, Datumₜ)

TODO
"""
function geotiff end

const INTERPOLATION = IdDict()

"""
    interpolation(Datumₛ, Datumₜ)

TODO
"""
function interpolation(Datumₛ, Datumₜ)
  if haskey(INTERPOLATION, (Datumₛ, Datumₜ))
    return INTERPOLATION[(Datumₛ, Datumₜ)]
  end

  # download geotiff from PROJ CDN
  file = download(Datumₛ, Datumₜ)
  geotiff = GeoTIFF.load(file)

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

  INTERPOLATION[(Datumₛ, Datumₜ)] = interp

  interp
end

function download(Datumₛ, Datumₜ)
  fname = geotiff(Datumₛ, Datumₜ)
  url = "https://cdn.proj.org/$fname"
  ID = splitext(fname) |> first

  dir = try
    # if data is already on disk
    # we just return the path
    @datadep_str ID
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    try
      register(DataDep(ID, "Grid file provided by PROJ CDN", url, Any))
      @datadep_str ID
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end

  # file path
  joinpath(dir, fname)
end

# ----------------
# IMPLEMENTATIONS
# ----------------

geotiff(::Type{SAD69}, ::Type{SIRGAS2000}) = "br_ibge_SAD69_003.tif"

geotiff(::Type{SAD96}, ::Type{SIRGAS2000}) = "br_ibge_SAD96_003.tif"
