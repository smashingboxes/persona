#######################################################
#                 CMS Controller                      #
#######################################################
#                                                     #
#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Basic Routes                                     #
# 2) Admin Routes                                     #
#                                                     #
#######################################################

#######################################################
#  1) Basic Routes
#######################################################
  
  # Map out our routes for content
  home = get '/' do
           @content = Content.get(System.homepage) || Content.first
           erb :'index'
         end
  
  #home.promote
  
  content_routes = {
  
    show: (get '/content/:id' do
             proto_genesis :"/templates/#{Content.get(params[:id]).template}"
           end), 
           
    single: (get '/content/:type/:name' do
    
             name = params[:name].gsub("-", " ")
             type = params[:type]
             
             @content = Content.first(:content_type => type, :title => name)
             proto_genesis :"/templates/#{@content.template}"
           end)
                           
  }
                    
                    
  content_routes.each do |route|
      content_routes[route[0]].promote
  end   
         
#######################################################
#  1) Admin Content Routes
#######################################################        

  content_admin_routes = {
      
    create: (get "/admin/content/create" do
      erb :'../../cms/views/new'
    end),
    
    read: (get "/admin/content" do     
      erb :'../../cms/views/manage'
    end),
    
    update: (get '/admin/content/edit/:id' do  
      erb :"../../cms/views/edit"
    end)  
                       
  }
  
  content_admin_routes.each do |route|
      content_admin_routes[route[0]].promote
  end