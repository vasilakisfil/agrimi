$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'agrimi/version'


Gem::Specification.new do |s|
  s.name          = "agrimi"
  s.version       = "0.0.0"
  s.authors       = ["Filippos Vasilakis"]
  s.email         = ["vasilakisfil@gmail.com"]

  s.summary       = "A simple yet powerfull loosely coupled
                    thread-based http server"
  s.description   = ""
  s.homepage      = "http://github.com/vasilakisfil/"


  s.add_development_dependency "rspec"
end
