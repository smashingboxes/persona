#########################################
#             Core Persona              #
#########################################
#                                       #
#  1. Setup                             #
#                                       #
#########################################  
  
#########################################
#  1. Setup
#########################################

  _location = File.dirname(__FILE__)

  # Load in Helpers
  require "#{_location}/helpers.rb"
  
  # Load core files
  require_all 'rubygems', 'bundler/setup','compass', 'sinatra', 'haml', 'sinatra/flash', 'erb', 'tilt', 'maruku'
  
  # Required for flash notifications
  enable :sessions
  
  # Let Tilt know to look for '*.html.erb'
  Tilt.register 'html.erb', Tilt::ERBTemplate
  
  # Fire up the core model
  require './personas/core/model.rb'
  
  # Change the default directories to point to "themes"
  set :views, Proc.new { File.join(root, "/themes/#{System.theme}") }
  set :public, Proc.new { File.join(root, "/themes/#{System.theme}") } 
  
  # Configure Compass
  configure do
    Compass.add_project_configuration(File.join(Sinatra::Application.root, 'personas', 'core', 'compass.config'))
  end
  
  # Load remaining files
  require_all './personas/tools/authentication/authentication.rb', # => Load Authentication
              "./themes/#{System.theme}/config.rb",                # => Fireup theme modifiers (We do this first so that they can overide the core controller
              './personas/core/controller.rb'                      # => Core controllers
    
  