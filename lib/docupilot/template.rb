# frozen_string_literal: true

module Docupilot
  class Template < RemoteRecord
    ATTRIBUTES = %i[
      auto_number
      dynamic_images
      flatten_pdf
      footer
      format
      header
      height
      margin
      name
      no_of_pages
      orientation
      output_type
      password
      timezone
      trashed
      width
      description
      document_status
      folder
      output_file_name
      title
      type
    ].freeze

    attr_accessor *ATTRIBUTES

    class << self
      def base_path
        :templates
      end

      def find_schema(id)
        request "#{id}/schema"
      end
    end

    def folder
      Folder.new(@folder)
    end

    private

    def attributes
      attrs = super
      attrs[:folder] = folder.id.to_s
      attrs
    end
  end
end
