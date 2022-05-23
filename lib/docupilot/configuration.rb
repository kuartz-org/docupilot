# frozen_string_literal: true

module Docupilot
  module Configuration
    class << self
      attr_accessor :api_key, :secret_key, :end_point
    end

    DEFAULT = {
      end_point: "https://api.docupilot.app/api/v1"
    }.freeze

    DEFAULT.each do |param, default_value|
      send("#{param}=", default_value)
    end
  end
end
