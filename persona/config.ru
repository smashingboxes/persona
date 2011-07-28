###################################
# A sample rackfile
####################################


require 'bundler'
Bundler.require
  
# First, we need to load the persona gem  
require 'persona'

# Second, we need to tell it to load up all of the sinatra apps we'd like to use
Persona::Base.load_personas "frontman", "administrator", "composer", "utility/painter"

Rack::Lint
Rack::Reloader

# Next, we map them to their various routes
map "/" do
  run Persona::Frontman
end

map "/admin" do
  run Persona::Administrator
end

map "/admin/content" do
  run Persona::Composer
end

map "/admin/tools" do
  run Persona::Painter
end