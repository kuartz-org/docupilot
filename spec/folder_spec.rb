# frozen_string_literal: true

RSpec.describe Docupilot::Folder do
  it "has a base path set to :folders" do
    expect(described_class::BASE_PATH).to eq :folders
  end

  describe "#save" do
    before do
      allow(Docupilot::Request).to receive(:new).with(described_class::BASE_PATH).
        and_return(request)

      allow(request).to receive(:post).with("", { name: folder.name }).
        and_return(
          id: 1,
          name: "dev"
        )

      allow(request).to receive(:put).with(1, { name: "New name" }).
        and_return(
          id: 1,
          name: "New name"
        )
    end

    context "new folder" do
      let(:folder) { described_class.new(name: "dev") }
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "is saved and return folder with id" do
        folder.save
        expect(folder.id).not_to be nil
      end
    end

    context "persisted folder" do
      let(:folder) { described_class.new(name: "folder", id: 1) }
      let(:request) { Docupilot::Request.new(described_class::BASE_PATH) }

      it "is saved and return folder with new name" do
        folder.name = "New name"
        folder.save

        expect(folder.name).to eq "New name"
      end
    end
  end
end
