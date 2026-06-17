require_relative "test_helper"

class TestOntologies < Test::Unit::TestCase

  def test_ontologies
    VCR.use_cassette("test_ontologies") do
      res = Hookkaido.ontologies
      assert_kind_of(Array, res)
      assert_true(res.size > 0)
      assert_true(res.first.key?(:oid))
      assert_true(res.first.key?(:title))
      assert_true(res.first.key?(:description))
    end
  end

  def test_ontologies_includes_uberon
    VCR.use_cassette("test_ontologies_includes_uberon") do
      res = Hookkaido.ontologies
      assert_true(res.any? { |o| o[:oid] == 'uberon' })
    end
  end
end
