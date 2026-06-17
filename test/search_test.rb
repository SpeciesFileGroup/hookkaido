require_relative "test_helper"

class TestSearch < Test::Unit::TestCase

  def test_search_blank_term_raises
    assert_raise(ArgumentError) { Hookkaido.search('') }
    assert_raise(ArgumentError) { Hookkaido.search('   ') }
    assert_raise(ArgumentError) { Hookkaido.search(nil) }
  end

  def test_search_default_ontology_is_uberon
    VCR.use_cassette("test_search_default_ontology_is_uberon") do
      res = Hookkaido.search('liver')
      assert_kind_of(Hash, res)
      assert_kind_of(Array, res[:results])
      assert_equal(1, res[:page])
      assert_equal(25, res[:per])
      assert_kind_of(Integer, res[:total])
      assert_true(res[:results].size > 0)
      assert_true(res[:results].first.key?(:iri))
      assert_true(res[:results].first.key?(:label))
      assert_true(res[:results].first.key?(:ontology_prefix))
    end
  end

  def test_search_pagination
    VCR.use_cassette("test_search_pagination") do
      res = Hookkaido.search('cell', per: 5, page: 2)
      assert_equal(2, res[:page])
      assert_equal(5, res[:per])
      assert_true(res[:results].size <= 5)
    end
  end

  def test_search_multiple_ontologies
    VCR.use_cassette("test_search_multiple_ontologies") do
      res = Hookkaido.search('part of', ontologies: ['ro', 'uberon'], per: 5)
      assert_kind_of(Hash, res)
      assert_kind_of(Array, res[:results])
    end
  end
end
