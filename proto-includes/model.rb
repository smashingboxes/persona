#########################################
#              Model.rb                 #
#########################################
#                                       #
#########################################

require_all 'rubygems', 'data_mapper'

# We want to first check to see if there is an existing database on the server (in our case, Heroku)
# If not, then default to a basic sqlite database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/proto-includes/db/proto.db")