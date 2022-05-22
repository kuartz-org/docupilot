# frozen_string_literal: true

require_relative "request"

module Docupilot
  class RemoteRecord
    attr_accessor :id

    class << self
      def all
        request("").map do |record_attributes|
          new record_attributes
        end
      end

      def find(id)
        new Request.new(base_path).get(id)
      end

      def create(attributes)
        Request.new(base_path).post("", attributes)
      end

      def update(id, attributes)
        Request.new(base_path).put(id, attributes)
        attributes
      end

      private

      def base_path
        ""
      end
    end

    def initialize(attributes = {})
      attributes.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end

    def save
      persisted? ? update : create
    end

    def created_time
      Time.zone.parse(@created_time) if @created_time
    end

    def created_time=(created_time)
      @created_time = created_time.is_a?(String) ? created_time : created_time&.iso8601
    end

    def persisted?
      !!id
    end

    private

    def attributes
      self.class::ATTRIBUTES.each_with_object({}) do |attribute, attributes|
        attributes[attribute] = public_send(attribute) if public_send(attribute)
      end
    end

    def create
      saved_attributes = self.class.create(attributes)

      saved_attributes.keys.each_with_object(self) do |attribute, record|
        record.public_send("#{attribute}=", saved_attributes[attribute])
      end
    end

    def update
      saved_attributes = self.class.update(id, attributes)

      saved_attributes.keys.each_with_object(self) do |attribute, record|
        record.public_send("#{attribute}=", saved_attributes[attribute])
      end
    end
  end
end
