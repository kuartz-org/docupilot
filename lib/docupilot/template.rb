# frozen_string_literal: true

module Docupilot
  class Template < RemoteRecord
    ATTRIBUTES = %i[
      title
      description
      folder
      name
      type
      document_status
      trashed
      output_file_name
      output_type
      flatten_pdf
      format
      orientation
      timezone
      auto_number
      header
      footer
      password
      margin
      no_of_pages
      width
      height
      dynamic_images
    ].freeze

    attr_reader *ATTRIBUTES

    class << self
      def base_path
        :templates
      end

      def find_schema(id)
        request "#{id}/schema"
      end
    end
  end
end
