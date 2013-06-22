$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'goatserver/version'


Gem::Specification.new do |s|
  s.name          = "goatserver"
  s.version       = "0.0.0" 
  s.authors       = ["Filippos Vasilakis"]
  s.email         = ["vasilakisfil@gmail.com"]

  s.summary       = "A simple yet powerfull evented server"
  s.description   = ""
  s.homepage      = "http://github.com/vasilakisfil/"


  s.add_development_dependency "rspec"
end
