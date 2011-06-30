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
  
  require_all 'rubygems', 'bundler/setup', 'sinatra', 'sinatra/flash', 'erb', 'maruku', './proto-includes/model.rb'
  
  # Required for flash notifications
  enable :sessions
  
  # Change the default directories to point to "themes"
  set :views, Proc.new { File.join(root, "/themes/#{System.theme}/") }
  set :public, Proc.new { File.join(root, "/themes/#{System.theme}/") }
  
  # b) Personas
  #    Careful: Having multiple personalities can make you crazy
  require './proto-includes/personas/cms/cms.rb'
  

#########################################
# 2. Routes
#########################################

get '/' do
  erb :"index"
end

  #####################################################
  # a) System Settings
  #####################################################

  get "/admin" do
    require_user
    erb :"../../proto-includes/admin/system"
  end
  
  post "/admin" do 
  
    @system = System.first
  
    @system.update(
      :title        => params[:title],
      :theme        => params[:theme],
      :description  => params[:description]
    )
    
    flash[:info] = "System was successfully updated!"
    
    redirect "/"
    
  end
  
  
#########################################
# 3. Miscellaneous
#########################################

# Tools
get '/tools/:name' do    
  erb :"../../proto-includes/tools/#{params[:name]}"
end
