require 'rubygems'
require 'bundler'

Bundler.require
    
require './personas/core/core.rb'

puts "\nPersona.... engage!\n\n"

run Sinatra::Application