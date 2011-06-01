# Required Gems
require "bundler/setup"

require 'sinatra'
require 'erb'
# require 'pony' 


# Routes
get '/' do
    erb :'index.html'
end

get '/:name' do 
    erb :"#{params[:name]}.html"
end


get '/tools/type' do
    erb :'tools/type.html'
end