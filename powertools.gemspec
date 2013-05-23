$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "powertools/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "powertools"
  s.version     = Powertools::VERSION
  s.authors     = ["CJ Lazell"]
  s.email       = ["email@cj.io"]
  s.homepage    = "http://github.com/cj/powertools"
  s.summary     = "Adds a bunch of extra tools that we use in a bunch of projects"
  s.description = "Adds a bunch of extra tools that we use in a bunch of projects"

  s.files = Dir["{app,vendor,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.0.rc1"
  s.add_dependency "jquery-rails"
  s.add_dependency 'coffee-rails', '>= 4.0.0.rc1'
  s.add_dependency 'therubyracer'
  s.add_dependency 'less-rails'
  s.add_dependency 'twitter-bootstrap-rails'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
