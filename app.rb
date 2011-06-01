# Required Gems
require "bundler/setup"
require 'sinatra'
require 'sinatra/flash'
require 'erb'

require 'datamapper'

# need install dm-sqlite-adapter
#DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

enable :sessions

# Routes
get '/' do
    erb :'index.html'
end

get '/:name' do 
    erb :"#{params[:name]}.html"
end


get '/tools/type' do    
    flash[:success] = "Success!"
    flash[:error] = "Error!"
    flash[:info] = "More info: Lorem Ipsum Varle Vue Con Carne."

    erb :'tools/type.html'
end