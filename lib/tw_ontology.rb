# frozen_string_literal: true
require "erb"
require_relative "tw_ontology/error"
require_relative "tw_ontology/version"
require_relative "tw_ontology/request"
require "tw_ontology/helpers/configuration"
require_relative "tw_ontology/sources/ols"

module TwOntology
  extend Configuration

  define_setting :mailto, ENV["TW_ONTOLOGY_EMAIL"]
  define_setting :timeout, (ENV["TW_ONTOLOGY_TIMEOUT"] || 10).to_i

  # List available ontology IDs (lowercased)
  def self.ontologies(verbose: false)
    Sources::OLS.ontologies(verbose: verbose, timeout: timeout)
  end

  # Search with combined totals (no per-ontology counts)
  # Return: { results:, page:, pagesize:, total: }
  def self.search(term, target_ontologies: [], pagesize: 25, page: 1, verbose: false)
    raise ArgumentError, "term cannot be blank" if term.to_s.strip.empty?

    requested = Array(target_ontologies).flat_map { |t| t.is_a?(String) && t.include?(",") ? t.split(",") : [t] }
    requested = requested.map { |t| t.to_s.strip.downcase }.reject(&:empty?)
    requested = ["uberon"] if requested.empty?
    requested = requested.uniq.first(3)

    # Validate against OLS catalog
    available = ontologies(verbose: verbose)
    targets   = (requested & available)
    targets   = ["uberon"] if targets.empty?

    per_page = pagesize.to_i
    start    = [(page.to_i - 1), 0].max * per_page

    payload = Sources::OLS.search(
      term,
      ontologies: targets,
      rows: per_page,
      start: start,
      verbose: verbose,
      timeout: timeout
    )

    results = payload[:results] || []
    total   = payload[:total].to_i

    # De-duplicate by URI
    uniq = {}
    results.each { |r| uniq[r[:uri]] ||= r if r[:uri] }

    {
      results: uniq.values,
      page: page.to_i,
      pagesize: per_page,
      total: total
    }
  end
end
