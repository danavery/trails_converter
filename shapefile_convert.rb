require 'rgeo/shapefile'

class ShapefileConverter

  def initialize() 
    @textfile_field_names.push("SOURCE")
    @textfile_field_names.push("GEOM")
  end

  def convert_file()
    puts "srid: #{@srid}"
    srs_database = RGeo::CoordSys::SRSDatabase::Proj4Data.new('epsg')
    shp_factory = RGeo::Geographic.projected_factory(:projection_proj4 => "+proj=lcc +lat_1=41.7 +lat_2=40.43333333333333 +lat_0=39.66666666666666 +lon_0=-82.5 +x_0=600000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs"
                                                     )
    RGeo::Shapefile::Reader.open(@shpfile, factory: shp_factory.projection_factory) do |file|
      puts "File contains #{file.num_records} records."
      File.open(@textfile_name, 'w') do |outfile|
        outfile.write(@textfile_field_names.join("\t"))
        outfile.write("\n")
        file.each do |record|

          puts "record number #{record.index}:"
          puts "  Attributes: #{record.attributes.inspect}"
          puts "---"
          puts record.geometry.inspect
          puts "xxx"
          #factory3857 = RGeo::Geographic.spherical_factory(srid: 3857)
          
          #proj_record = RGeo::Feature.cast(record.geometry, {:factory => factory3857, :project => true})

          write_array = Array.new
          @shapefile_field_names.each do |key|
            write_array.push(record.attributes[key])
          end
          write_array.push(@source_id)
       
          proj_geom = shp_factory.unproject(record.geometry) 
          puts proj_geom.inspect 
          print "----------------------------------------------------\n\n\n"
          #write_array.push(proj_record.as_text)
          outfile.write(write_array.join("\t"))
          outfile.write("\n")
        end
      end
    end
  end
end

class CVNPShapefileConverter < ShapefileConverter
  def initialize()
    @srid = 3857
    @shpfile = '/Users/davery/cvnp_trails.shp'
    @shapefile_field_names =  %w(NAME1 NAME2 NAME3 BIKE HORSE SURFACE SHAPE_Leng)
    @textfile_field_names =   %w(NAME1 NAME2 NAME3 BIKE HORSE SURFACE LENGTH)
    @source_id = "CVNP"
    @textfile_name = "cvnp_trails.txt"
    super
  end
end

class MPSSCShapefileConverter < ShapefileConverter
  def initialize()
    @srid = 3734
    @shpfile = '/Users/davery/Development/Spatial/SummitCo_GIS/metroparks/mpssc_trails2012'
    @shapefile_field_names =  %w(NAME  LENGTH)
    @textfile_field_names =   %w(NAME1 LENGTH)
    @source_id = "MSSCC"
    @textfile_name = "mpssc_trails.txt"
    super
  end
end

sc = MPSSCShapefileConverter.new
sc.convert_file()
