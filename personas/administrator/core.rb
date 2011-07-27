#########################################
#             Core Persona              #
#########################################
#                                       #
#  1. Requirements                      #
#  2. Configuration                     #
#                                       #
#########################################  

# Configuration
module Persona

  class Administrator < Persona::Base
        
    # Requirements
    load_persona "utility/authentication"
  
    require_all 'maruku',                   # => For interpretting Markdown
                'coffee-script'             # => For interpreting CoffeeScript
    
    # Change the default directories to point to "admin"
    set :views,   Proc.new  { File.join("personas", "administrator", "views") }
    set :public,  Proc.new  { File.join("personas", "administrator", "views") }
    set :layout,  Proc.new  { File.join("personas", "administrator", "views") }

    
    # Load core files
    require 'sinatra/flash'
    require  "./personas/administrator/controller.rb" 
    
  end
  
end