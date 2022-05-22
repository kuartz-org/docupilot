# frozen_string_literal: true

RSpec.describe Docupilot::Configuration do
  it "can set and read api_key" do
    Docupilot.configure do |config|
      config.api_key = "abc"
    end

    expect(Docupilot.config.api_key).to eq "abc"
  end

  it "can set and read secret_key" do
    Docupilot.configure do |config|
      config.secret_key = "secret"
    end

    expect(Docupilot.config.secret_key).to eq "secret"
  end

  it "has a default default end point" do
    expect(Docupilot.config.end_point).to eq "https://api.docupilot.app/api/v1"
  end
end
