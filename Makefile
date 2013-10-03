# source files are in source_data/:

# CUVA_CFA.gdb - Cuyahoga Valley National Park ESRI File Geodatabase - not currently included in repo
# cvnp_traildata.csv - CVNP trail metadata - created by hand from public web site

# mpssc_trails2013/ - Metro Parks Serving Summit County trail shapefile
# mpssc_traildata.csv -  MPSSC trail data - created by hand from public web site
# mpssc_trailheads.csv - MPSSC trailhead metadata - created by hand

# TODO: create new files as temp files

all: segments trailheads traildata

segments: cvnp_segments.geojson mpssc_segments.geojson

trailheads: cvnp_trailheads.geojson mpssc_trailheads.geojson

traildata: cvnp_traildata.csv mpssc_traildata.csv

# TODO: fix this
clean: 
	rm -f summit_trailsegments.geojson \
	summit_trailsegments.csv \
	build/* \
	*.csv \
	*.geojson \
	cvnp_segments.geojson \
	cvnp_trailheads.geojson \
	cvnp_traildata.csv \
	mpssc_segments.geojson \
	mpssc_trailheads.geojson \
	mpssc_traildata.csv



# create 4326 CSV from shapefile
cvnp_segments_orig.csv: source_data/cvnp_sep_2013/Trail_Segments_NPS_CFA.shp
	rm -f cvnp_segments_orig.csv # ogr2ogr can't seem to overwrite this file
	ogr2ogr -f "CSV" -nlt PROMOTE_TO_MULTI \
	-t_srs EPSG:4326 \
	cvnp_segments_orig.csv \
	source_data/cvnp_sep_2013/Trail_Segments_NPS_CFA.shp \
	-lco GEOMETRY=AS_WKT

cvnp_segments_fixed.csv: cvnp_segments_orig.csv
	ruby cvnp_segment_fixer.rb cvnp_segments_orig.csv > cvnp_segments_fixed.csv

cvnp_segments.geojson: cvnp_segments_fixed.csv
	rm -f cvnp_segments.geojson
	ogr2ogr -f "GeoJSON" -nlt PROMOTE_TO_MULTI \
	-s_srs EPSG:4326 \
	-t_srs EPSG:4326 \
	cvnp_segments.geojson \
	cvnp_segments_fixed.csv

cvnp_trailheads_orig.csv: source_data/cvnp_sep_2013/Trailheads_NPS_CFA_28Kfix.shp
	rm -f cvnp_trailheads_orig.csv
	ogr2ogr -f "CSV" \
	-t_srs EPSG:4326 \
	-where "OBJECTID_1 != 0" \
	cvnp_trailheads_orig.csv \
	source_data/cvnp_sep_2013/Trailheads_NPS_CFA_28Kfix.shp \
	-lco GEOMETRY=AS_WKT

cvnp_trailheads_fixed.csv: cvnp_trailheads_orig.csv
	ruby cvnp_trailhead_fixer.rb cvnp_trailheads_orig.csv > cvnp_trailheads_fixed.csv

cvnp_trailheads.geojson: cvnp_trailheads_fixed.csv
	rm -f cvnp_trailheads.geojson
	ogr2ogr -f "GeoJSON" \
	-s_srs EPSG:4326 \
	-t_srs EPSG:4326 \
	cvnp_trailheads.geojson \
	cvnp_trailheads_fixed.csv

cvnp_traildata.csv: source_data/cvnp_sep_2013/cvnp_traildata.csv
	cp source_data/cvnp_sep_2013/cvnp_traildata.csv .

mpssc_segments_orig.csv: source_data/mpssc_trails_2013_09/cfa_mpssc_trails_10_2013.shp
	rm -f mpssc_segments_orig.csv
	ogr2ogr -f "CSV" -nlt PROMOTE_TO_MULTI \
	-t_srs EPSG:4326 \
	-s_srs EPSG:3734 \
	mpssc_segments_orig.csv \
	source_data/mpssc_trails_2013_09/cfa_mpssc_trails_10_2013.shp \
	-lco GEOMETRY=AS_WKT

mpssc_segments_fixed.csv: mpssc_segments_orig.csv
	ruby mpssc_segment_fixer.rb mpssc_segments_orig.csv > mpssc_segments_fixed.csv

mpssc_segments.geojson: mpssc_segments_fixed.csv
	rm -f mpssc_segments.geojson
	ogr2ogr -f "GeoJSON" \
	-s_srs EPSG:4326 \
	-t_srs EPSG:4326 \
	mpssc_segments.geojson \
	mpssc_segments_fixed.csv

mpssc_trailheads_orig.csv: source_data/mpssc_trails_2013_09/cfa_mpssc_trailheads2013.shp
	rm -f mpssc_trailheads_orig.csv
	ogr2ogr -f "CSV" \
	-s_srs EPSG:3734 \
	-t_srs EPSG:4326 \
	mpssc_trailheads_orig.csv \
	source_data/mpssc_trails_2013_09/cfa_mpssc_trailheads2013.shp \
	-lco GEOMETRY=AS_WKT

mpssc_trailheads_fixed.csv: mpssc_trailheads_orig.csv
	ruby mpssc_trailhead_fixer.rb mpssc_trailheads_orig.csv > mpssc_trailheads_fixed.csv

mpssc_trailheads.geojson: mpssc_trailheads_fixed.csv
	rm -f mpssc_trailheads.geojson
	ogr2ogr -f "GeoJSON" \
	-s_srs EPSG:4326 \
	-t_srs EPSG:4326 \
	mpssc_trailheads.geojson \
	mpssc_trailheads_fixed.csv

mpssc_traildata.csv: source_data/mpssc_trails_2013_09/cfa_mpssc_traildata.csv
	cp source_data/mpssc_trails_2013_09/cfa_mpssc_traildata.csv .



# not used below here for now
summit_trailsegments.geojson: summit_trailsegments.csv
	rm -f summit_trailsegments.geojson
	ogr2ogr -f "GeoJSON" summit_trailsegments.geojson summit_trailsegments.csv
	rm -f summit_trailsegments.csv

summit_trailsegments.csv: cvnp_trails.4326.csv mpssc_trails.4326.csv # cvnp_oecc_trails.4326.csv
	ruby csv_segment_filter.rb



cvnp_oecc_trails.4326.csv: source_data/CUVA_CFA.gdb
	rm -f cvnp_oecc_trails.4326.csv
	ogr2ogr -f "CSV" -nlt MULTILINESTRING \
	-s_srs EPSG:3857 -t_srs EPSG:4326 \
	cvnp_oecc_trails.4326.csv \
	source_data/CUVA_CFA.gdb OECC_Towpath_Trail \
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



summit_traildata.csv: source_data/mpssc_traildata.csv source_data/cvnp_traildata.csv
	cat source_data/mpssc_traildata.csv source_data/cvnp_traildata.csv | grep -v '^\#' > summit_traildata.csv