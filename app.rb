# Required Gems

['rubygems', 'bundler/setup', 'sinatra', 'sinatra/flash', 'erb', 'maruku', './db/db_config.rb'].each do |f|
    require f
end

enable :sessions

# Routes
get '/' do
    erb :index
end

configure :development do
    get '/javascripts/:name' do
        require 'coffee-script'
        coffee :"../public/javascripts/#{params[:name]}"
    end
end

# Manage Pages
get '/page/:id' do 

    @page = Page.get(params[:id])
    @content = Maruku.new("#{@page.body}").to_html
    
    erb :page
end

get "/new" do 
    erb :"manage/new"
end

get "/edit/:id" do
    @page = Page.get(params[:id])
    
    erb :"manage/edit"
end

get "/destroy/:id" do 

    Page.get(params[:id]).destroy
    
    flash[:alert] = "Page was destroyed."
    
    redirect "/"

end


post "/create" do 
    
    Page.create(
      :title      => "#{params[:title]}",
      :body       => "#{params[:body]}",
      :created_at => Time.now
    )
    
    flash[:success] = "Page was created!"
    
    redirect "/page/#{Page.last.id}"

end

post "/update/:id" do 

    @page = Page.get(params[:id])

    @page.update(
      :title      => "#{params[:title]}",
      :body       => "#{params[:body]}"
    )
    
    flash[:info] = "Page was successfully updated."
    
    redirect "/page/#{@page.id}"

end

# Tools
get '/tools/type' do    
    erb :'tools/type'
end