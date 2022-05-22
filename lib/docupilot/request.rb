# frozen_string_literal: true

module Docupilot
  class Request
    class Failure < StandardError; end

    attr_reader :attributes, :headers, :base_path, :path, :response

    def initialize(base_path)
      @headers = { "apikey" => Docupilot.config.api_key }
      @base_path = base_path
    end

    def get(path)
      @path = path
      @response = Net::HTTP.get(uri, headers)
      handle_response
    end

    def post(path, attributes)
      @path = path
      @response = Net::HTTP.post(uri, attributes, **headers, "Content-Type" => "application/json").body
      handle_response
    end

    def put(path, attributes)
      @path = path
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Put.new(uri, **headers, "Content-Type" => "application/json")
      request.body = attributes.to_json
      @response = https.request(request).body
      handle_response
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
  end
end
