# frozen_string_literal: true

RSpec.describe Docupilot::Template do
  it "has a base path set to :templates" do
    expect(described_class::BASE_PATH).to eq :templates
  end

  describe ".all" do
    before do
      allow(Docupilot::Request).to receive(:new).with(described_class::BASE_PATH).
        and_return(request)

      allow(request).to receive(:get).with("").and_return(
        [
          { id: 1, title: "Base Lease template", created_time: Time.now.iso8601 },
          { id: 2, title: "CONDE Lease template", created_time: Time.now.iso8601 }
        ]
      )
    end

    context "With template collection" do
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "return collection of templates" do
        templates = described_class.all

        expect(templates.class).to eq Array
        expect(templates.first.class).to eq described_class
        expect(templates.first.id).to eq 1
        expect(templates.first.title).to eq "Base Lease template"
      end
    end
  end

  describe ".find" do
    before do
      allow(Docupilot::Request).to receive(:new).with(described_class::BASE_PATH).
        and_return(request)

      allow(request).to receive(:get).with(1).and_return(
        id: 1, title: "Base Lease template", created_time: Time.now.iso8601
      )
    end

    context "With request" do
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "return a template" do
        template = described_class.find(1)

        expect(template.class).to eq described_class
        expect(template.id).to eq 1
        expect(template.title).to eq "Base Lease template"
      end
    end
  end

  describe ".create" do
    before do
      allow(Docupilot::Request).to receive(:new).with(described_class::BASE_PATH).
        and_return(request)

      allow(request).to receive(:post).with("", { title: "Base Lease template" }).and_return(
        id: 1, title: "Base Lease template", created_time: Time.now.iso8601
      )
    end

    context "With request" do
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "return a template" do
        template = described_class.create({ title: "Base Lease template" })

        expect(template.class).to eq described_class
        expect(template.id).to eq 1
        expect(template.title).to eq "Base Lease template"
      end
    end
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

  describe "#folder" do
    let(:template) { described_class.new(title: "Lease template", id: 1, folder: { id: 1, name: "dev" }) }

    it "returns a folder" do
      expect(template.folder.class).to eq Docupilot::Folder
    end
  end
end
