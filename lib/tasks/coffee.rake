require 'coffee-script'

namespace :js do
  desc "Converts CoffeeScript to JavaScript"
  task :compile do
    source = "./public/javascripts/coffeescripts/"
    javascripts = "./public/javascripts/"
    
    Dir.foreach(source) do |cf|
      unless cf == '.' || cf == '..' 
        js = CoffeeScript.compile File.read("#{source}#{cf}") 
        open "#{javascripts}#{cf.gsub('.coffee', '.js')}", 'w' do |f|
          f.puts js
        end 
      end 
    end
  end
end