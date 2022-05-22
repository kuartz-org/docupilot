# frozen_string_literal: true

module Docupilot
  class Folder < RemoteRecord
    BASE_PATH = :folders
    ATTRIBUTES = %i[name].freeze

    attr_accessor(*ATTRIBUTES)
  end
end
