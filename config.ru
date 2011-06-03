require 'rubygems'
require 'bundler'

Bundler.require

require './app'
puts "Let's get prototypical!"
run Sinatra::Application