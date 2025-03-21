# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# recipe to update epsg-wkt2 artifact
function epsgwkt2()
  datasetdir = joinpath(@__DIR__, "epsg-wkt2")

  # go through every file in epsg-wkt2 to make sure we do not 
  # commit nor delete anything that was not meant to be there
  todelete = String[]
  for child in readdir(datasetdir, join=true)
    filename = basename(child)
    if isdir(child) || !endswith(filename, ".wkt")
      throw(ErrorException("""
      Found unexpected item: "$child".
      Please make sure that the "epsg-wkt2"
      directory only contains *.wkt files.
      """))
      # these are our target EPSG-CRS-#.wkt files we want to keep
    elseif startswith(filename, "EPSG-CRS-") && endswith(filename, ".wkt")
      continue
      # these are the EPSG-*.wkt files we want to delete
    elseif startswith(filename, "EPSG-") && endswith(filename, ".wkt")
      push!(todelete, child)
    else
      throw(ErrorException("""
      Found file "$filename" that doesn't match the expected name format.
      Please make sure epsg.org did not change their naming scheme.
      """))
    end
  end

  if !isempty(todelete)
    @info "Deleting non-CRS WKT files."
    rm.(todelete)
    @info "Deleted $(length(todelete)) files."
  else
    @info """Files in "$(relpath(datasetdir))" are as expected. It is ready to be committed."""
  end
end

# ------------
# RUN UPDATES
# ------------

epsgwkt2()
