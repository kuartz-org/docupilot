# frozen_string_literal: true

module Docupilot
  class RequestFailure < StandardError; end

  class RemoteRecord
    attr_accessor :id

    class << self
      def all
        request("").map do |record_attributes|
          new record_attributes
        end
      end

      def find(id)
        new request(id)
      end

      def create(attributes)
        request("", :post, attributes)
      end

      def update(id, attributes)
        request(id, :put, attributes)
        attributes
      end

      def base_path
        ""
      end

      private

      def headers
        { "apikey" => Docupilot.config.api_key }
      end

      def request(path, action = :get, attributes = {})
        uri = URI [Docupilot.config.end_point, base_path, path].join("/").delete_suffix("/")

        response = case action
                   when :get then Net::HTTP.get(uri, headers)
                   when :post then Net::HTTP.post(uri, attributes).body
                   when :put then put_request(uri, attributes).body
                   end

        parsed_response = JSON.parse(response, symbolize_names: true)

        return parsed_response[:data] if parsed_response[:status] == "success"

        raise RequestFailure.new(parsed_response[:data])
      end

      def put_request(uri, attributes)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Put.new(uri, **headers, "Content-Type" => "application/json")
        request.body = attributes.to_json
        https.request(request)
      end
    end

    def initialize(attributes = {})
      attributes.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end

    def save
      saved_attributes = persisted? ? self.class.update(id, attributes) : self.class.create(attributes)

      saved_attributes.keys.each_with_object(self) do |attribute, record|
        record.public_send("#{attribute}=", saved_attributes[attribute])
      end
    end

    def created_time
      Time.zone.parse(@created_time)
    end

    def created_time=(created_time)
      @created_time = created_time.is_a?(String) ? created_time : created_time&.iso8601
    end

    def persisted?
      !!id
    end

    private

    def attributes
      self.class::ATTRIBUTES.each_with_object({}) do |attribute, attributes|
        attributes[attribute] = public_send(attribute) if public_send(attribute)
      end
    end
  end
end
