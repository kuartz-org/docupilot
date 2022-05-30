# frozen_string_literal: true

require "open-uri"

module Docupilot
  class Template < RemoteRecord
    BASE_PATH = :templates
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

    attr_accessor(*ATTRIBUTES)

    def folder
      return @folder if @folder.is_a? Folder

      @folder = Folder.new(@folder)
    end

    def schema
      response = Request.new(BASE_PATH).get("#{id}/schema")
      response[:schema]
    end

    def upload_content(file)
      Request.new(BASE_PATH).upload("#{id}/content", file)
    end

    def merge_document(attributes)
      Request.new(BASE_PATH).post("#{id}/merge", attributes)
    end

    private

    def all_attributes
      return super unless folder

      super.tap { |attributes| attributes[:folder] = folder.id.to_s }
    end
  end
end
