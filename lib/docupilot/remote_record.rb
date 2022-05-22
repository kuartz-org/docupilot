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
        new Request.new(self.class::BASE_PATH).get(id)
      end

      def create(attributes)
        new Request.new(self.class::BASE_PATH).post("", attributes)
      end
    end

    def initialize(attributes = {})
      attributes.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end

    def save
      new_record? ? create(all_attributes) : update(all_attributes)
    end

    def created_time
      Time.zone.parse(@created_time) if @created_time
    end

    def created_time=(created_time)
      @created_time = created_time.is_a?(String) ? created_time : created_time&.iso8601
    end

    def new_record?
      !id
    end

    def update(attributes)
      saved_attributes = Request.new(self.class::BASE_PATH).put(id, attributes)

      saved_attributes.keys.each_with_object(self) do |attribute, record|
        record.public_send("#{attribute}=", saved_attributes[attribute])
      end

      self
    end

    private

    def all_attributes
      self.class::ATTRIBUTES.each_with_object({}) do |attribute, attributes|
        attributes[attribute] = public_send(attribute) if public_send(attribute)
      end
    end

    def create(attributes)
      saved_attributes = Request.new(self.class::BASE_PATH).post("", attributes)

      saved_attributes.keys.each_with_object(self) do |attribute, record|
        record.public_send("#{attribute}=", saved_attributes[attribute])
      end

      self
    end
  end
end
