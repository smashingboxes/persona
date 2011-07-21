require 'rubygems'
require 'bundler'
require 'rack/test'
require 'rspec'
require 'sinatra/test/methods'

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'personas', 'core', 'core.rb')

include Sinatra::Test::Methods

Sinatra::Application.default_options.merge!(
  :env => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)

Sinatra.application.options = nil

DataMapper::Model.descendants.each do |d|
  puts "Found model #{d.name} (#{d.all.count} entries)."
end

Rspec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
end