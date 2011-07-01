require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

namespace :js do
  desc "Converts CoffeeScript to JavaScript"
  task :compile do
    require 'coffee-script'
    
    print "Compiling CoffeeScript..."
    
    source = "./proto-includes/src/coffeescripts/"
    javascripts = "./proto-includes/personas/cms/admin/"
    
    Dir.foreach(source) do |cf|
      unless cf == '.' || cf == '..' 
        js = CoffeeScript.compile File.read("#{source}#{cf}") 
        open "#{javascripts}#{cf.gsub('.coffee', '.js')}", 'w' do |f|
          f.puts js
        end 
      end 
    end
    
    puts " converted!"
    
  end
end