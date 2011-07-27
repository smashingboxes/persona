source "http://rubygems.org"
source "http://gemcutter.org"

group :default do

  # Sinatra, naturally  
  gem 'sinatra'
  gem 'big_band'
  gem 'sinatra-flash'
  
  # Templating
  gem 'maruku'
  gem 'tilt'
  gem 'haml'
  
  # Manage JavaScript
  # gem 'sprockets'
  gem 'coffee-script'
  gem "therubyracer"
    
  # Data
  gem 'data_mapper'
    
  # Mail
  gem 'pony'
  
  # Authentication
  gem 'warden'
  
end

group :production do
  gem 'dm-postgres-adapter'
end

group :development do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  
  # Consoles
  gem 'racksh'
  gem 'rack-webconsole'
  
end

group :test do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  
  gem 'rspec'
  gem 'rack-test'  
end
