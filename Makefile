# source files are in source_data/:

# CUVA_CFA.gdb - Cuyahoga Valley National Park ESRI File Geodatabase - not currently included in repo
# cvnp_traildata.csv - CVNP trail metadata - created by hand from public web site

# mpssc_trails2013/ - Metro Parks Serving Summit County trail shapefile
# mpssc_traildata.csv -  MPSSC trail data - created by hand from public web site
# mpssc_trailheads.csv - MPSSC trailhead metadata - created by hand

# TODO: create new files as temp files

all: segments trailheads traildata

segments: summit_trailsegments.geojson

trailheads: summit_trailheads.geojson

traildata: summit_traildata.csv

clean: 
	rm -f summit_trailsegments.geojson \
	summit_trailsegments.csv \
	cvnp_trails.4326.csv \
	mpssc_trails.4326.short_names.csv \
	mpssc_trails.4326.csv \
	summit_trailheads.csv \
	summit_trailheads.geojson \
	summit_traildata.csv \
	cvnp_trailheads.csv

summit_trailsegments.geojson: summit_trailsegments.csv
	ogr2ogr -f "GeoJSON" summit_trailsegments.geojson summit_trailsegments.csv
	rm -f summit_trailsegments.csv

summit_trailsegments.csv: cvnp_trails.4326.csv mpssc_trails.4326.csv
	ruby csv_segment_filter.rb

# create 4326 CSV from ESRI file geodatabase
cvnp_trails.4326.csv: source_data/CUVA_CFA.gdb
	rm -f cvnp_trails.4326.csv # ogr2ogr can't seem to overwrite this file
	ogr2ogr -f "CSV" -nlt MULTILINESTRING \
	-s_srs EPSG:3857 -t_srs EPSG:4326 \
	cvnp_trails.4326.csv \
	source_data/CUVA_CFA.gdb Trails \
	-lco GEOMETRY=AS_WKT

mpssc_trails.4326.csv: mpssc_trails.4326.short_names.csv
	ruby mpssc_fix_segment_names.rb mpssc_trails.4326.short_names.csv > mpssc_trails.4326.csv

mpssc_trails.4326.short_names.csv: source_data/mpssc_trails2013/mpssc_trails2013a.shp
	rm -f mpssc_trails.4326.csv
	ogr2ogr -f "CSV" -nlt MULTILINESTRING \
	-s_srs EPSG:3734 -t_srs EPSG:4326 \
	mpssc_trails.4326.short_names.csv 'source_data/mpssc_trails2013/mpssc_trails2013a.shp' \
	-lco GEOMETRY=AS_WKT

summit_trailheads.geojson: summit_trailheads.csv
	rm -f summit_trailheads.geojson
	ogr2ogr -f "GeoJSON" -dim 2 summit_trailheads.geojson summit_trailheads.csv
	rm -f summit_trailheads.csv

summit_trailheads.csv: source_data/mpssc_trailheads.csv cvnp_trailheads.csv
	ruby csv_trailhead_filter.rb

cvnp_trailheads.csv: source_data/CUVA_CFA.gdb
	rm -f cvnp_trailheads.csv
	ogr2ogr -f "CSV" \
	-s_srs EPSG:3857 -t_srs EPSG:4326 \
	cvnp_trailheads.csv \
	source_data/CUVA_CFA.gdb TF_TrailHead \
	-lco GEOMETRY=AS_WKT

summit_traildata.csv: source_data/mpssc_traildata.csv source_data/cvnp_traildata.csv
	cat source_data/mpssc_traildata.csv source_data/cvnp_traildata.csv > summit_traildata.csv