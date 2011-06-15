#########################################
#              System.rb                #
#########################################
#                                       #
#########################################

require 'rubygems'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/proto-includes/db/proto.db")