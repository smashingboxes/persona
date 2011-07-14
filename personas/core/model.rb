#########################################
#              Core  Model              #
#########################################
#                                       #
#  1) Setup                             #
#  2) System                            #
#                                       #
#########################################

#########################################
#  1. Setup
#########################################

# Get Datamapper
require_all 'rubygems', 'data_mapper'

# We want to first check to see if there is an existing database on the server (in our case, Heroku)
# If not, then default to a basic sqlite database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/personas/core/proto.db")


#########################################
#  2. System DB
#########################################

  # Creates a datatable with the current website settings
  class System
    include DataMapper::Resource
    
    property :id,              Serial
    property :theme ,          String,       :required => true,      :message => "Please specify a theme for this site.",      :default => "default"
    property :title,           String,       :required => true,      :message => "Please specify a title for this site.",      :default => "Persona"
    
    def self.theme
      self.first.theme
    end
        
  end
        
  DataMapper.finalize
  DataMapper.auto_upgrade!
  
  # Create the default settings
  @system = System.create(:title => "Persona") unless System.all.count > 0