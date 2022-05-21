# frozen_string_literal: true

module Docupilot
  class Folder < RemoteRecord
    attr_reader :name

    class << self
      def base_path
        :folders
      end
    end
  end
end
