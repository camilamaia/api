# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "api/version"

Gem::Specification.new do |s|
  s.name        = 'api'
  s.version     = Api::VERSION
  s.summary     = "TestingBot Client Api"
  s.description = "Gem created for TestingBot challenge - Ruby Developer."
  s.authors     = ["Camila Maia"]
  s.email       = 'cmaiacd@gmail.com'
  s.homepage    = 'https://github.com/camilamaia/api'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "json"
  s.add_dependency "net-http-persistent"
  s.add_dependency "selenium-webdriver"
  s.add_development_dependency "rspec", [">= 2.9.0"]
end
