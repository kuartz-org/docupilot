# frozen_string_literal: true

require "net/http"

module Docupilot
  class Request
    class Failure < StandardError; end

    attr_reader :attributes, :headers, :base_path, :path, :response

    def initialize(base_path)
      @headers = { "apikey" => Docupilot.config.api_key }
      @base_path = base_path
    end

    def get(path)
      perform_request(path) { Net::HTTP.get(uri, headers) }
    end

    def post(path, attributes)
      perform_request(path) do
        Net::HTTP.post(uri, attributes.to_json, **headers, "Content-Type" => "application/json").body
      end
    end

    def put(path, attributes)
      perform_request(path) do
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Put.new(uri, **headers, "Content-Type" => "application/json")
        request.body = attributes.to_json
        https.request(request).body
      end
    end

    def upload(path, file)
      perform_request(path) do
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri, headers)
        request.set_form([["file", File.open(file)]], "multipart/form-data")
        https.request(request).body
      end
    end

    private

    def uri
      @uri ||= URI [Docupilot.config.end_point, base_path, path].join("/").delete_suffix("/")
    end

    def handle_response
      parsed_response = JSON.parse(response, symbolize_names: true)

      return parsed_response[:data] if parsed_response[:status] == "success"

      raise Failure, parsed_response[:data]
    end

    def perform_request(path)
      @path = path
      @response = yield
      handle_response
    end
  end
end
