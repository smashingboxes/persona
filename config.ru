require 'rubygems'
require 'bundler'

Bundler.require
    
require './proto-includes/controller.rb'

puts "Let's get Prototypical!"

run Sinatra::Application