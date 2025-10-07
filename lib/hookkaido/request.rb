# frozen_string_literal: true
require_relative 'faraday'
require 'faraday/follow_redirects'
require 'multi_json'
require_relative 'utils'

module Hookkaido
  class Request
    def initialize(url:, verbose: false, headers: {}, timeout: 10)
      @url = url
      @verbose = verbose
      @headers = headers
      @timeout = timeout
    end

    def perform(endpoint, params: {}, method: :get)
      Faraday::Utils.default_space_encoding = '+'
      conn = Faraday.new(url: @url) do |f|
        f.request :url_encoded
        f.response :follow_redirects
        f.response :logger if @verbose
        f.options.timeout = @timeout
        f.use Faraday::TwOntologyErrors::Middleware
        f.adapter Faraday.default_adapter
      end

      conn.headers['Accept'] = 'application/json,*/*'
      conn.headers[:user_agent] = make_user_agent
      conn.headers['X-USER-AGENT'] = make_user_agent
      @headers.each { |k, v| conn.headers[k] = v }
      res = case method
            when :get  then conn.get(endpoint, params)
            when :post then conn.post(endpoint, params)
            else raise ArgumentError, "Unsupported method: #{method}"
            end

      MultiJson.load(res.body)
    end
  end
end
