# frozen_string_literal: true

require "uri"
require_relative "docupilot/version"
require_relative "docupilot/configuration"

module Docupilot
  class Error < StandardError; end

  def self.configure
    yield Docupilot::Configuration
  end

  def self.config
    Docupilot::Configuration
  end
end

require "docupilot/request"
require "docupilot/remote_record"
require "docupilot/template"
require "docupilot/folder"
