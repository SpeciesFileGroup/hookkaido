# frozen_string_literal: true
require "faraday"
require "multi_json"
module Faraday
  module TwOntologyErrors
    class Middleware < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |response|
          case response[:status].to_i
          when 400 then raise TwOntology::BadRequest,  compose(response)
          when 404 then raise TwOntology::NotFound,    compose(response)
          when 500 then raise TwOntology::InternalServerError, compose(response)
          when 502 then raise TwOntology::BadGateway,  compose(response)
          when 503 then raise TwOntology::ServiceUnavailable,  compose(response)
          when 504 then raise TwOntology::GatewayTimeout,      compose(response)
          end
        end
      end
      private
      def compose(response)
        body = begin
          MultiJson.load(response[:body]) if response[:body].to_s.strip.start_with?("{","[")
        rescue MultiJson::ParseError
          nil
        end
        "#{response[:method].to_s.upcase} #{response[:url]}: #{[response[:status], body].compact.join(" ")}"
      end
    end
  end
end
