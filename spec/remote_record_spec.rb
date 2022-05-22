# frozen_string_literal: true

RSpec.describe Docupilot::RemoteRecord do
  describe "#new_record?" do
    it "true for new reocrd" do
      expect(described_class.new.new_record?).to be true
    end

    it "false for persisted record" do
      expect(described_class.new(id: 1).new_record?).to be false
    end
  end
end
