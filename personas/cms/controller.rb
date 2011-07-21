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
  get '/' do
    @content = Content.get(System.homepage) || Content.first
    erb :'index'
  end
  
  get '/content/:id' do
    proto_genesis :"/templates/#{Content.get(params[:id]).template}"
  end
           
  get '/content/:type/:name' do
    name = params[:name].gsub("-", " ")
    type = params[:type]
             
    @content = Content.first(:content_type => type, :title => name)

    proto_genesis :"/templates/#{@content.template}"
  end
  
           
#######################################################
#  1) Admin Content Routes
#######################################################        
  
  # Create
  get "/admin/content/create" do
    erb :'../../personas/cms/views/new', :layout => '../../personas/core/views/layout'
  end
  
  # Read
  get "/admin/content" do     
    erb :'../../personas/cms/views/manage', :layout => :'../../personas/core/views/layout'
  end
    
  # Update
  get '/admin/content/edit/:id' do  
    erb :"../../personas/cms/views/edit", :layout => '../../personas/core/views/layout'
  end