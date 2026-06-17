# frozen_string_literal: true
require_relative "lib/hookkaido/version"

Gem::Specification.new do |spec|
  spec.name          = "hookkaido"
  spec.version       = Hookkaido::VERSION
  spec.authors       = ["Tom Klein"]
  spec.email         = ["trklein@illinois.edu"]

  spec.summary       = "OLS4-backed ontology search"
  spec.description   = "Look up ontology terms across selected OLS ontologies."
  spec.homepage      = "https://github.com/SpeciesFileGroup/hookkaido"
  spec.license       = "MIT"
  spec.required_ruby_version = [">= 2.5.0", "< 5.0"]

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.metadata["generated_by"] = "ChatGPT (OpenAI) assistance"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/SpeciesFileGroup/hookkaido"
  spec.metadata["rubygems_mfa_required"] = "false"

  spec.add_dependency "faraday", "~> 2.2"
  spec.add_dependency "faraday-follow_redirects", ">= 0.1", "< 0.6"
  spec.add_dependency "multi_json", "~> 1.15"

  spec.add_development_dependency "rake", "~> 13.0", ">= 13.0.1"
  spec.add_development_dependency "test-unit", "~> 3.3", ">= 3.3.6"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "rexml", "~> 3.3", ">= 3.3.6"
end
