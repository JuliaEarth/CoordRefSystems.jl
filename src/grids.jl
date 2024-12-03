# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    geotiff(Datumₛ, Datumₜ)

GeoTIFF file used in transforms that convert source `Datumₛ` to target `Datumₜ`.
"""
function geotiff end

# cache interpolator objects to avoid interpolating the same grid twice
const INTERPOLATOR = IdDict()

"""
    interpolator(Datumₛ, Datumₜ)

Linear interpolation of GeoTIFF grid that converts `Datumₛ` to `Datumₜ`.
All of the GeoTIFF channels are combined into the interpolated grid as a vector.
"""
function interpolator(Datumₛ, Datumₜ)
  if haskey(INTERPOLATOR, (Datumₛ, Datumₜ))
    return INTERPOLATOR[(Datumₛ, Datumₜ)]
  end

  # download geotiff from PROJ CDN
  file = downloadgeotiff(Datumₛ, Datumₜ)
  geotiff = GeoTIFF.load(file)

  # construct the interpolation grid
  img = GeoTIFF.image(geotiff)
  grid = mappedarray(img) do color
    N = GeoTIFF.nchannels(color)
    tup = ntuple(i -> GeoTIFF.channel(color, i), N)
    SVector(tup)
  end

  # lon lat range
  m, n = size(grid)
  A, b = GeoTIFF.affineparams2D(GeoTIFF.metadata(geotiff))
  lon₀, lat₀ = muladd(A, SA[0, 0], b)
  lonₘ, latₙ = muladd(A, SA[m, n], b)

  # Interpolations.jl requires ordered ranges
  reverselon = lon₀ > lonₘ
  reverselat = lat₀ > latₙ
  lonₛ, lonₑ = reverselon ? (lonₘ, lon₀) : (lon₀, lonₘ)
  latₛ, latₑ = reverselat ? (latₙ, lat₀) : (lat₀, latₙ)
  lonrange = range(start=lonₛ, stop=lonₑ, length=m)
  latrange = range(start=latₛ, stop=latₑ, length=n)

  # reverse dimensions if range is reversed
  if reverselon
    grid = @view grid[m:-1:1, :]
  end

  if reverselat
    grid = @view grid[:, n:-1:1]
  end

  # create the interpolation
  interp = interpolate((lonrange, latrange), grid, Gridded(Linear()))

  INTERPOLATOR[(Datumₛ, Datumₜ)] = interp

  interp
end

"""
    downloadgeotiff(Datumₛ, Datumₜ)

Download the GeoTIFF file that converts `Datumₛ` to `Datumₜ` from PROJ CDN.
"""
function downloadgeotiff(Datumₛ, Datumₜ)
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
