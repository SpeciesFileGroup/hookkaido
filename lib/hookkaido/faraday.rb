# frozen_string_literal: true
require 'faraday'
require 'multi_json'
module Faraday
  module TwOntologyErrors
    class Middleware < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |response|
          case response[:status].to_i
          when 400 then raise Hookkaido::BadRequest,  compose(response)
          when 404 then raise Hookkaido::NotFound,    compose(response)
          when 500 then raise Hookkaido::InternalServerError, compose(response)
          when 502 then raise Hookkaido::BadGateway,  compose(response)
          when 503 then raise Hookkaido::ServiceUnavailable,  compose(response)
          when 504 then raise Hookkaido::GatewayTimeout,      compose(response)
          end
        end
      end
      private
      def compose(response)
        body = begin
          MultiJson.load(response[:body]) if response[:body].to_s.strip.start_with?('{', '[')
        rescue MultiJson::ParseError
          nil
        end
        "#{response[:method].to_s.upcase} #{response[:url]}: #{[response[:status], body].compact.join(' ')}"
      end
    end
  end
end
