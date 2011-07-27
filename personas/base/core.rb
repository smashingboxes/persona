#########################################
#             Core Persona              #
#########################################
#                                       #
#  1. Requirements                      #
#  2. Configuration                     #
#                                       #
#########################################  

module Persona          
  
  # Load core files 
  require 'sinatra/big_band'
  require 'sinatra/flash'
  
  # Load basic system helpers, before anything else
  require "#{File.dirname(__FILE__)}/helpers.rb"  
 
  class Base < Sinatra::BigBand
  
    enable :sessions              # => Required for authentication and other session based features
    enable :absolute_redirects    # => Required for Persona intercommunication
    
    register Sinatra::Flash       # => Enables flash notifications
    
    # Let Tilt know to look for '*.html.erb'
    Tilt.register 'html.erb', Tilt::ERBTemplate       
    
    require "#{File.dirname(__FILE__)}/model.rb"
     
    include Persona::Core
    extend Persona::Core
    
    helpers do
      include Persona::Core
    end
    
  end 
end