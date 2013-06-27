all: summit_trail_segments.csv

summit_trail_segments.geojson: summit_trail_segments.csv
	ogr2ogr -f "GeoJSON" -overwrite cvnp_trails.geojson cvnp_trails.4326.csv

summit_trail_segments.csv: cvnp_trails.4326.csv mpssc_trails.4326.csv
	ruby csv_segment_filter.rb

cvnp_trails.4326.csv: CUVA_CFA.gdb
	ogr2ogr -f "CSV" -nlt MULTILINESTRING \
	-s_srs EPSG:3857 -t_srs EPSG:4326 \
	-overwrite \
	cvnp_trails.4326.csv \
	CUVA_CFA.gdb Trails \
	-lco GEOMETRY=AS_WKT

mpssc_trails.4326.csv: mpssc_trails/mpssc_trails2013a.shp
	ogr2ogr -f "CSV" -nlt MULTILINESTRING \
	-s_srs EPSG:3857 -t_srs EPSG:4326 \
	-overwrite \
	cvnp_trails.4326.csv '/Users/davery/cvnp_trails shapefile/cvnp_trails.shp' \
	-lco GEOMETRY=AS_WKT

