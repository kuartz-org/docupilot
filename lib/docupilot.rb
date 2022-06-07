# frozen_string_literal: true

require "uri"
require_relative "docupilot/version"

module Docupilot
  autoload :Configuration, "docupilot/configuration"
  autoload :Request, "docupilot/request"
  autoload :RemoteRecord, "docupilot/remote_record"
  autoload :Template, "docupilot/template"
  autoload :Folder, "docupilot/folder"

  class Error < StandardError; end

  def self.configure
    yield Configuration
  end

  def self.config
    Configuration
  end
end
