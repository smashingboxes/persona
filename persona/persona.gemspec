# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "persona/version"

Gem::Specification.new do |s|
  s.name        = "persona"
  s.version     = Persona::VERSION
  s.authors     = ["Nathan Hunzaker"]
  s.email       = ["nate.hunzaker@gmail.com"]
  s.homepage    = "personacms.heroku.com"
  s.summary     = %q{A simple web framework.}
  s.description = %q{A collection of sinatra apps which work together to provide a simple web framework.}

  s.rubyforge_project = "persona"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
