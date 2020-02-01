require 'spec_helper'

describe "Parsing Ruby code", ruby: true do
  it "returns false for invalid code" do
    Language::Ruby.should_not be_parsing <<CODE
def answer()
  42
CODE
  end

  it "returns true for valid code" do
    expect(Language::Ruby).to be_parsing <<CODE
def answer()
  42
end
CODE
  end

  it "returns true for no code" do
    expect(Language::Ruby).to be_parsing ""
  end
end
