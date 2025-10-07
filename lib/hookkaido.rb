# frozen_string_literal: true
require 'erb'
require_relative 'hookkaido/error'
require_relative 'hookkaido/version'
require_relative 'hookkaido/request'
require 'hookkaido/helpers/configuration'
require_relative 'hookkaido/sources/ols'

module Hookkaido
  extend Configuration

  define_setting :timeout, (ENV['TW_ONTOLOGY_TIMEOUT'] || 10).to_i
  define_setting :mailto, ENV['HOOKKAIDO_API_EMAIL']

  # List available ontology IDs (lowercased)
  def self.ontologies(verbose: false)
    Sources::OLS.ontologies(verbose: verbose, timeout: timeout)
  end

  # Search with combined totals (no per-ontology counts)
  # Return: { results:, page:, per:, total: }
  def self.search(term, ontologies: [], per: 25, page: 1, verbose: false)
    raise ArgumentError, 'term cannot be blank' if term.to_s.strip.empty?

    requested = Array(ontologies).flat_map { |t| t.is_a?(String) && t.include?(',') ? t.split(',') : [t] }
    requested = requested.map { |t| t.to_s.strip.downcase }.reject(&:empty?)
    requested = ['uberon'] if requested.empty?
    requested = requested.uniq.first(3)
    # Uberon is a union of many other ontologies, so can return a lot of results
    # - put other results first.
    requested.push('uberon') if requested.delete('uberon')

    # Validate against OLS catalog
    #available = ontologies(verbose: verbose)
    #targets = (requested & available)
    #targets = ['uberon'] if targets.empty?
    targets = requested

    per_page = per.to_i
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
      per: per_page,
      total: total
    }
  end
end
