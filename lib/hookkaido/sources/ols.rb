# frozen_string_literal: true
module Hookkaido
  module Sources
    module OLS
      BASE = 'https://www.ebi.ac.uk/ols4/api'

      # Fetch OLS ontology IDs (lowercased)
      def self.ontologies(verbose:, timeout:)
        json = Hookkaido::Request
          .new(url: BASE, verbose: verbose, timeout: timeout)
          .perform('ontologies', params: { size: 500 }, method: :get)

        arr = []
        if json.is_a?(Hash)
          emb = json['_embedded'] && json['_embedded']['ontologies']
          if emb.is_a?(Array)
            emb.each do |o|
              oid = (o['config'] && o['config']['id'])&.to_s&.downcase || ''
              title = (o['config'] && o['config']['title']) || ''
              description = (o['config'] && o['config']['description']) || ''
              arr << { oid:, title:, description: }
            end
          end
        elsif json.is_a?(Array)
          json.each do |o|
            oid = (o['config'] && o['config']['id'])&.to_s&.downcase || ''
            title = (o['config'] && o['config']['title']) || ''
            description = (o['config'] && o['config']['description']) || ''
            arr << { oid:, title:, description: }
          end
        end

        arr.uniq
      end

      # Single-call search across up to 3 ontologies; returns results + combined total
      def self.search(term, ontologies:, rows:, start:, verbose:, timeout:)
        onts = Array(ontologies).map { |x| x.to_s.downcase }.uniq
        params = {
          q: term,
          type: 'class',
          ontology: onts.join(','), # multi-ontology in one call
          queryFields: 'label,synonym',
          fieldList: 'iri,label,description,ontology_prefix',
          rows: rows,
          start: start
        }

        json = Hookkaido::Request
                 .new(url: BASE, verbose: verbose, timeout: timeout)
                 .perform('search', params: params, method: :get)

        resp  = json && json['response']
        docs  = (resp && resp['docs']) || []
        total = (resp && resp['numFound']) || 0

        results = docs.map { |doc| normalize_doc(doc) }.compact
        { results: results, total: total.to_i }
      end

      def self.normalize_doc(doc)
        iri = doc['iri']
        return nil unless iri

        label = doc['label']
        label = label.first if label.is_a?(Array)

        description = doc['description']
        description = description.first if description.is_a?(Array)

        {
          iri: iri,
          label:,
          ontology_prefix: doc['ontology_prefix'],
          description:
        }
      end
      private_class_method :normalize_doc
    end
  end
end
