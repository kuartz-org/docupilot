# frozen_string_literal: true

require "net/http"

module Docupilot
  class Request
    class Failure < StandardError; end

    attr_reader :attributes, :headers, :base_path, :path, :response, :query_string_elements, :logger

    def initialize(base_path)
      @headers = { "apikey" => Docupilot.config.api_key }
      @base_path = base_path
      @logger = Logger.new(STDOUT)
    end

    def get(path, query_string_elements = {})
      logger.info("GET request to #{uri}")

      perform_request(path, query_string_elements) { Net::HTTP.get(uri, headers) }
    end

    def post(path, body_elements, query_string_elements = {})
      logger.info("POST request to #{uri} with body #{body_elements}")

      perform_request(path, query_string_elements) do
        Net::HTTP.post(uri, body_elements.to_json, **headers, "Content-Type" => "application/json").body
      end
    end

    def put(path, body_elements, query_string_elements = {})
      logger.info("PUT request to #{uri} with body #{body_elements}")

      perform_request(path, query_string_elements) do
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Put.new(uri, **headers, "Content-Type" => "application/json")
        request.body = body_elements.to_json
        https.request(request).body
      end
    end

    def upload(path, file, query_string_elements = {})
      logger.info("POST request to #{uri} with file #{file}")

      perform_request(path, query_string_elements) do
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri, headers)
        request.set_form([["file", File.open(file)]], "multipart/form-data")
        https.request(request).body
      end
    end

    private

    def uri
      full_path = [Docupilot.config.end_point, base_path, path].join("/").delete_suffix("/")
      full_path = "#{full_path}?#{URI.encode_www_form(@query_string_elements)}" if query_string_elements&.any?
      URI full_path
    end

    def handle_response
      logger.info("Response body:\n#{response}\n")
      parsed_response = JSON.parse(response, symbolize_names: true)

      return parsed_response[:data] if parsed_response[:status] == "success"

      raise Failure, parsed_response[:data]
    end

    def perform_request(path, query_string_elements)
      @query_string_elements = query_string_elements
      @path = path
      @response = yield
      handle_response
    end
  end
end
