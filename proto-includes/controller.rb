# Required Gems

['rubygems', 'bundler/setup', 'sinatra', 'sinatra/flash', 'erb', 'maruku'].each do |f|
    require f
end

enable :sessions

# Models
require File.dirname(__FILE__) + '/model.rb'

# Helpers
require File.dirname(__FILE__) + '/helpers.rb'

# Root
get '/' do
    erb :"templates/home"
end

# General Pages
get 'pages/:name' do
    erb :"pages/#{params[:name]}"
end 

# Manage Prototypical Content
get '/node/:id' do     
    erb :"templates/#{Content.get(params[:id]).template}"
end

get "/new" do 
    erb :"manage/new"
end

get "/edit/:id" do    
    erb :"manage/edit"
end

get "/destroy/:id" do 

    Content.get(params[:id]).destroy
    
    flash[:alert] = "Content was destroyed."
    
    redirect "/"

end

post "/create" do 
    
    content = Content.new(
      :title            => params[:title],
      :body             => params[:body],
      :content_type     => params[:content_type],
      :template         => params[:template],
      :parent           => params[:parent],
      :created_at       => Time.now,
      :updated_at       => Time.now
    )
    
    if content.save
      flash[:success] = "#{params[:content_type].capitalize} was created!"
      redirect "/node/#{content.id}"
    else
      content.errors.each do |e|
        flash[:error] = e
      end
        redirect back
    end

end

post "/update/:id" do 

    @content = Content.get(params[:id])

    @content.update(
      :title        => params[:title],
      :body         => params[:body],
      :template     => params[:template],
      :updated_at   => Time.now
    )
    
    flash[:info] = "Content was successfully updated!"
    
    redirect "/node/#{@content.id}"

end

# Tools
get '/tools/:name' do    
    erb :"tools/#{params[:name]}"
end

# JavaScripts/CoffeeScripts
get '/javascripts/:name' do
    File.read("public/javascripts/#{params[:name]}.js")
end
