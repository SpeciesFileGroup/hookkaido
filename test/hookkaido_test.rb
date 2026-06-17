# frozen_string_literal: true

require_relative "test_helper"

class HookkaidoTest < Test::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Hookkaido::VERSION
  end
end
