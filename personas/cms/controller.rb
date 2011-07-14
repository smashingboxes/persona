#######################################################
#                 CMS Controller                      #
#######################################################
#                                                     #
#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Basic Routes                                     #
#                                                     #
#######################################################

#####################################################
#  1) Basic Routes
#####################################################


# Look for a base layout file to work with
get '/' do
  @content = Content.get(System.homepage) || Content.first
  erb :'index'
end

get '/node/:id' do
  proto_genesis :"/templates/#{Content.get(params[:id]).template}"
end

get "/admin/manage/create/content" do
  erb :"../../personas/cms/views/admin/new", {:layout => :"../../personas/core/views/admin/layout"}
end

get '/admin/manage/content/edit/:id' do
  require_user  
  erb :"../../personas/cms/views/admin/edit", :layout => :"../../personas/core/views/admin/layout.html"
end