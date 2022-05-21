# frozen_string_literal: true

module Docupilot
  class RequestFailure < StandardError; end

  class RemoteRecord
    attr_reader :id

    class << self
      def all
        request ""
      end

      def find(id)
        new request(id)
      end

      def base_path
        ""
      end

      private

      def headers
        { "apikey" => Docupilot.config.api_key }
      end

      def request(path)
        uri = URI [Docupilot.config.end_point, base_path, path].join("/").delete_suffix("/")
        response = Net::HTTP.get(uri, headers)
        parsed_response = JSON.parse(response, symbolize_names: true)

        return parsed_response[:data] if parsed_response[:status] == "success"

        raise RequestFailure.new(parsed_response[:data])
      end
    end

    def initialize(attributes = {})
      attributes.keys.each do |attribute|
        instance_variable_set("@#{attribute}", attributes[attribute])
      end
    end

    def created_time
      Time.zone.parse(@created_time)
    end
  end
end
