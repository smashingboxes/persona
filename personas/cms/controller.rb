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

=begin
get "/admin/manage/content" do
  erb :"../../personas/cms/views/manage", :layout => :"../../personas/core/views/layout"
end
=end

get "/admin/manage/create/content" do
  erb :"../../personas/cms/views/new", :layout => :"../../personas/core/views/layout"
end

get '/admin/manage/content/edit/:id' do
  require_user  
  erb :"../../personas/cms/views/edit", :layout => :"../../personas/core/views/layout"
end