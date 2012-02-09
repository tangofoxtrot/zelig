# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zelig/version"

Gem::Specification.new do |s|
  s.name        = "zelig"
  s.version     = Zelig::VERSION
  s.authors     = ["Jeremy Morony"]
  s.email       = ["jeremy@sidereel.com"]
  s.homepage    = ""
  s.summary     = %q{Fixtures and mocks for services}
  s.description = %q{Fixtures and mocks for services}

  s.rubyforge_project = "zelig"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rr"
  s.add_development_dependency "sinatra"
  s.add_dependency "rspec"
  s.add_dependency "sham_rack"
end
