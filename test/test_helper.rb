# frozen_string_literal: true

require 'test/unit'
require 'hookkaido'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

Hookkaido.timeout = 60
