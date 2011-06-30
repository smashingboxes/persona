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
  
  # Change the default "view" directory to "themes"
  set :views, Proc.new { File.join(root, "/themes/#{System.theme}/") }

  # b) Personas
  #    Careful: Having multiple personalities can make you crazy
  require './proto-includes/personas/blog.rb'
  

#########################################
# 2. Routes
#########################################

get '/' do
    erb :"/templates/home"
end

# This can go away soon
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
