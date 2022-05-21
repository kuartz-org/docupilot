# frozen_string_literal: true

module Docupilot
  class Folder < RemoteRecord
    ATTRIBUTES = %i[
      name
    ].freeze

    attr_accessor *ATTRIBUTES

    class << self
      def base_path
        :folders
      end
    end
  end
end
