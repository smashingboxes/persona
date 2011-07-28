# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "persona/version"

Gem::Specification.new do |s|
  s.name        = "persona"
  s.version     = Persona::VERSION
  s.authors     = ["Nathan Hunzaker"]
  s.email       = ["nate.hunzaker@gmail.com"]
  s.homepage    = "http://personacms.heroku.com"
  s.summary     = %q{A simple web framework.}
  s.description = %q{A collection of sinatra-based apps which work together to create a simple web framework.}
  
  s.required_ruby_version = '>= 1.9.2'
  
  s.add_dependency 'sinatra'
  s.add_dependency 'big_band'
  s.add_dependency 'sinatra-flash'
  s.add_dependency 'maruku'
  s.add_dependency 'coffee-script'
  s.add_dependency "therubyracer"
  s.add_dependency 'data_mapper'
  s.add_dependency 'dm-postgres-adapter'
  
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'dm-sqlite-adapter'
  s.add_development_dependency 'racksh'
  s.add_development_dependency 'rack-webconsole'
  
  s.rubyforge_project = "persona"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
