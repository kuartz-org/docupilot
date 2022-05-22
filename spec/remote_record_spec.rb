# frozen_string_literal: true

RSpec.describe Docupilot::RemoteRecord do
  describe "#new_record?" do
    it "returns true for new reocrd" do
      expect(described_class.new.new_record?).to be true
    end

    it "returns false for persisted record" do
      expect(described_class.new(id: 1).new_record?).to be false
    end
  end

  describe "#created_time" do
    it "returns a time object" do
      time = Time.now.iso8601
      expect(described_class.new(created_time: time ).created_time).to eq Time.parse(time)
    end
  end
end
