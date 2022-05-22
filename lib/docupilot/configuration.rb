# frozen_string_literal: true

module Docupilot
  module Configuration
    def self.api_key
      @api_key
    end

    def self.api_key=(api_key)
      @api_key = api_key
    end

    def self.secret_key
      @secret_key
    end

    def self.secret_key=(secret_key)
      @secret_key = secret_key
    end

    def self.end_point
      @end_point
    end

    def self.end_point=(end_point)
      @end_point = end_point
    end

    DEFAULT = {
      end_point: "https://api.docupilot.app/api/v1"
    }.freeze

    DEFAULT.each do |param, default_value|
      send("#{param}=", default_value)
    end
  end
end
