#########################################
#              Model.rb                 #
#########################################
#                                       #
#########################################

require_all 'rubygems', 'data_mapper'

# We want to first check to see if there is an existing database on the server (in our case, Heroku)
# If not, then default to a basic sqlite database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/proto-includes/proto.db")


# Creates a datatable with the current website settings

class System
  include DataMapper::Resource
  
  property :id,              Serial
  property :theme ,          String,       :required => true,      :message => "Please specify a theme for this site.",      :default => "protoplasm"
  property :title,           String,       :required => true,      :message => "Please specify a title for this site",       :default => "Prototypical"
  property :description,     String,       :required => false,     :default => "A basic CMS"
  
  def self.theme
    self.first.theme
  end
  
  def self.title
    self.first.title
  end
  
  def self.description
    self.first.description
  end
  
end
      
DataMapper.finalize
DataMapper.auto_upgrade!

# Create the default settings
@system = System.create()
