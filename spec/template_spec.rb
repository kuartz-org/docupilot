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

  describe ".all" do
    before do
      allow(Docupilot::Request).to receive(:new).with(described_class::BASE_PATH).
      and_return(request)

      allow(request).to receive(:get).with("").and_return([
        { id: 1, title: "Base Lease template", created_time: Time.now.iso8601 },
        { id: 2, title: "CONDE Lease template", created_time: Time.now.iso8601 }
      ])
    end

    context "With template collection" do
      let(:template_one) { described_class.new(id: 1, title: "Base Lease template", created_time: Time.now.iso8601) }
      let(:template_two) { described_class.new(id: 2, title: "CONDE Lease template", created_time: Time.now.iso8601) }
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "return collection of templates" do
        expect(described_class.all.class).to eq Array
        expect(described_class.all.first.class).to eq described_class
        expect(described_class.all.first.id).to eq 1
        expect(described_class.all.first.title).to eq "Base Lease template"
      end
    end
  end
end
