#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Models                                           #
#                                                     #
#######################################################

require 'sinatra/base'

#######################################################
# 1) Controllers
#######################################################

get '/admin/tools/datamodel' do
    erb :"../../personas/tools/visualizer/data", :layout => :"../../personas/core/views/layout.html"
end

get '/admin/tools/type' do
    erb :"../../personas/tools/visualizer/type"
end