## EPSG WKTv2 Dataset


The `epsg-wkt2` directory containing the WKTv2 files that are used by `CoordRefSystems.wkt2`.
This directory contains only the CRS definition files `EPSG-CRS-#.wkt` from the [EPSG dataset](https://epsg.org/download-dataset.html). Other unused WKT files (Transformations, etc...) are deleted using the preparation script.


### Steps to update the dataset to the latest version
1. **Login** to [epsg.org/download-dataset.html](https://epsg.org/download-dataset.html)
2. **Download** an updated version of the WKT dataset (for example `EPSG-v12_005-WKT.Zip`)
3. **Extract** the file using `unzip -q EPSG-v12_005-WKT.Zip -d epsg-wkt2` (for example)
4. **Run** the preparation script to clean up the dataset: `julia prepare-wkt2.jl`
   - This will delete non-CRS WKT files and ensure the directory only contains wkt files that follow the expected naming convention
5. **Update** the version number below and commit


Current version: 12.005




