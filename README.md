# tw_ontology

Search anatomy terms via **OLS4** (no API key).

## Public API
```ruby
# List available OLS ontology IDs (lowercased)
TwOntology.ontologies

# Search (combined results + combined total across selected ontologies)
TwOntology.search(term, target_ontologies: [], pagesize: 25, page: 1, verbose: false)
# => {
#   results: [ { uri:, uri_label:, source:, description: }, ... ],
#   page: Integer,
#   pagesize: Integer,
#   total: Integer                      # OLS response.numFound (combined)
# }
```
### Behavior
- `target_ontologies`: any OLS IDs (strings/symbols), **max 3**. Empty ⇒ `["uberon"]`.
- Single **`/ols4/api/search`** call using `ontology=one,two,three`.
- No per-ontology totals (by design). `total` is the combined `numFound`.
