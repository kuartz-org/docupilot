# frozen_string_literal: true

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
      Folder.new(@folder) if @folder
    end

    def schema
      Request.new(BASE_PATH).get("#{id}/schema")
    end

    def upload_content(file)
      Request.new(BASE_PATH).file_upload("#{id}/content", file)
    end

    private

    def all_attributes
      return super unless folder

      attrs = super
      attrs[:folder] = folder.id.to_s
      attrs
    end
  end
end
