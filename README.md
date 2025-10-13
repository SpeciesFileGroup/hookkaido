# Hookkaido

Hookkaido is a Ruby wrapper on the [OLS](https://www.ebi.ac.uk/ols4/) API. Code follows the spirit/approach of the Gem [serrano](https://github.com/sckott/serrano), and indeed much of the wrapping utility is copied 1:1 from that repo, thanks [@sckott](https://github.com/sckott).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hookkaido'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hookkaido

## Quick start

Search for ontology terms from the (default) Uberon ontology matching 'femur':
```ruby
bin/console
h = Hookkaido.search('femur')
h.keys
=> [:results, :page, :pagesize, :total]

h[:total]
=> 32
h[:results].first
=> {iri: "http://purl.obolibrary.org/obo/UBERON_0015052", label: "femur endochondral element", ontology_prefix: "uberon", description: "A femur bone or its cartilage or pre-cartilage precursor."}
```

Uberon aggregates results from many ontologies; you're likely to get more targeted results by specifying an ontology more specific to your use case, such as HAO (Hymenopteran Anatomy Ontology) for example:
```ruby
h = Hookkaido.search('femur', ontologies: 'hao')
h[:total]
=> 10
h[:results].map{ |r| [r[:label], r[:description], r[:iri]] }
=> 
[["mesofemur", "The femur that is located on the mid leg.", "http://purl.obolibrary.org/obo/HAO_0001131"],
 ["metafemur", "The femur that is located on the hind leg.", "http://purl.obolibrary.org/obo/HAO_0001140"],
 ["profemur", "The femur that is located on the fore leg.", "http://purl.obolibrary.org/obo/HAO_0001124"],
 ["femur", "The leg segment that is distal to the trochanter and proximal to the tibia.", "http://purl.obolibrary.org/obo/HAO_0000327"],
 ["trochantellus", "The area that is located proximally on the femur and is delimited by a groove.", "http://purl.obolibrary.org/obo/HAO_0001033"],
 ["protrochantero-profemoral muscle",
  "The intrinsic leg muscle that arises anteriorly from the wall of the protrochanter and inserts on the proximal profemoral apodeme.",
  "http://purl.obolibrary.org/obo/HAO_0001238"],
 ["mesotrochantero-mesofemoral muscle",
  "The intrinsic leg muscle that arises anteriorly from the wall of the mesotrochanter and inserts on the proximal mesofemoral apodeme.",
  "http://purl.obolibrary.org/obo/HAO_0001261"],
 ["metatrochantero-metafemoral muscle",
  "The intrinsic leg muscle that arises anteriorly from the wall of the metatrochanter and inserts on the proximal metafemoral apodeme.",
  "http://purl.obolibrary.org/obo/HAO_0001280"],
 ["tibial fossa of the femur", "The fossa that is located distally on the femur and accommodates the femoral condyle of the tibia.", "http://purl.obolibrary.org/obo/HAO_0001207"],
 ["sturdy spines of the hind femur", "The spine that is located on the ventral face of the metafemur.", "http://purl.obolibrary.org/obo/HAO_0002491"]]
```

Search more than one specific ontology - *at most 3 may be provided*, if none are provided then the default Uberon is searched.
```ruby
 Hookkaido.search('femur', ontologies: ['hao', 'lepao'])
 ```
 Available ontology identifiers can be found at https://www.ebi.ac.uk/ols4/ontologies, or you can return the list (with much less data per ontology) using Hookkaido:
```ruby
a = Hookkaido.ontologies

a.first
=> 
{oid: "ado",
 title: "Alzheimer's Disease Ontology (ADO)",
 description:
  "Alzheimer's Disease Ontology is a knowledge-based ontology that encompasses varieties of concepts related to Alzheimer'S Disease, foundamentally structured by upper level Basic Formal Ontology(BFO). This Ontology is enriched by the interrelational entities that demonstrate the nextwork of the understanding on Alzheimer's disease and can be readily applied for text mining."}
```

### Pagination

For pagination in `search`, use the `page` and `per` parameters:
```ruby
h = Hookkaido.search('head', per: 50, page: 1)

[h[:page], h[:per], h[:total]]
=> [1, 50, 143]
```

The `ontologies` endpoint isn't paged - at time of writing it will return ~285 ontologies.

---

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, update the `CHANGELOG.md`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SpeciesFileGroup/hookkaido. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/SpeciesFileGroup/hookkaido/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT license](https://github.com/SpeciesFileGroup/hookkaido/blob/main/LICENSE.txt). You can learn more about the MIT license on [Wikipedia](https://en.wikipedia.org/wiki/MIT_License) and compare it with other open source licenses at the [Open Source Initiative](https://opensource.org/license/mit/).

## Code of Conduct

Everyone interacting in the Hookkaido project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SpeciesFileGroup/hookkaido/blob/main/CODE_OF_CONDUCT.md).