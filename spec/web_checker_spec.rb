require "spec_helper"

RSpec.describe WebChecker do
  it "has a version number" do
    expect(WebChecker::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
