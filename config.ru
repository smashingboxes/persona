require 'rubygems'
require 'bundler'

Bundler.require
    
require './proto-includes/controller.rb'
require 'sinatra/flash'

puts "\nLet's get Prototypical!\n\n"

run Sinatra::Application