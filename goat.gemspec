$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'goat/version'


Gem::Specification.new do |s|
  s.name          = "goat"
  s.version       = Goat::VERSION
  s.authors       = ["Filippos Vasilakis"]
  s.email         = ["vasilakisfil@gmail.com"]

  s.summary       = "A simple yet powerfull evented server"
  s.description   = ""
  s.homepage      = "http://github.com/vasilakisfil/"


  s.add_development_dependency "rspec"
end
