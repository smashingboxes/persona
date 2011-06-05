require 'rubygems'
require 'bundler'

Bundler.require

require './app'

puts "Let's get Prototypical!"

run Sinatra::Application