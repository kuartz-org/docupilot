# frozen_string_literal: true

RSpec.describe Docupilot::Template do
  it "has a base path set to :templates" do
    expect(described_class::BASE_PATH).to eq :templates
  end

  describe "#save" do
    before do
      allow(Docupilot::Request).to receive(:new).with(described_class::BASE_PATH).
        and_return(request)

      allow(request).to receive(:post).with("", { title: template.title }).
        and_return(
          id: 1,
          title: "Lease template",
          created_time: Time.now.iso8601
        )

      allow(request).to receive(:put).with(1, { title: "New title" }).
        and_return(
          id: 1,
          title: "New title",
          created_time: Time.now.iso8601
        )
    end

    context "new template" do
      let(:template) { described_class.new(title: "Lease template") }
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "is saved and return template with id" do
        template.save
        expect(template.id).not_to be nil
      end
    end

    context "persisted template" do
      let(:template) { described_class.new(title: "Lease template", id: 1) }
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "is saved and return template with new title" do
        template.title = "New title"
        template.save

        expect(template.title).to eq "New title"
      end
    end
  end

  # describe ".all"
end
