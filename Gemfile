source "http://rubygems.org"
source "http://gemcutter.org"

group :default do

  # We need to place compass before sinatra
  gem 'compass'
  
  # Sinatra, naturally  
  gem 'sinatra'
  gem 'sinatra-reloader'
  gem 'sinatra-flash'
  gem 'sinatra-advanced-routes'
  
  # Templating
  gem 'maruku'
  gem 'tilt'
  gem 'haml'
  
  # Manage JavaScript
  gem 'sprockets'
  gem 'coffee-script'
  gem "therubyracer"
    
  # Data
  gem 'data_mapper'
  
  # Mail
  gem 'pony'
  
end

group :production do
    gem 'dm-postgres-adapter'
end

group :development do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  
  # Console
  gem 'racksh'
end

group :test do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  
  gem 'rspec'
  gem 'rack-test'  
end
