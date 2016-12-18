$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem"s version:
require "human_attributes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "human_attributes"
  s.version       = HumanAttributes::VERSION
  s.authors       = ["Platanus", "Leandro Segovia"]
  s.email         = ["rubygems@platan.us", "ldlsegovia@gmail.com"]
  s.homepage      = "https://github.com/platanus/human_attributes"
  s.summary       = "Gem to generate human readable ActiveRecord attributes"
  s.description   = "Gem to convert ActiveRecord attributes and methods to human readable attributes"
  s.license       = "MIT"

  s.files = `git ls-files`.split($/).reject { |fn| fn.start_with? "spec" }
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2", ">= 4.2.0"
  s.add_dependency "factory_girl_rails", "~> 4.6"
  s.add_development_dependency "enumerize", "~> 1", ">= 1.1.1"
  s.add_development_dependency "draper", "~> 2.1.0"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.4"
  s.add_development_dependency "guard-rspec", "~> 4.7"
end
