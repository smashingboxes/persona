#########################################
#             Prototypical              #
#########################################
#                                       #
#  1. Setup                             #
#       a. System Helpers               #
#       b. Personas                     #
#  2. General Routes                    #
#  3. Miscellaneous                     #
#                                       #
#########################################


#########################################
# 1. Setup
#########################################

  # a) System Configuration
  
  # We need to ensure the correct root, otherwise testing will fail
  set :root, File.dirname("../")
  
  # System Helpers
  require "./proto-includes/system.rb"
  
  require_all 'rubygems', 'bundler/setup', 'sinatra', 'sinatra/flash', 'erb', 'tilt', 'maruku', './proto-includes/model.rb'

  Tilt.register 'html.erb', Tilt::ERBTemplate
  
  # Required for flash notifications
  enable :sessions
  
  # b) Personas
  #    Careful: Having multiple personalities can make you crazy
  load_persona "cms/cms"


#########################################
# 2. Routes
#########################################

get '/' do
  erb :"index.html"
end
  
#########################################
# 3. Miscellaneous
#########################################

# Tools
get '/tools/:name' do    
  erb :"../../proto-includes/tools/#{params[:name]}"
end
