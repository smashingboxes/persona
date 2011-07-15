source "http://rubygems.org"

group :default do

  # We need to place compass before sinatra
  gem 'compass'
  
  # Sinatra, naturally  
  gem 'sinatra'
  gem 'sinatra-flash'
  
  # Templating
  gem 'maruku'
  gem 'tilt'
  gem 'haml'
  
  # Manage Coffeescript
  gem 'coffee-script'
  
  # Data
  gem 'data_mapper'
  
  # Mail
  gem 'pony'
  
end

group :production do
    gem 'dm-postgres-adapter'
end

group :development do
  gem 'dm-sqlite-adapter'  
end

group :test do
  ###
  # Temporarily disabled
  ###
  
  #gem 'ruby-debug'
  #gem 'rack-test'
  #gem 'autotest'
  #gem 'rspec', '2.5.0'
end
