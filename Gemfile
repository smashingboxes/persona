source "http://rubygems.org"

group :default do
  gem 'sinatra'
  gem 'sinatra-flash'
  gem 'maruku'
  gem 'tilt'
  gem "bcrypt-ruby", :require => "bcrypt"
  # Data
  gem 'data_mapper'

end

group :production do
    gem 'dm-postgres-adapter'
end

group :development do

  gem 'dm-sqlite-adapter'

  # Manage Coffeescript
  gem 'coffee-script'
  gem 'rack-coffee'
  gem 'therubyracer'
  gem 'sass'
  gem 'compass'
  
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
