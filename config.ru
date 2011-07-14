require 'rubygems'
require 'bundler'

Bundler.require
    
require './personas/core/core.rb'
require 'sinatra/flash'

puts "\nPersona.... engage!\n\n"

run Sinatra::Application