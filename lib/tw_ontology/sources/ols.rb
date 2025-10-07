# frozen_string_literal: true
module TwOntology
  module Sources
    module OLS
      BASE = "https://www.ebi.ac.uk/ols4/api"

      # Fetch OLS ontology IDs (lowercased)
      def self.ontologies(verbose:, timeout:)
        json = TwOntology::Request
                .new(url: BASE, verbose: verbose, timeout: timeout)
                .perform("ontologies", params: {}, method: :get)

        arr = []
        if json.is_a?(Hash)
          emb = json["_embedded"] && json["_embedded"]["ontologies"]
          if emb.is_a?(Array)
            emb.each do |o|
              oid = o["ontologyId"] || (o["config"] && o["config"]["id"]) || o["namespace"] || o["id"]
              arr << oid.to_s.downcase if oid
            end
          end
        elsif json.is_a?(Array)
          json.each do |o|
            oid = o["ontologyId"] || (o["config"] && o["config"]["id"]) || o["namespace"] || o["id"]
            arr << oid.to_s.downcase if oid
          end
        end
        arr.uniq
      end

      # Single-call search across up to 3 ontologies; returns results + combined total
      def self.search(term, ontologies:, rows:, start:, verbose:, timeout:)
        onts = Array(ontologies).map { |x| x.to_s.downcase }.uniq
        params = {
          q: term,
          type: "class",
          ontology: onts.join(","),                # multi-ontology in one call
          queryFields: "label,synonym",
          fieldList: "iri,label,description,ontologyId",
          rows: rows,
          start: start
        }

        json = TwOntology::Request
                 .new(url: BASE, verbose: verbose, timeout: timeout)
                 .perform("search", params: params, method: :get)

        resp  = json && json["response"]
        docs  = (resp && resp["docs"]) || []
        total = (resp && resp["numFound"]) || 0

        results = docs.map { |doc| normalize_doc(doc) }.compact
        { results: results, total: total.to_i }
      end

      def self.normalize_doc(doc)
        iri = doc["iri"] || doc["iri_s"]
        return nil unless iri

        label = doc["label"]
        label = label.first if label.is_a?(Array)

        desc = doc["description"]
        desc = desc.first if desc.is_a?(Array)

        src = doc["ontologyId"].to_s.downcase

        {
          uri: iri,
          uri_label: label,
          source: src,
          description: desc
        }
      end
      private_class_method :normalize_doc
    end
  end
end
