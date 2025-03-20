cwd = pwd()
@assert endswith(cwd, "CoordRefSystems/artifacts") "This script must be run from CoordRefSystems/artifacts"
datasetpath = joinpath(cwd, "epsg-wkt2")

to_be_deleted::Vector{String} = []

# Go through everything in epsg-wkt2 to make sure we do not 
# commit nor delete anything that was not meant to be there
for child in readdir(datasetpath, join=true)
  filename = basename(child)
  if isdir(child) || !endswith(filename, ".wkt")
    error("""Found unexpected item: "$child"
    Please make sure that the "epsg-wkt2" directory only contains .wkt files.""")
  # These are our target EPSG-CRS-#.wkt files we want to keep
  elseif startswith(filename, "EPSG-CRS-") && endswith(filename, ".wkt")
    continue
  # These are the EPSG-*.wkt files we want to delete
  elseif startswith(filename, "EPSG-") && endswith(filename, ".wkt")
    push!(to_be_deleted, child)
  else
    error("""Foudnd a wkt file: "$filename", that doesn't match the expected name format.
    Please make sure epsg.org did not change their naming scheme""")
  end
end

if !isempty(to_be_deleted)
  @info "Deleting non-CRS WKT files."
  rm.(to_be_deleted)
  @info "Deleted $(length(to_be_deleted)) files."
else
  @info """Files in "$(relpath(datasetpath))" are as expected. It is ready to be committed."""
end
Z