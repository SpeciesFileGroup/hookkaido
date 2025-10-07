# frozen_string_literal: true
require_relative "lib/tw_ontology/version"

Gem::Specification.new do |spec|
  spec.name          = "tw_ontology"
  spec.version       = TwOntology::VERSION
  spec.authors       = ["TW"]
  spec.email         = ["you@example.org"]

  spec.summary       = "OLS4-backed search (no API key) with ontology selector."
  spec.description   = "Look up ontology terms across selected OLS ontologies; returns combined totals."
  spec.homepage      = "https://example.org/tw_ontology"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.metadata["rubygems_mfa_required"] = "false"

  spec.add_dependency "faraday", ">= 1.10", "< 3"
  spec.add_dependency "faraday-follow_redirects", ">= 0.3"
  spec.add_dependency "multi_json", ">= 1.15"
end
