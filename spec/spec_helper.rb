require File.join(File.dirname(__FILE__), '.', 'prototypical_spec.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

require "./proto-includes/controller.rb"

set :root, File.dirname("../")
set :environment, :test

Rspec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
end