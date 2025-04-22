# Artifacts

## epsg-wkt2

The `epsg-wkt2` directory contains the EPSG WKT version 2 dataset that is
used by `CoordRefSystems.wkt2`. Only the `EPSG-CRS-*.wkt` files are retained.
Other `*.wkt` files associated with Transformations, etc. are removed using
the `update.jl` recipes.

### Steps to update the dataset to the latest version

1. **Login** to https://epsg.org/download-dataset.html
2. **Download** an updated version of the dataset (e.g., `EPSG-v12_005-WKT.Zip`)
3. **Extract** the files (e.g., `unzip -q EPSG-v12_005-WKT.Zip -d epsg-wkt2`)
4. **Run** the `update.jl` script to clean up the dataset: `julia update.jl`
   - This will remove non-CRS `*.wkt` files and ensure the directory
     only contains files that follow the expected naming convention,
     which is `EPSG-CRS-*.wkt`.
5. **Update** the version number below and commit

Current version: 12.007
