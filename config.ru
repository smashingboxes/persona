require 'rubygems'
require 'bundler'

Bundler.require
    
require './personas/base/core.rb'

Persona::Base.load_personas "frontman", "administrator", "composer", "utility/painter"


map "/" do
  run Persona::Frontman
end

map "/admin" do
  run Persona::Administrator
end

map "/admin/content" do
  run Persona::Composer
end

map '/admin/tools' do
  run Persona::Painter
end

puts "\nPersona.... engage!\n\n"

