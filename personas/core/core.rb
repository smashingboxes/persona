#########################################
#             Core Persona              #
#########################################
#                                       #
#  1. Requirements                      #
#  2. Configuration                     #
#                                       #
#########################################  
  
#########################################
#  1. Requirements
#########################################
  
  # Takes all items out of a collection and
  # requires them
  #
  # items - A variable number of required file
  #         names as strings
  #
  def require_all(*items)
    items.each do |b|
      require b
    end
  end
    
  # Load core files  
  require_all 'rubygems',
              'bundler/setup',
              'sinatra',
              'sinatra/flash',                                             # => 
              'maruku',                                                    # => For interpretting Markdown
              'coffee-script',                                             # => For interpreting CoffeeScript
           
              # Development
              'sinatra/reloader' unless ENV['RACK_ENV'] == 'production'   # => Auto reloads the server with it detects changes

  
  puts "Environment is set to #{ENV['RACK_ENV']}."
                         
  # Load core files
  require     './personas/core/model.rb'                                   # => Sets up the database and System model
  
  require_all './personas/core/helpers.rb',                                # => Required for the 'require_all' method
              './personas/tools/authentication/authentication.rb',         # => Load Authentication
              './personas/tools/visualizer/visualizer.rb',                 # => Displays all model attributes
              "./themes/#{System.theme}/config.rb",                        # => Fireup theme modifiers
              './personas/core/controller.rb'                              # => Core controllers


#########################################
#  2. Configuration
#########################################              
  
  enable :sessions 
  
  # Let Tilt know to look for '*.html.erb'
  Tilt.register 'html.erb', Tilt::ERBTemplate