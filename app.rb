# Required Gems
require 'rubygems'
require "bundler/setup"

require 'sinatra'
require 'sinatra/flash'
require 'erb'

require 'maruku'

# Database connections
require './db/db_config.rb'

enable :sessions

# Routes
get '/' do
    erb :'index.html'
end

get '/page/:id' do 

    @page = Page.get(params[:id])
    @content = Maruku.new("#{@page.body}").to_html
    
    erb :"page.html"
end

get "/create" do 
    erb :"create.html"
end

post "/create" do 
    
    Page.create(
      :title      => "#{params[:title]}",
      :body       => "#{params[:body]}",
      :created_at => Time.now
    )
    
    flash[:success] = "Post was successfully made!"
    
    redirect "/"

end


get '/tools/type' do    
    flash[:success] = "Success!"
    flash[:error] = "Error!"
    flash[:info] = "More info: Lorem Ipsum Varle Vue Con Carne."
    flash[:notice] = "Notice: Lorem Ipsum Varle Vue Con Carne."

    erb :'tools/type.html'
end