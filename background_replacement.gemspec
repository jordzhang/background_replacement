$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "background_replacement/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "background_replacement"
  s.version     = BackgroundReplacement::VERSION
  s.authors     = ["zhiliang"]
  s.email       = ["jordzhang@gmail.com"]
  s.homepage    = "https://github.com/jordzhang/background_replacement"
  s.summary     = "The replacement of video`s background with new background image"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.bindir = 'bin'

  s.add_dependency "rails", "~> 4.1.8"
  s.add_runtime_dependency "carrierwave"

  s.add_development_dependency "sqlite3"
end
