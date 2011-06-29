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
    
  # SystemHelpers
  require "./proto-includes/system.rb"
  require_all 'rubygems', 'bundler/setup', 'sinatra', 'sinatra/flash', 'erb', 'maruku', './proto-includes/model.rb'
  
  # Required for flash notifications
  enable :sessions

  # b) Personas
  #    Careful: Having multiple personalities can make you crazy
  require './proto-includes/personas/blog.rb'


#########################################
# 2. Routes
#########################################

get '/' do
    erb :"/templates/home"
end

get '/golden' do
    erb :"/pages/golden"
end 


#########################################
# 3. Miscellaneous
#########################################

# Tools
get '/tools/:name' do    
    erb :"tools/#{params[:name]}"
end
